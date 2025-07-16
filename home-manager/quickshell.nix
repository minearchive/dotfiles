{ config, lib, pkgs, inputs, ... }:

let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;

  material-color-extractor = pkgs.stdenv.mkDerivation {
    pname = "material-color-extractor";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "minearchive";
      repo = "material-color-extractor";
      rev = "23045ca931c3b87068fe8abce33039001edb3ac4";
      sha256 = "sha256-Xr2Bt/yfaDyklc7PEq3Yq5yBUd6NSTxa0CcBpwvK/M8="; # 正しいhashに
    };

    nativeBuildInputs = with pkgs; [ cmake git ];

    cmakeFlags = [
      "-DCMAKE_BUILD_TYPE=Release"
      "-DCMAKE_INSTALL_PREFIX=$out"
    ];

    installPhase = ''
      mkdir -p $out/bin
      cp ./extract_material_color $out/bin/
    '';
  };

in
{
  home.packages = [
    quickshell
    material-color-extractor
  ];
}
