# VirusTotal hash lookup via the official API (requires an account key).
# Looks up SHA-256 only — no file upload, no engine details leaked beyond
# the hash. Safe to run on the host (SHA-256 is not a parser attack
# surface).
#
# Free tier is 4 req/min, 500 req/day. 429 is treated as `unknown` so a
# rate-limit burst falls through to the sandbox instead of erroring out
# and looping on the next timer cycle.

export def vt-check [
  file: path
  api_key: string
  malicious_threshold: int
  suspicious_threshold: int
] {
  let sha = (^sha256sum $file | split row ' ' | first)
  let url = $"https://www.virustotal.com/api/v3/files/($sha)"
  let headers = {
    "x-apikey": $api_key
    "Accept": "application/json"
  }

  let response = (http get --full --allow-errors --headers $headers $url)

  if $response.status == 404 {
    return {verdict: "unknown"}
  }
  if $response.status == 429 {
    # Burst over the 4/min quota. Fall through to sandbox rather than
    # treating this as a scan error.
    return {verdict: "unknown"}
  }
  if $response.status != 200 {
    error make {msg: $"virustotal lookup returned status ($response.status)"}
  }

  let results = $response.body.data.attributes.last_analysis_results
  let flagged = ($results
    | transpose engine info
    | where {|r| $r.info.category in ["malicious" "suspicious"]})
  let m = ($flagged | where info.category == "malicious" | length)
  let s = ($flagged | where info.category == "suspicious" | length)

  if $m > $malicious_threshold or $s > $suspicious_threshold {
    {
      verdict: "fail"
      reason: $"virustotal ($m) malicious, ($s) suspicious out of ($results | columns | length) engines"
      detail: ($flagged
        | each {|r| $"  ($r.engine) \(($r.info.category)\): ($r.info.result)" }
        | str join (char newline))
    }
  } else {
    {verdict: "pass"}
  }
}
