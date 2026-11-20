#!/usr/bin/env nu

# VM-side scanner orchestrator. Runs once at microVM boot, triggered by
# systemd. Picks the single file sitting in /torrent-scan/queue, runs
# every configured scanner in order, writes the verdict back to
# /torrent-scan/done/, then powers off the VM.
#
# This script always ends by calling `systemctl poweroff` — in success,
# error, or no-work paths. Any failure that doesn't terminate the script
# would leave the VM stuck forever.
#
# Adding a new scanner for later phases (yara, falco, etc.) means: add
# `use ./<new>.nu` + a call in the sequence below.

use ./clamscan.nu
use ./yara.nu

# Log file lives on the host via virtiofs — survives VM poweroff.
# Every runner invocation appends here so we have post-mortem visibility.
const LOG = "/torrent-scan/runner.log"

def log [msg: string] {
  let line = $"(date now | format date '%Y-%m-%d %H:%M:%S') ($msg)"
  print $line
  $line + "\n" | save --append --raw $LOG
}

def log-meminfo [tag: string] {
  let info = (
    open --raw /proc/meminfo
    | lines
    | where ($it | str starts-with "MemTotal:") or ($it | str starts-with "MemFree:") or ($it | str starts-with "MemAvailable:")
    | str join " | "
  )
  log $"meminfo [($tag)]: ($info)"
}

def run-job [] {
  log "run-job: start"
  log-meminfo "start"

  let jobs = (ls /torrent-scan/queue | where type == file)
  if ($jobs | is-empty) {
    log "run-job: no files in queue, nothing to do"
    return
  }

  let job = ($jobs | first)
  let id = ($job.name | path basename)
  log $"run-job: picked ($id)"

  log "run-job: invoking clamscan"
  log-meminfo "pre-clamscan"
  let clam = (clamscan $job.name)
  log-meminfo "post-clamscan"
  log $"run-job: clamscan exit=($clam.exit_code) output=($clam.output)"

  # ClamAV fail is decisive — don't bother running yara.
  let r = if $clam.exit_code == 1 {
    $clam
  } else if $clam.exit_code != 0 {
    # ClamAV errored. Still try yara so one engine's bad day doesn't
    # mean no scan happened. If yara also errors we'll surface the
    # original clamscan error.
    log "run-job: clamscan errored, trying yara anyway"
    log-meminfo "pre-yara"
    let y = (yara $job.name)
    log-meminfo "post-yara"
    log $"run-job: yara exit=($y.exit_code) output=($y.output)"
    if $y.exit_code == 1 { $y } else { $clam }
  } else {
    log "run-job: invoking yara"
    log-meminfo "pre-yara"
    let y = (yara $job.name)
    log-meminfo "post-yara"
    log $"run-job: yara exit=($y.exit_code) output=($y.output)"
    $y
  }

  log $"run-job: final verdict exit=($r.exit_code) output=($r.output)"

  $r.output    | save -f --raw $"/torrent-scan/done/($id).out"
  $r.exit_code | save -f --raw $"/torrent-scan/done/($id).exit"
  rm $job.name
  log "run-job: done file written, queue cleared"
}

def main [] {
  mkdir /torrent-scan/done
  log "=== runner boot ==="
  try { run-job } catch {|e|
    log $"runner exception: ($e.msg)"
  }
  log "powering off"
  ^systemctl poweroff
}
