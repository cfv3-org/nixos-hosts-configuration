{ lib, pkgs, ... }:

let
  rnnoiseFilterConfig = pkgs.writeTextDir "share/pipewire/filter-chain.conf.d/99-rnnoise-source.conf" ''
    context.modules = [
      { name = libpipewire-module-filter-chain
        flags = [ nofail ]
        args = {
          node.description = "Noise Suppressed Microphone"
          media.name = "Noise Suppressed Microphone"

          filter.graph = {
            nodes = [
              {
                type = ladspa
                name = rnnoise
                plugin = "librnnoise_ladspa"
                label = noise_suppressor_mono
                control = {
                  "VAD Threshold (%)" = 75.0
                  "VAD Grace Period (ms)" = 250
                  "Retroactive VAD Grace (ms)" = 50
                }
              }
            ]
          }

          audio.position = [ MONO ]

          capture.props = {
            node.name = "effect_input.rnnoise"
            node.passive = true
            audio.rate = 48000
          }

          playback.props = {
            node.name = "effect_output.rnnoise"
            media.class = Audio/Source
            audio.rate = 48000
          }
        }
      }
    ]
  '';
in
{
  programs.noisetorch.enable = lib.mkForce false;

  services.pipewire = {
    configPackages = [ rnnoiseFilterConfig ];
    extraLadspaPackages = [ pkgs.rnnoise-plugin.ladspa ];
  };

  systemd.user.services.filter-chain.wantedBy = [ "default.target" ];
}
