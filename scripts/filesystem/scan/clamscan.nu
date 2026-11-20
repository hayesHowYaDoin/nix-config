# Pure ClamAV scan. Standalone `clamscan` binary — loads sigs, scans
# one file, exits. No daemon, no socket, no ConcurrentDatabaseReload.
# Right tool for our ephemeral-VM-per-scan model.
# One file in, {output, exit_code} out. Caller handles I/O.

export def main [file: path] {
  let r = (^clamscan --no-summary --database=/var/lib/clamav $file | complete)
  if $r.exit_code == 1 {
    let sig = (
      $r.stdout | parse --regex '.*: (?<sig>.+) FOUND'
      | get sig?.0? | default "unknown"
    )
    return {output: $"fail: clamav ($sig)", exit_code: 1}
  }
  if $r.exit_code != 0 {
    return {output: $"error: ($r.stderr | str trim)", exit_code: 2}
  }
  {output: "pass", exit_code: 0}
}
