_: {
  flake.modules.nixos.kenny = {
    boot.loader.grub.devices = ["/dev/sda"];
  };
}
