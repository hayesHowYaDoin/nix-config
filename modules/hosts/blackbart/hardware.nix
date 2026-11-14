{inputs, ...}: {
  den.aspects.blackbart.nixos = {config, ...}: {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ];

    hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
  };
}
