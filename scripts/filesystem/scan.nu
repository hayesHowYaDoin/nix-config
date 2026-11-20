#!/usr/bin/env nu

# Layered scan pipeline. Each layer either produces a verdict or falls
# through to the next. Ordered cheapest-first and most-decisive-first:
#
#   1. MIME / extension sanity check. Catches trojans trivially
#      (.mkv that is really a PE) and lets us fast-path real media
#      without burning deeper scans on it.
#   2. CIRCL HashLookup. Free, unlimited, decides most known-good and
#      a chunk of known-bad on SHA-256 alone.
#   3. VirusTotal hash lookup. Pays the rate-limit cost only for files
#      the cheaper layers couldn't settle.
#   4. Sandbox (nspawn container + ClamAV + YARA). Last resort.
#
# Prints the verdict on stdout, exits 0 (pass), 1 (fail), 2 (scan error).

use ./scan/mime-check.nu mime-classify
use ./scan/hash-lookup.nu hashlookup-check
use ./scan/virus-total.nu vt-check
use ./scan/sandbox.nu dispatch

def main [
  file: path
  --vt-api-key-file: path                      # file containing the VT API key
  --vt-malicious-threshold: int = 0
  --vt-suspicious-threshold: int = 2
  --shared-dir: path = /var/lib/torrent-scan
  --timeout-sec: int = 600
] {
  print -e $"scan.nu: file=($file)"

  # Layer 1: MIME / extension sanity.
  let m = (try { mime-classify $file } catch {|e|
    print -e $"scan.nu: mime-classify threw: ($e.msg)"
    {verdict: "unknown" class: "binary"}
  })
  print -e $"scan.nu: mime verdict=($m.verdict) class=($m.class? | default '')"
  if $m.verdict == "fail" {
    print $"fail: ($m.reason)"
    exit 1
  }
  # Known media/text with matching content — trust and skip deep scan.
  # Anything that sniffs as a binary or archive falls through regardless
  # of extension.
  if $m.verdict == "pass" and ($m.class in ["media" "text"]) {
    print "pass"
    return
  }

  # Layer 2: CIRCL HashLookup.
  let h = (try { hashlookup-check $file } catch {|e|
    print -e $"scan.nu: hashlookup threw: ($e.msg)"
    {verdict: "unknown"}
  })
  print -e $"scan.nu: hashlookup verdict=($h.verdict)"
  if $h.verdict == "fail" {
    print $"fail: ($h.reason)"
    exit 1
  }
  if $h.verdict == "pass" {
    print "pass"
    return
  }

  # Layer 3: VirusTotal.
  let api_key = (open --raw $vt_api_key_file | str trim)
  let v = (try {
    vt-check $file $api_key $vt_malicious_threshold $vt_suspicious_threshold
  } catch {|e|
    print -e $"scan.nu: vt-check threw: ($e.msg)"
    exit 2
  })
  print -e $"scan.nu: vt verdict=($v.verdict) reason=($v.reason? | default '') detail_len=($v.detail? | default '' | str length)"

  match $v.verdict {
    "pass" => { print "pass" }
    "fail" => {
      print $"fail: ($v.reason)"
      if ($v.detail | str length) > 0 { print $v.detail }
      exit 1
    }
    "unknown" => {
      print -e $"scan.nu: dispatching to sandbox"
      dispatch $file --shared-dir $shared_dir --timeout-sec $timeout_sec
    }
    _ => {
      print -e $"scan.nu: unmatched verdict '($v.verdict)' — bailing"
      exit 2
    }
  }
}
