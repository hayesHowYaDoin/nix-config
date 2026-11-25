# Combine per-scanner results into a single verdict record.
#
# Policy (priority order):
#   1. Any scanner reports `match`      → status "match"
#   2. All scanners report `error`      → status "error"
#   3. Any scanner reports `warn`/`error` (mixed with clean) → status "warn"
#   4. Otherwise                        → status "clean"
#
# Returns:
#   {
#     status: "clean"|"match"|"warn"|"error",
#     summary: string,          # human-readable, suitable for ntfy
#     per_scanner: list<record>, # full per-scanner results for persistence
#   }

export def main [results: list] {
  let hits = ($results | where status == "match")
  if not ($hits | is-empty) {
    return {
      status: "match",
      summary: ($hits | each {|r| $"($r.scanner): ($r.detail)" } | str join "; "),
      per_scanner: $results,
    }
  }

  if ($results | all {|r| $r.status == "error" }) {
    return {
      status: "error",
      summary: ($results | each {|r| $"($r.scanner): ($r.detail)" } | str join "; "),
      per_scanner: $results,
    }
  }

  let degraded = ($results | where status in ["error" "warn"])
  if not ($degraded | is-empty) {
    return {
      status: "warn",
      summary: ($degraded | each {|r| $"($r.scanner) ($r.status): ($r.detail)" } | str join "; "),
      per_scanner: $results,
    }
  }

  {status: "clean", summary: "clean", per_scanner: $results}
}
