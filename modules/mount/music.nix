{ pkgs, userName, ... }:

{
  fileSystems."/home/${userName}/Music" = {
    device = "10.10.0.4:/mnt/archive/media/music";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "_netdev"
      "vers=4.1"
      "proto=tcp"
      "hard"
      "nconnect=4"
      "fsc"
      "noatime"
    ];
  };
}
