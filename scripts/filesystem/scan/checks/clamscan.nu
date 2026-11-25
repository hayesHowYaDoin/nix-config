# Pure ClamAV scan. Standalone `clamscan` binary — loads sigs, scans
# one file, exits. No daemon, no socket, no ConcurrentDatabaseReload.
# Right tool for our ephemeral-VM-per-scan model.
#
# Returns the shared scanner-result record:
#   {scanner: "clamscan", status: "clean"|"match"|"error", detail: string}

export def main [file: path] {
  let r = (^clamscan --no-summary --database=/var/lib/clamav $file | complete)
  if $r.exit_code == 1 {
    let sig = (
      $r.stdout | parse --regex '.*: (?<sig>.+) FOUND'
      | get sig?.0? | default "unknown"
    )
    return {scanner: "clamscan", status: "match", detail: $sig}
  }
  if $r.exit_code != 0 {
    return {scanner: "clamscan", status: "error", detail: ($r.stderr | str trim)}
  }
  {scanner: "clamscan", status: "clean", detail: ""}
}
