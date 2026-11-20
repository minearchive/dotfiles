{ pkgs, inputs, ... }:
let
  vital-fixed = pkgs.vital.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.curl ];
    preFixup = (oldAttrs.preFixup or "") + ''
      for plugin in \
        $out/lib/vst3/Vital.vst3/Contents/x86_64-linux/Vital.so \
        $out/lib/clap/Vital.clap/Contents/x86_64-linux/Vital.so \
        $out/lib/vst/Vital.so; do
        [ -f "$plugin" ] && patchelf --add-needed libcurl.so.4 "$plugin"
      done
    '';
  });
in
{
  home.packages = [
    vital-fixed
    inputs.hermes-agent.packages.x86_64-linux.desktop
    (pkgs.reaper.overrideAttrs (oldAttrs: {
      patchelfFlags = (oldAttrs.patchelfFlags or [ ]) ++ [
        "--page-size"
        "65536"
      ];
    }))
  ];

  home.sessionVariables = {
    VST_PATH = "$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst:$HOME/.vst";
    VST3_PATH = "$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3:$HOME/.vst3";
  };
}
