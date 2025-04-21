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
                          amt = 0.8
                          sat_third = 2.1
                          blend = 1
                          ceil = 200.0
                          floor = 20.0
                          final_hp = 120.0
                      }
                    }
                    {
                        type = "lv2"
                        plugin = "http://lsp-plug.in/plugins/lv2/loud_comp_mono"
                        name = "ell"
                        control = {
                            enabled = 1
                            input = 1.0
                            fft = 2
                        }
                    }
                    {
                        type = "lv2"
                        plugin = "http://lsp-plug.in/plugins/lv2/loud_comp_mono"
                        name = "elr"
                        control = {
                            enabled = 1
                            input = 1.0
                            fft = 2
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
                    {
                        type = "lv2"
                        plugin = "http://lsp-plug.in/plugins/lv2/mb_compressor_stereo"
                        name = "bp"
                        control = {
                            mode = 0
                            ce_0 = 1
                            sla_0 = 5.0
                            cr_0 = 1.75
                            al_0 = 0.625
                            at_0 = 1.0
                            rt_0 = 100
                            kn_0 = 0.125
                            cbe_1 = 1
                            sf_1 = 380.0
                            ce_1 = 0
                            cbe_2 = 0
                            ce_2 = 0
                            cbe_3 = 0
                            ce_3 = 0
                            cbe_4 = 0
                            ce_4 = 0
                            cbe_5 = 0
                            ce_5 = 0
                            cbe_6 = 0
                            ce_6 = 0
                        }
                    }
                    {
                        type = "lv2"
                        plugin = "http://lsp-plug.in/plugins/lv2/compressor_stereo"
                        name = "lim"
                        control = {
                            sla = 5.0
                            al = 1
                            at = 1.0
                            rt = 100.0
                            cr = 15.0
                            cm = 0
                            kn = 0.5
                        }
                    }
                  ]
                  links = [
                    {
                      output = "bankstown:out_l"
                      input = "ell:in"
                    }
                    {
                      output = "bankstown:out_r"
                      input = "elr:in"
                    }
                    {
                      output = "ell:out"
                      input = "convolver_l:In"
                    }
                    {
                      output = "elr:out"
                      input = "convolver_r:In"
                    }
                    {
                      output = "convolver_l:Out"
                      input = "bp:in_l"
                    }
                    {
                      output = "convolver_r:Out"
                      input = "bp:in_r"
                    }
                    {
                      output = "bp:out_l"
                      input = "lim:in_l"
                    }
                    {
                      output = "bp:out_r"
                      input = "lim:in_r"
                    }
                  ]
                  inputs = [ "bankstown:in_l" "bankstown:in_r" ]
                  outputs = [ "lim:out_l" "lim:out_r" ]
                  capture.volumes = [
                      {
                          control = "ell:volume"
                          min = -65.0
                          max = 0.0
                          scale = "cubic"
                      }
                      {
                          control = "elr:volume"
                          min = -65.0
                          max = 0.0
                          scale = "cubic"
                      }
                  ]
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
      passthru.requiredLv2Packages = [ pkgs.bankstown-lv2 pkgs.lsp-plugins ];
    })
  ];

  environment.etc."surface-audio/sp9/impulse.wav".source = ./impulse.wav;

}
