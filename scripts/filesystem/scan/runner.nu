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
# Adding a new scanner (falco, capa, etc.) means: implement a .nu that
# returns {scanner, status, detail}, `use` it, append to SCANNERS.

use ./checks/clamscan.nu
use ./checks/yara.nu
use ./aggregate.nu

# Log file lives on the host via virtiofs — survives VM poweroff.
# Every runner invocation appends here so we have post-mortem visibility.
const LOG = "/torrent-scan/runner.log"

# Persistent per-scan report log. One nuon record per line (NDJSON-style).
# Grep or `open | lines | each { from nuon }` to inspect history on the host.
const REPORTS = "/torrent-scan/reports.ndjson"

# Scanners run in order. A `match` from any scanner short-circuits the
# rest — a decisive hit doesn't need corroboration and burning cycles on
# a confirmed-hostile file wastes the VM's time budget.
#
# Must be a function, not a const: closures capturing `use`-imported
# commands aren't parse-time constants.
def scanners [] { [
  {name: "clamscan", fn: {|f| clamscan $f }}
  {name: "yara",     fn: {|f| yara $f }}
] }

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

def run-scanners [file: path] {
  mut results = []
  for s in (scanners) {
    log $"run-job: invoking ($s.name)"
    log-meminfo $"pre-($s.name)"
    let r = (do $s.fn $file)
    log-meminfo $"post-($s.name)"
    log $"run-job: ($s.name) status=($r.status) detail=($r.detail)"
    $results = ($results | append $r)
    if $r.status == "match" {
      log $"run-job: ($s.name) matched — short-circuiting remaining scanners"
      break
    }
  }
  $results
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

  let results = (run-scanners $job.name)
  let verdict = (aggregate $results)
  log $"run-job: verdict=($verdict.status) summary=($verdict.summary)"

  # Ephemeral verdict for sandbox.nu to relay.
  $verdict | to nuon | save -f --raw $"/torrent-scan/done/($id).nuon"

  # Persistent per-scan record. Keeps per-scanner detail for any file we
  # scanned so quarantine/warn decisions can be audited later.
  let report = {
    timestamp: (date now | format date '%Y-%m-%dT%H:%M:%S%z'),
    id: $id,
    verdict: $verdict,
  }
  let line = ($report | to nuon --raw)
  $"($line)\n" | save --append --raw $REPORTS

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
