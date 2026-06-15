{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pavucontrol
  ];

  services.pipewire.extraConfig.pipewire."92-yamaha-dm3" = {
    "context.properties" = {
      "default.clock.rate" = 96000;
      "default.clock.allowed-rates" = [ 44100 48000 88200 96000 ];
      "default.clock.quantum" = 256;
      "default.clock.min-quantum" = 128;
      "default.clock.max-quantum" = 8192;
    };
  };

  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-yamaha-dm3.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            [ { node.name = "~alsa_input.usb-Yamaha_Corporation_Yamaha_DM3.*" } ]
            [ { node.name = "~alsa_output.usb-Yamaha_Corporation_Yamaha_DM3.*" } ]
          ]
          actions = {
            update-props = {
              audio.format          = "S32LE"
              audio.rate            = 96000
              audio.channels        = 18
              audio.channel-map     = "AUX0,AUX1,AUX2,AUX3,AUX4,AUX5,AUX6,AUX7,AUX8,AUX9,AUX10,AUX11,AUX12,AUX13,AUX14,AUX15,AUX16,AUX17"
              api.alsa.period-size  = 256
              api.alsa.headroom     = 512
              channelmix.normalize  = false
              channelmix.mix-lfe    = false
              node.nick             = "Yamaha DM3"
            }
          }
        }
      ]
    '')
  ];
}
