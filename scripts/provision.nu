#!/usr/bin/env nu

# Provision an SD card with age key and hostname for mort devices

def main [
    device: string  # Target device (e.g., /dev/sda)
    --hostname: string  # Hostname for this device (e.g., mort-001). If omitted, uses serial at boot.
    --age-key: string = "~/.config/sops/age/keys.txt"  # Path to age key file
] {
    let age_key_path = ($age_key | path expand)

    if not ($age_key_path | path exists) {
        print $"Error: Age key not found at ($age_key_path)"
        exit 1
    }

    # Determine rootfs partition (usually partition 2 on SD images)
    let rootfs_part = if ($device | str ends-with "p1") or ($device | str ends-with "p2") {
        # Already a partition
        $device | str replace -r 'p[12]$' 'p2'
    } else if ($device =~ '/dev/sd[a-z]$') {
        $"($device)2"
    } else if ($device =~ '/dev/nvme') {
        $"($device)p2"
    } else if ($device =~ '/dev/mmcblk') {
        $"($device)p2"
    } else {
        $"($device)2"
    }

    print $"Using rootfs partition: ($rootfs_part)"

    let mount_point = "/tmp/mort-provision"
    mkdir $mount_point

    print $"Mounting ($rootfs_part)..."
    sudo mount $rootfs_part $mount_point

    try {
        print "Provisioning age key..."
        sudo mkdir -p $"($mount_point)/var/lib/sops-nix"
        sudo cp $age_key_path $"($mount_point)/var/lib/sops-nix/key.txt"
        sudo chmod 600 $"($mount_point)/var/lib/sops-nix/key.txt"

        if ($hostname | is-not-empty) {
            print $"Setting hostname to: ($hostname)"
            $hostname | sudo tee $"($mount_point)/etc/hostname.provisioned" | ignore
        } else {
            print "No hostname specified - device will use Pi serial at boot"
        }

        print "Provisioning complete!"
    } catch { |err|
        print $"Error during provisioning: ($err.msg)"
    }

    print "Unmounting..."
    sudo umount $mount_point
    rmdir $mount_point

    print "Done! SD card is ready."
}
