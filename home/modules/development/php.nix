{ pkgs, ... }:

let
  php = pkgs.php.withExtensions (
    { enabled, all }:
    enabled
    ++ (with all; [
      amqp
      gd
      intl
      mbstring
      mysqli
      pdo_mysql
      pdo_pgsql
      pdo_sqlite
      pgsql
      redis
      sqlite3
      xdebug
      zip
    ])
  );
in
{
  home.packages = [
    php
    (pkgs.phpPackages.composer.override { inherit php; })
  ];
}
