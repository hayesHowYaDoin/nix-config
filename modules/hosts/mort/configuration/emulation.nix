{
  flake.modules.nixos.mort-configuration = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      tinywm
      (retroarch.withCores (cores:
        with cores; [
          beetle-gba
        ]))
    ];

    services.xserver = {
      enable = true;
      displayManager.startx.enable = true;
    };

    services.getty.autologinUser = "nixos";

    environment = {
      etc."X11/xinit/xinitrc".text = ''
        retroarch -f &
        exec tinywm
      '';

      loginShellInit = ''
        if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = "/dev/tty1" ]]; then
          exec startx
        fi
      '';
    };
  };
}
