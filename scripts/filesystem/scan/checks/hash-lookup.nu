# CIRCL HashLookup — free, unlimited hash intel from circl.lu. Checks
# SHA-256 against a large corpus of known-good (NSRL + vendor-signed)
# and known-bad hashes. Faster and more generous than VirusTotal; used
# as a first-pass short-circuit so the VT quota is reserved for the
# ambiguous middle.
#
# Returns one of:
#   {verdict: "pass"}                           — known clean (e.g. NSRL)
#   {verdict: "fail", reason: "..."}            — known malicious
#   {verdict: "unknown"}                        — not in corpus; fall through

export def hashlookup-check [file: path] {
  let sha = (^sha256sum $file | split row ' ' | first | str upcase)
  let url = $"https://hashlookup.circl.lu/lookup/sha256/($sha)"

  let response = (try {
    http get --full --allow-errors --headers {Accept: "application/json"} $url
  } catch {|e|
    return {verdict: "unknown"}
  })

  if $response.status == 404 { return {verdict: "unknown"} }
  if $response.status != 200 { return {verdict: "unknown"} }

  let body = $response.body
  let trust = ($body | get -o hashlookup:trust | default null)
  let known_malicious = ($body | get -o KnownMalicious | default null)

  if $known_malicious != null {
    return {
      verdict: "fail"
      reason: $"hashlookup known-malicious: ($known_malicious)"
    }
  }

  # trust score: 0 = known-bad adjacent, 50 = unknown/neutral, 100 = NSRL/vendor-signed
  if ($trust != null) and ($trust >= 80) {
    return {verdict: "pass"}
  }

  {verdict: "unknown"}
}
