{ pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    extensions = [
      # Bitwarden
      "nngceckbapebfimnlniiiahkandclblb"
    ];
    commandLineArgs = [
      "--disable-features=PasswordManagerOnboarding,AutofillServerCommunication,AutofillPaymentCardBenefits,AutofillPaymentCvcStorage"
    ];
  };
}
