# Materialize top-level packages from scripts/ at /etc/nu/<pkg> and set
# NU_LIB_DIRS both for login shells (environment.sessionVariables) and
# every systemd unit (systemd.globalEnvironment). Services that invoke
# nushell inherit NU_LIB_DIRS without needing to know the detail.
#
# Usage from another aspect:
#   includes = [hayes.scripts];
#   nixos = {...}: { nu.enabledPackages = ["filesystem"]; };
#
# Multiple aspects can each include scripts and contribute packages;
# nu.enabledPackages is list-merged by nix, and den dedupes repeated
# inclusions of the same aspect. The computed NU_LIB_DIRS reads the
# merged list, so it only ever has one value.
{
  hayes.scripts.nixos = {
    self,
    config,
    lib,
    ...
  }: let
    prefix = "nu";
    pkgs = config.nu.enabledPackages;
    libDirs = lib.concatStringsSep ":" (
      ["/etc/${prefix}"]
      ++ (map (p: "/etc/${prefix}/${p}") (lib.unique pkgs))
    );
  in {
    options.nu.enabledPackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Top-level directories under scripts/ to install into /etc/${prefix}.";
    };

    config = {
      environment.etc = lib.listToAttrs (map (pkg: {
          name = "${prefix}/${pkg}";
          value = {
            source = "${self}/scripts/${pkg}";
            mode = "0755";
          };
        })
        (lib.unique pkgs));

      environment.sessionVariables.NU_LIB_DIRS = libDirs;
      systemd.globalEnvironment.NU_LIB_DIRS = libDirs;
    };
  };
}
