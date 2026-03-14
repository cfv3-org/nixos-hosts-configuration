{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  userName,
  ...
}:

{
  imports = [];

  home = {
    username = userName;
    homeDirectory = "/home/${userName}";
    stateVersion = "25.11";
  };
}
