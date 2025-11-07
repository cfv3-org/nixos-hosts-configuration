{ pkgs, userName, ... }:

{
  fileSystems."/home/${userName}/Share" = {
    device = "10.10.0.4:/mnt/archive/share";
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
