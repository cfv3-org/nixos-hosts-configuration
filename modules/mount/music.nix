{ pkgs, userName, ... }:

{
  fileSystems."/home/${userName}/nfs/Music" = {
    device = "10.10.0.4:/mnt/archive/media/music";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=30s"
      "_netdev"
      "vers=4.1"
      "proto=tcp"
      "soft"
      "timeo=600"
      "retrans=5"
      "nconnect=4"
      "fsc"
      "noatime"
    ];
  };
}
