{
  den.aspects.gpu-passthrough.nixos = {
    systemd.tmpfiles.rules = [
      "d /var/lib/libvirt/hooks 0755 root root -"
    ];

    # Single-GPU passthrough qemu hook — swaps NVIDIA/vfio when the
    # `win11-gpu` VM starts/stops. Change the guest name guard to add more VMs.
    environment.etc."libvirt/hooks/qemu" = {
      mode = "0755";
      text = ''
        #!/run/current-system/sw/bin/bash

        GUEST_NAME="$1"
        OPERATION="$2"

        if [[ "$GUEST_NAME" != "win11-gpu" ]]; then
          exit 0
        fi

        if [[ "$OPERATION" == "prepare/begin" ]]; then
          systemctl stop display-manager.service

          echo 0 > /sys/class/vtconsole/vtcon0/bind
          echo 0 > /sys/class/vtconsole/vtcon1/bind

          echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind || true

          modprobe -r nvidia_drm nvidia_modeset nvidia_uvm nvidia

          modprobe vfio_pci vfio vfio_iommu_type1

        elif [[ "$OPERATION" == "release/end" ]]; then
          modprobe -r vfio_pci vfio_iommu_type1 vfio

          echo 1 > /sys/class/vtconsole/vtcon0/bind
          echo 1 > /sys/class/vtconsole/vtcon1/bind

          modprobe nvidia_drm nvidia_modeset nvidia_uvm nvidia

          systemctl start display-manager.service
        fi
      '';
    };
  };
}
