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
BlLG3IpM3nz0ZseYyXvSpJPi57ugecV4w9c6HpPVH5pDV+4zWC7Urmj6dc5+L/FkwmOokMAukbbS2UO9N/qxhA==