#!/usr/bin/env nu

# Service entry point. For each new or changed file under --downloads, run
# scan.nu with VirusTotal enabled. Pass -> hardlink into --staging (same
# relative path). Fail -> move the file into --quarantine. Scan errors are
# logged and the file is left alone so the next invocation retries it.
#
# Files deleted from --downloads are mirrored: their staging hardlinks
# are removed, and empty parent dirs are pruned.
#
# State is persisted at --state-file as nuon-encoded text so subsequent
# runs skip files that are unchanged.

use ../notify.nu

def unlink-staging [staging: path, rel: path] {
  let link = ($staging | path join $rel)
  if ($link | path exists) { rm $link }

  # Walk tree until $staging
  mut dir = ($link | path dirname)
  while $dir != $staging {
    let r = (^rmdir $dir | complete)
    if $r.exit_code != 0 { break }
    $dir = ($dir | path dirname)
  }
}

def main [
  --downloads: path = /var/lib/qbittorrent/downloads
  --staging: path = /var/lib/qbittorrent/staging
  --quarantine: path = /var/lib/qbittorrent/quarantine
  --state-file: path = /var/lib/qbittorrent/state.txt
  --scan-script: path = scan.nu   # absolute path or name-on-PATH
  --vt-api-key-file: path         # forwarded to scan-script
  --ntfy-url-file: string = ""    # file containing the ntfy topic URL; empty to disable
] {
  mkdir $staging
  mkdir $quarantine
  mkdir ($state_file | path dirname)

  # Resolve the sops-managed URL once; empty string = ntfy disabled.
  let ntfy_url = (notify url-from-file $ntfy_url_file)

  # ls with a glob errors if nothing matches, so guard the glob with a
  # non-glob check first. Empty downloads dir is normal, not exceptional.
  let current = if ($downloads | path exists) and (not (ls $downloads | is-empty)) {
    ls --all $"($downloads)/**/*"
    | where type == file
    | select name modified size
  } else { [] }

  let prev = if ($state_file | path exists) {
    try {
      open --raw $state_file | from nuon
      | reduce --fold {} {|it, acc|
          $acc | upsert $it.name {modified: $it.modified, size: $it.size}
        }
    } catch {
      print -e "state file corrupt; starting fresh"
      {}
    }
  } else { {} }

  def unchanged? [it: record] {
    let p = ($prev | get -o $it.name)
    $p != null and $p.modified == $it.modified and $p.size == $it.size
  }

  let unchanged = ($current | where {|it| unchanged? $it })
  let to_scan = ($current | where {|it| not (unchanged? $it) })

  # Mirror deletions: anything in prev but not in current gets its staging
  # hardlink removed (and empty parent dirs pruned).
  let current_names = ($current | get name)
  for p in ($prev | columns) {
    if $p not-in $current_names {
      let rel = ($p | path relative-to $downloads)
      unlink-staging $staging $rel
      print $"remove: ($rel)"
    }
  }

  let processed = ($to_scan | each {|it|
    try {
      let rel = ($it.name | path relative-to $downloads)
      let r = (^$scan_script $it.name --vt-api-key-file $vt_api_key_file | complete)
      match $r.exit_code {
        0 => {
          let dst = ($staging | path join $rel)
          mkdir ($dst | path dirname)
          ln -f $it.name $dst
          print $"pass: ($rel)"
          notify publish $ntfy_url $rel --title "blackbart staged" --priority "low" --tags "inbox_tray"
          $it
        }
        1 => {
          let dst = ($quarantine | path join $rel)
          mkdir ($dst | path dirname)
          mv $it.name $dst
          # Also prune any staging link from a prior pass.
          unlink-staging $staging $rel
          let out = ($r.stdout | str trim)
          let err = ($r.stderr | str trim)
          print $"fail: ($rel): ($out) ($err)"
          notify publish $ntfy_url $"($rel)\n($out)" --title "blackbart quarantine" --priority "high" --tags "warning,skull"
          null
        }
        3 => {
          # Scan completed but at least one scanner was degraded. Stage
          # the file like a pass — nothing hostile was detected — but
          # surface the degradation so it doesn't go unnoticed. Full
          # per-scanner detail lives in the VM's reports.ndjson.
          let dst = ($staging | path join $rel)
          mkdir ($dst | path dirname)
          ln -f $it.name $dst
          let out = ($r.stdout | str trim)
          print $"warn: ($rel): ($out)"
          notify publish $ntfy_url $"($rel)\n($out)" --title "blackbart staged (warning)" --tags "warning"
          $it
        }
        _ => {
          print -e $"error: ($rel): exit ($r.exit_code): ($r.stdout | str trim) ($r.stderr | str trim)"
          null
        }
      }
    } catch {|e|
      print -e $"exception: ($it.name): ($e.msg)"
      null
    }
  } | compact)

  ($unchanged | append $processed)
  | to nuon
  | save -f --raw $state_file
}
