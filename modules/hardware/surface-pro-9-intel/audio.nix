{ config, lib, pkgs, ... }: {

  services.pipewire.wireplumber.configPackages = [
    ((pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-surface-pro-9-dsp.conf" ''
      node.software-dsp.rules = [
        {
          matches = [
            { "node.name" = "alsa_output.pci-0000_00_1f.3.analog-stereo" }
          ]

          actions = {
            create-filter = {
              filter-graph = {
                node.description = "Surface Pro 9 Speaker"
                filter.graph = {
                  nodes = [
                    {
                      type = "lv2"
                      plugin = "https://chadmed.au/bankstown"
                      name = "bankstown"
                      control = {
                          bypass = 0
                          amt = 1.25
                          sat_second = 1.75
                          sat_third = 2.35
                          blend = 0.40
                          ceil = 200.0
                          floor = 20.0
                      }
                    }
                    {
                      type = "builtin"
                      name = "convolver_r"
                      label = "convolver"
                      config = {
                        filename = "/etc/surface-audio/sp9/impulse.wav"
                      }
                    }
                    {
                      type = "builtin"
                      name = "convolver_l"
                      label = "convolver"
                      config = {
                        filename = "/etc/surface-audio/sp9/impulse.wav"
                      }
                    }
                  ]
                  links = [
                    {
                      output = "bankstown:out_l"
                      input = "convolver_l:In"
                    }
                    {
                      output = "bankstown:out_r"
                      input = "convolver_r:In"
                    }
                  ]
                  inputs = [ "bankstown:in_l" "bankstown:in_r" ]
                  outputs = [ "convolver_l:Out" "convolver_r:Out" ]
                }
                capture.props = {
                  node.name = "audio_effect.sp9-convolver"
                  media.class = "Audio/Sink"
                  node.virtual = false
                  priority.session = 10000
                  device.api = "dsp"
                  audio.channels = 2
                  audio.position = ["FL", "FR"]
                  state.default-channel-volume = 0.343
                }
                playback.props = {
                  node.name = "effect_output.sp9-convolver"
                  target.object = "alsa_output.pci-0000_00_1f.3.analog-stereo"
                  node.passive = true
                  audio.channels = 2
                  audio.position = ["FL", "FR"]
                }
              }
              hide-parent = "true"
            }
          }
        }
      ]

      wireplumber.profiles = {
        main = {
          node.software-dsp = required
        }
      }
    '').overrideAttrs {
      passthru.requiredLv2Packages = [ pkgs.bankstown-lv2 ];
    })
  ];

  environment.etc."surface-audio/sp9/impulse.wav".source = pkgs.fetchurl {
    url = "https://github.com/peter-marshall5/surface-audio/raw/main/devices/sp9/impulse.wav";
    hash = "sha256-I/3FIqM4F6Yth6cfy8poUBRyW1nEkGKJBxBQsPcNaWo=";
  };

}
