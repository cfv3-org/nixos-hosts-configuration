{ pkgs, config, userName, ... }:

{
  services = {
    displayManager.autoLogin = {
      enable = true;
      user = userName;
    };
  };

  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
