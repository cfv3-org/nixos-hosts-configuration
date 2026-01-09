{ pkgs, userName, ... }:

{
  fileSystems."/home/${userName}/nfs/Share" = {
    device = "10.10.0.4:/mnt/archive/share";
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
