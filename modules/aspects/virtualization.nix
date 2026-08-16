{
  den.aspects.virtualization.nixos = {pkgs, ...}: {
    # Nested virtualization (Intel)
    boot.extraModprobeConfig = "options kvm_intel nested=1";

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true; # TPM emulation for Windows 11
      };
    };

    programs.virt-manager.enable = true;

    users.users.jordan.extraGroups = ["libvirtd"];

    environment.systemPackages = with pkgs; [
      virt-manager
      virt-viewer
      spice-gtk
      virtio-win
      looking-glass-client
    ];

    virtualisation.spiceUSBRedirection.enable = true;
  };
}
