{ userName, ... }:

{
  hardware.openrazer = {
    enable = true;
    users = [ userName ];
  };
}
