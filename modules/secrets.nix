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
      "llamacpp/application_tracking_database_url" = { };
      "llamacpp/paperless_token" = { };
      "llamacpp/paperless_url" = { };
      "llamacpp/pihole_password" = { };
      "llamacpp/pihole_url" = { };
      "llamacpp/mikrotik_host" = { };
      "llamacpp/mikrotik_username" = { };
      "llamacpp/mikrotik_password" = { };
      "llamacpp/mikrotik_port" = { };
      "online_accounts/google_email" = {
        owner = userName;
      };
    };

    templates."mcp-application-tracking.env".content = ''
      JOB_SEARCH_DATABASE_URL=${config.sops.placeholder."llamacpp/application_tracking_database_url"}
    '';

    templates."mcp-paperless.env".content = ''
      PAPERLESS_URL=${config.sops.placeholder."llamacpp/paperless_url"}
      PAPERLESS_TOKEN=${config.sops.placeholder."llamacpp/paperless_token"}
    '';

    templates."mcp-pihole.env".content = ''
      PIHOLE_URL=${config.sops.placeholder."llamacpp/pihole_url"}
      PIHOLE_PASSWORD=${config.sops.placeholder."llamacpp/pihole_password"}
    '';

    templates."mcp-mikrotik.env".content = ''
      MIKROTIK_HOST=${config.sops.placeholder."llamacpp/mikrotik_host"}
      MIKROTIK_USERNAME=${config.sops.placeholder."llamacpp/mikrotik_username"}
      MIKROTIK_PASSWORD=${config.sops.placeholder."llamacpp/mikrotik_password"}
      MIKROTIK_PORT=${config.sops.placeholder."llamacpp/mikrotik_port"}
    '';
  };

  virtualisation.oci-containers.containers.mcp-application-tracking.environmentFiles = [
    config.sops.templates."mcp-application-tracking.env".path
  ];

  virtualisation.oci-containers.containers.mcp-paperless.environmentFiles = [
    config.sops.templates."mcp-paperless.env".path
  ];

  virtualisation.oci-containers.containers.mcp-pihole.environmentFiles = [
    config.sops.templates."mcp-pihole.env".path
  ];

  virtualisation.oci-containers.containers.mcp-mikrotik.environmentFiles = [
    config.sops.templates."mcp-mikrotik.env".path
  ];
}
