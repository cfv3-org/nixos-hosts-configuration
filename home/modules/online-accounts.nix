{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  googleEmailFile = osConfig.sops.secrets."online_accounts/google_email".path;
in
{
  home.activation.gnomeOnlineAccounts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    google_email="$(${pkgs.coreutils}/bin/tr -d '\n' < ${googleEmailFile})"

    run install -d "$HOME/.config/goa-1.0"
    run ${pkgs.runtimeShell} -c "cat > \"\$HOME/.config/goa-1.0/accounts.conf\"" <<EOF
    [Account account_1772183559_0]
    Provider=google
    Identity=$google_email
    PresentationIdentity=$google_email
    MailEnabled=true
    CalendarEnabled=true
    ContactsEnabled=false
    FilesEnabled=false
    EOF
    run chmod 0644 "$HOME/.config/goa-1.0/accounts.conf"
  '';
}
