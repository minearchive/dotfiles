{ pkgs, ... }:
let
  # nixpkgs の vital パッケージは curl を VST3/CLAP プラグインの RPATH に含めていないため、
  # Bitwig のプラグインホスト内で libcurl の dlopen() が失敗して NULL 参照でクラッシュする。
  # patchelf で curl のパスを直接 RPATH に追加して修正する。
  vital-fixed = pkgs.vital.overrideAttrs (oldAttrs: {
    # curl を buildInputs に加えて autoPatchelfHook の検索対象にする
    buildInputs = oldAttrs.buildInputs ++ [ pkgs.curl ];
    # autoPatchelf より前に NEEDED に libcurl を追加することで
    # autoPatchelf 自身が RPATH を解決するよう誘導する
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
  ];

  home.sessionVariables = {
    VST_PATH = "$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst:$HOME/.vst";
    VST3_PATH = "$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3:$HOME/.vst3";
  };

}
