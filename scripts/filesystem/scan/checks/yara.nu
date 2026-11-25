# YARA scan. Rules are bind-mounted at /var/lib/yara-rules read-only by
# the host (from Neo23x0/signature-base). We walk the rules dir and
# invoke yara once per rule file rather than concatenating — some rules
# in signature-base `#include` auxiliary files or reference external
# variables that don't survive naive concatenation. Per-file is slower
# but correct.
#
# Returns the shared scanner-result record:
#   {scanner: "yara", status: "clean"|"match"|"warn"|"error", detail: string}
# "warn" means the scan completed but some rule files failed to compile —
# signature-base occasionally ships rules that need modules we don't have.

const RULES_DIR = "/var/lib/yara-rules"

export def main [file: path] {
  if not ($RULES_DIR | path exists) {
    return {scanner: "yara", status: "error", detail: "rules dir missing"}
  }

  let rule_files = (
    ls $"($RULES_DIR)/**/*.yar"
    | where type == file
    | get name
  )
  if ($rule_files | is-empty) {
    return {scanner: "yara", status: "error", detail: "no rules found"}
  }

  mut matches = []
  mut skipped = []

  for rf in $rule_files {
    let r = (^yara --no-warnings $rf $file | complete)
    # yara prints `<rulename> <filepath>` per match on stdout; nonzero
    # exit means either a match (which also prints) or a compile error.
    let out = ($r.stdout | str trim)
    if ($out | str length) > 0 {
      $matches = ($matches | append $out)
    }
    if $r.exit_code != 0 and ($out | str length) == 0 {
      $skipped = ($skipped | append ($rf | path basename))
    }
  }

  if not ($matches | is-empty) {
    return {scanner: "yara", status: "match", detail: ($matches | str join "; ")}
  }

  if not ($skipped | is-empty) {
    return {
      scanner: "yara",
      status: "warn",
      detail: $"($skipped | length) rules skipped: ($skipped | str join ', ')",
    }
  }

  {scanner: "yara", status: "clean", detail: ""}
}
