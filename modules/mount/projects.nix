{ pkgs, userName, ... }:

{
  fileSystems."/home/${userName}/nas/projects/archive" = {
    device = "10.10.0.4:/mnt/archive/work/projects";
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
