# Extension vs. content-type sanity check. A "movie.mkv" that is
# actually a PE executable is almost certainly hostile; a .srt that
# sniffs as application/x-dosexec is not a subtitle. This catches that
# whole class of trojaned media before any signature engine has to
# weigh in.
#
# Also classifies the file so scan.nu can fast-path low-risk types
# (video/audio/images almost never carry executable payloads) and
# apply deeper scrutiny to the actual risk surface.
#
# Returns:
#   {verdict: "fail", reason: "..."}   — mismatch or disallowed type
#   {verdict: "pass", class: "media"}  — safe content type, no deep scan needed
#   {verdict: "unknown", class: "..."} — needs full scan pipeline

# Extensions whose on-disk content should be one of these MIME prefixes.
# Anything else is a trojan.
const MEDIA_EXTS = {
  mkv: ["video/"]
  mp4: ["video/" "application/mp4"]
  avi: ["video/"]
  mov: ["video/"]
  webm: ["video/" "audio/"]
  m4v: ["video/"]
  ts: ["video/"]
  mpg: ["video/"]
  mpeg: ["video/"]
  mp3: ["audio/"]
  flac: ["audio/"]
  m4a: ["audio/"]
  ogg: ["audio/" "application/ogg"]
  opus: ["audio/" "application/ogg"]
  wav: ["audio/"]
  jpg: ["image/jpeg"]
  jpeg: ["image/jpeg"]
  png: ["image/png"]
  gif: ["image/gif"]
  webp: ["image/webp"]
  srt: ["text/" "application/x-subrip"]
  ass: ["text/"]
  ssa: ["text/"]
  vtt: ["text/"]
  nfo: ["text/"]
  txt: ["text/"]
}

# Extensions we refuse outright. These have no business arriving in
# a media payload; if they're here, something is wrong regardless of
# what the content is.
const BANNED_EXTS = [
  "exe" "dll" "msi" "scr" "com" "cpl" "bat" "cmd" "ps1" "vbs" "vbe"
  "js" "jse" "wsf" "wsh" "lnk" "hta" "pif" "jar" "apk" "ipa"
]

export def mime-classify [file: path] {
  let ext = ($file | path parse | get extension | str downcase)
  let mime = (^file --brief --mime-type $file | str trim)

  if $ext in $BANNED_EXTS {
    return {
      verdict: "fail"
      reason: $"banned extension .($ext) (mime ($mime))"
    }
  }

  let expected = ($MEDIA_EXTS | get -o $ext)
  if $expected != null {
    let ok = ($expected | any {|p| $mime | str starts-with $p })
    if $ok {
      return {verdict: "pass" class: "media"}
    }
    return {
      verdict: "fail"
      reason: $".($ext) content is ($mime), expected one of ($expected | str join ', ')"
    }
  }

  # Unknown extension — classify by MIME and let the rest of the
  # pipeline decide. Archives, docs, and anything else gets deep scan.
  let class = if ($mime | str starts-with "video/") or ($mime | str starts-with "audio/") or ($mime | str starts-with "image/") {
    "media"
  } else if ($mime | str starts-with "text/") {
    "text"
  } else if ($mime in ["application/zip" "application/x-rar" "application/x-7z-compressed" "application/gzip" "application/x-tar" "application/x-bzip2"]) {
    "archive"
  } else {
    "binary"
  }

  {verdict: "unknown" class: $class mime: $mime}
}
