# Generic ntfy publisher. Each topic is its own URL (host + topic path),
# so one call site can send to any number of topics by varying the url.
# Never raises — a notification failure must not fail its caller.

# Fire-and-forget POST to an ntfy topic URL.
# An empty url is a silent no-op, so a sops-managed secret that isn't
# yet provisioned doesn't break the pipeline.
export def publish [
  url: string                 # full ntfy topic URL (e.g. https://ntfy.sh/mytopic)
  message: string
  --title: string = ""
  --priority: string = "default"   # min | low | default | high | max | urgent
  --tags: string = ""         # comma-separated emoji shortcodes
] {
  if ($url | is-empty) { return }

  mut headers = {}
  if not ($title | is-empty)    { $headers = ($headers | insert "Title" $title) }
  if not ($priority | is-empty) { $headers = ($headers | insert "Priority" $priority) }
  if not ($tags | is-empty)     { $headers = ($headers | insert "Tags" $tags) }

  try {
    http post --content-type "text/plain" --headers $headers $url $message
  } catch {|e|
    print -e $"notify: POST failed: ($e.msg)"
  }
}

# Convenience for sops-managed URLs: read a topic URL from a file.
# Missing/empty file yields "" so publish degrades to a no-op.
export def url-from-file [path: string]: nothing -> string {
  if ($path | is-empty) or (not ($path | path exists)) { return "" }
  try { open --raw $path | str trim } catch { "" }
}
