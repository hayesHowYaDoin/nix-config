{
  # Declare a libvirt VM that may want special host-level handling.
  #
  # This aspect DOES NOT create the VM itself — the VM lives in libvirt
  # (defined via virt-manager or `virsh define`). This aspect only opts the
  # named VM into host-level features like single-GPU passthrough hooks.
  #
  # Requires the `virtualization` aspect to be included on the same host.
  den.aspects.vm = {
    name,
    enableGpuPassthrough ? false,
    ...
  }: {
    name = "vm/${name}";
    nixos = {lib, ...}: {
      virtualization.gpuPassthroughGuests = lib.mkIf enableGpuPassthrough [name];
    };
  };
}
