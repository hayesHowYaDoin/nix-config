{
  flake.modules.nixos.hardware-nvidia = {config, ...}: {
    services.xserver.videoDrivers = ["nvidia"];
    hardware = {
      graphics.enable = true;

      nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      nvidia-container-toolkit.enable = true;
    };
  };
}
