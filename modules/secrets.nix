{
  config,
  userName,
  ...
}:

{
  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";

    secrets = {
      "online_accounts/google_email" = {
        owner = userName;
      };
    };
  };
}
