# scan — torrent-scan pipeline library surface.
#
# Entry-point scripts (scan.nu, stage.nu, runner.nu) live alongside this
# module but are invoked as scripts rather than imported. The library
# surface exposed here is the pieces callers may reuse: the verdict
# aggregator, the sandbox dispatcher, and the checks subpackage.

export module aggregate.nu
export module sandbox.nu
export module checks
