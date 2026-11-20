# Host-side sandbox dispatcher. Serializes container access, submits
# one file, waits for the container to write a verdict, relays it.
#
# Companion inside the container: runner.nu (same dir).

def acquire-lock [lock: path, timeout_sec: int] {
  let deadline = ((date now) + ($timeout_sec * 1sec))
  while true {
    let r = (^ln -s held $lock | complete)
    if $r.exit_code == 0 { return }
    if (date now) > $deadline {
      error make {msg: $"timeout acquiring lock ($lock) — if a previous run crashed, rm the lockfile manually"}
    }
    sleep 1sec
  }
}

export def dispatch [
  file: path
  --shared-dir: path = /var/lib/torrent-scan
  --timeout-sec: int = 300
] {
  mkdir ($shared_dir | path join "queue")
  mkdir ($shared_dir | path join "done")

  let lock = ($shared_dir | path join "pool.lock")
  acquire-lock $lock $timeout_sec

  let result = (try {
    let id = (random uuid | str substring 0..7)
    let queue = ($shared_dir | path join "queue" $id)
    let done_exit = ($shared_dir | path join "done" $"($id).exit")
    let done_out = ($shared_dir | path join "done" $"($id).out")

    # cp not ln: /var/lib/torrent-scan and /var/lib/qbittorrent are on
    # separate bind mounts, and link(2) refuses to hardlink across mount
    # boundaries even on the same underlying filesystem. Container
    # removes the queue file after scanning so no accumulation.
    cp $file $queue

    # Start the container and wait for it to fully exit. systemctl --wait
    # blocks until the service deactivates. We *tolerate* non-zero exit
    # here because nspawn can report failure on legitimate poweroff —
    # e.g., an unmount of /run/wrappers failing at shutdown doesn't
    # invalidate a successful scan. The done file is the ground truth.
    try {
      ^systemctl start --wait container@torrent-scan.service
    } catch { }

    if not ($done_exit | path exists) {
      try { rm $queue } catch { }
      error make {msg: "container exited without writing done file — check `journalctl -u container@torrent-scan`"}
    }

    let exit_code = (open --raw $done_exit | str trim | into int)
    let output = (open --raw $done_out)
    rm $done_exit
    rm $done_out
    {ok: {output: $output, exit_code: $exit_code}}
  } catch {|e|
    {err: $e.msg}
  })

  try { rm $lock } catch { }

  if ($result.err? != null) {
    print -e $"error: ($result.err)"
    exit 2
  }

  print -n $result.ok.output
  exit $result.ok.exit_code
}
