{
  fileSystems."/mnt/NAS/Music" = {
    device = "10.10.0.4:/mnt/archive/media/music";
    fsType = "nfs";
    options = [
      "_netdev"
      "nofail"
      "x-systemd.device-timeout=10s"
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
