{
  den.aspects.blackbart.nixos = {
    boot = {
      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
      ];
      initrd.kernelModules = [];
      kernelModules = ["kvm-intel"];
      extraModulePackages = [];
    };
  };
}
