{
  fileSystems."/home/vasary/projects" = {
    device = "192.168.50.1:/mnt/Safe/projects";
    fsType = "nfs";
    options = [
      "vers=4.1"
      "hard"
      "x-systemd.automount"
      "_netdev"
      "noatime"
    ];
  };
}
