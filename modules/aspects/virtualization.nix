{
  den.aspects.virtualization = {
    user,
    enableNestedVirt ? true,
    swtpm ? true,
    intel ? true,
    gpuKernelModules ? [
      "nvidia_drm"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia"
    ],
    displayManagerService ? "display-manager.service",
    ...
  }: {
    name = "virtualization";
    nixos = {
      pkgs,
      lib,
      config,
      ...
    }: {
      options.virtualization.gpuPassthroughGuests = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = ''
          Names of libvirt guests that need single-GPU passthrough handling.
          Populated by vm aspects with enableGpuPassthrough = true.
        '';
      };

      config = {
        # Nested virtualization — Intel option shown; AMD would be kvm_amd.
        boot.extraModprobeConfig = lib.mkIf enableNestedVirt (
          if intel
          then "options kvm_intel nested=1"
          else "options kvm_amd nested=1"
        );

        virtualisation.libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = swtpm;
          };
        };

        programs.virt-manager.enable = true;

        users.users.${user}.extraGroups = ["libvirtd"];

        environment.systemPackages = with pkgs; [
          virt-manager
          virt-viewer
          spice-gtk
          virtio-win
          looking-glass-client
        ];

        virtualisation.spiceUSBRedirection.enable = true;

        # Hook script for single-GPU passthrough, only generated if any VM opts in.
        systemd.tmpfiles.rules = lib.mkIf (config.virtualization.gpuPassthroughGuests != []) [
          "d /var/lib/libvirt/hooks 0755 root root -"
        ];

        environment.etc."libvirt/hooks/qemu" = lib.mkIf (config.virtualization.gpuPassthroughGuests != []) {
          mode = "0755";
          text = ''
            #!/run/current-system/sw/bin/bash

            GUEST_NAME="$1"
            OPERATION="$2"

            case "$GUEST_NAME" in
              ${lib.concatStringsSep "|" config.virtualization.gpuPassthroughGuests})
                ;;
              *)
                exit 0
                ;;
            esac

            if [[ "$OPERATION" == "prepare/begin" ]]; then
              systemctl stop ${displayManagerService}

              echo 0 > /sys/class/vtconsole/vtcon0/bind
              echo 0 > /sys/class/vtconsole/vtcon1/bind

              echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true

              modprobe -r ${lib.concatStringsSep " " gpuKernelModules}

              modprobe vfio_pci vfio vfio_iommu_type1

            elif [[ "$OPERATION" == "release/end" ]]; then
              modprobe -r vfio_pci vfio_iommu_type1 vfio

              echo 1 > /sys/class/vtconsole/vtcon0/bind
              echo 1 > /sys/class/vtconsole/vtcon1/bind

              modprobe ${lib.concatStringsSep " " gpuKernelModules}

              systemctl start ${displayManagerService}
            fi
          '';
        };
      };
    };
  };
}
