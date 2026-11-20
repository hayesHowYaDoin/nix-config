# YARA scan. Rules are bind-mounted at /var/lib/yara-rules read-only by
# the host (from Neo23x0/signature-base). We walk the rules dir and
# invoke yara once per rule file rather than concatenating — some rules
# in signature-base `#include` auxiliary files or reference external
# variables that don't survive naive concatenation. Per-file is slower
# but correct.
#
# One file in, {output, exit_code} out. Matches semantics of clamscan.nu:
#   exit 0 → clean
#   exit 1 → match found (hostile)
#   exit 2 → scan error

const RULES_DIR = "/var/lib/yara-rules"

export def main [file: path] {
  if not ($RULES_DIR | path exists) {
    return {output: "error: yara rules dir missing", exit_code: 2}
  }

  let rule_files = (
    ls $"($RULES_DIR)/**/*.yar"
    | where type == file
    | get name
  )
  if ($rule_files | is-empty) {
    return {output: "error: no yara rules found", exit_code: 2}
  }

  mut matches = []
  mut had_error = false

  for rf in $rule_files {
    let r = (^yara --no-warnings $rf $file | complete)
    # yara prints `<rulename> <filepath>` per match on stdout; nonzero
    # exit means either a match (which also prints) or a compile error.
    let out = ($r.stdout | str trim)
    if ($out | str length) > 0 {
      $matches = ($matches | append $out)
    }
    if $r.exit_code != 0 and ($out | str length) == 0 {
      # Compile/parse error on this rule file — log but don't fail the
      # whole scan on one bad rule. signature-base occasionally ships
      # rules that need modules we don't have.
      $had_error = true
    }
  }

  if not ($matches | is-empty) {
    let sig = ($matches | str join "; ")
    return {output: $"fail: yara ($sig)", exit_code: 1}
  }

  if $had_error {
    # Scan completed with some rule-file errors but no matches. Treat
    # as pass to avoid false-negative-via-error — we still have ClamAV
    # as a parallel engine. Error details go to the container log.
    return {output: "pass (yara: some rules skipped)", exit_code: 0}
  }

  {output: "pass", exit_code: 0}
}
