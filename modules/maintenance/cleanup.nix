{ userName, ... }:

{
  services.journald.extraConfig = ''
    MaxRetentionSec=3day
  '';

  home-manager.users.${userName} = {
    services.home-manager.autoExpire = {
      enable = true;
      frequency = "daily";
      timestamp = "-3 days";
    };
  };
}
