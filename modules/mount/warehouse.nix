{
  fileSystems."/mnt/warehouse" = {
    device = "/dev/disk/by-uuid/eb1a4d30-9372-4645-b5c6-67004a6df912";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-systemd.device-timeout=10s"
      "x-systemd.automount"
      "x-systemd.idle-timeout=1min"
    ];
  };
}
