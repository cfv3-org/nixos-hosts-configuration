{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
      # Loom
      "liecbddmkiiihnedobmlmillhodjkdmb"
    ];
    commandLineArgs = [
      "--disable-features=PasswordManagerOnboarding,AutofillServerCommunication,AutofillPaymentCardBenefits,AutofillPaymentCvcStorage"
    ];
  };
}
