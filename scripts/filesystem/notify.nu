# Fire-and-forget ntfy POST. Topic URL (including host and topic name)
# is read from a sops-managed file; absent file is a silent no-op so
# the pipeline runs fine before the secret is provisioned.
#
# Never raises — a notification failure must not fail a scan.

export def ntfy [
  url_file: string
  title: string
  message: string
  --priority: string = "high"   # default | low | min | high | max | urgent
  --tags: string = ""           # comma-separated emoji shortcodes
] {
  if ($url_file | is-empty) or (not ($url_file | path exists)) {
    return
  }
  let url = (try { open --raw $url_file | str trim } catch { "" })
  if ($url | is-empty) { return }

  mut headers = {
    "Title": $title
    "Priority": $priority
  }
  if not ($tags | is-empty) {
    $headers = ($headers | insert "Tags" $tags)
  }

  try {
    http post --content-type "text/plain" --headers $headers $url $message
  } catch {|e|
    print -e $"notify: ntfy POST failed: ($e.msg)"
  }
}
