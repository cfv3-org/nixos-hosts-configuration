{
  fileSystems."/mnt/NAS/Music" = {
    device = "10.10.0.4:/mnt/archive/media/music";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "noauto"
      "rw"
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
      "x-systemd.device-timeout=10s"
      "x-systemd.mount-timeout=10s"
      "x-systemd.automount"
      "x-systemd.idle-timeout=5min"
      "vers=4.1"
      "proto=tcp"
      "hard"
      "timeo=600"
      "retrans=5"
      "nconnect=4"
      "fsc"
      "noatime"
      "x-gvfs-show"
      "x-gvfs-name=NAS Music"
    ];
  };
}
