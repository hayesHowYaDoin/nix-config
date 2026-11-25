# checks — individual verdict-producing scanners. Each check's `main`
# takes a file path and returns the shared scanner-result record:
#   {scanner: string, status: "clean"|"match"|"warn"|"error", detail: string}
#
# Adding a new check: drop it in this directory, export a `main` with
# the contract above, and add an `export module` line here.

export module clamscan.nu
export module yara.nu
export module mime-check.nu
export module hash-lookup.nu
export module virus-total.nu
