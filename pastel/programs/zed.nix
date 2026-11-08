{ pkgs, ... }:
let
  soroemono = pkgs.stdenvNoCC.mkDerivation {
    pname = "soroemono-zed-bold-fallback";
    version = "2.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/qrac/soroemono/releases/download/2.0.0/SOROEMONO_v2.0.0.zip";
      hash = "sha256-sTfezGhKHcsZIa17OOa0rPVLqVwum0tFHDEgRaXwEEM=";
    };
    nativeBuildInputs = [
      pkgs.unzip
      (pkgs.python3.withPackages (p: [ p.fonttools ]))
    ];
    sourceRoot = ".";

    # Zed matches fallback faces at the primary font's weight. Give SOROEMONO's
    # bold outlines normal-weight metadata so Latin can remain Regular.
    # Rename the derived family rather than modifying the upstream family.
    postPatch = ''
      python - <<'PY'
      from fontTools.ttLib import TTFont

      family = "Zed Japanese Bold"
      for source_style, style, weight in [
          ("Bold", "Regular", 400), ("BoldItalic", "Italic", 400),
          ("Bold", "Bold", 700), ("BoldItalic", "Bold Italic", 700),
      ]:
          font = TTFont(f"SOROEMONO-{source_style}.ttf")
          postscript = "ZedJapaneseBold-" + style.replace(" ", "")
          names = {
              1: family, 2: style, 3: postscript, 4: f"{family} {style}",
              6: postscript, 16: family, 17: style,
          }
          for record in list(font["name"].names):
              if record.nameID in names:
                  font["name"].setName(
                      names[record.nameID], record.nameID,
                      record.platformID, record.platEncID, record.langID,
                  )
          font["OS/2"].usWeightClass = weight
          font["OS/2"].fsSelection &= ~((1 << 5) | (1 << 6))
          if weight == 700:
              font["OS/2"].fsSelection |= 1 << 5
          if style == "Regular":
              font["OS/2"].fsSelection |= 1 << 6
          font["head"].macStyle = (font["head"].macStyle & ~1) | (weight == 700)
          font.save(f"{postscript}.ttf")
      PY
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 ZedJapaneseBold-*.ttf -t "$out/share/fonts/truetype"
      mkdir -p "$out/share/doc/$pname"
      cp -r licenses "$out/share/doc/$pname/"
      runHook postInstall
    '';

    meta = {
      description = "SOROEMONO bold outlines as a normal-weight Zed Japanese fallback";
      homepage = "https://github.com/qrac/soroemono";
      license = pkgs.lib.licenses.ofl;
      platforms = pkgs.lib.platforms.all;
    };
  };
  japaneseFallbacks = [
    "Zed Japanese Bold"
    "Noto Sans CJK JP"
  ];
in
{
  home.packages = [
    pkgs.jetbrains-mono
    soroemono
    pkgs.noto-fonts-cjk-sans
  ];

  # Discover the packaged fonts; Zed's own fallback lists control their order.
  fonts.fontconfig.enable = true;

  programs.zed-editor = {
    enable = true;

    extensions = [
      "catppuccin"
      "catppuccin-blur"
      "catppuccin-blur-plus"
      "catppuccin-icons"
      "git-firefly"
      "glsl"
      "html"
      "java"
      "nix"
      "qml"
      "toml"
      "typst"
      "vue"
    ];

    userSettings = {
      cli_default_open_behavior = "existing_window";

      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };
      project_panel = {
        dock = "left";
      };

      agent_servers = {
        gemini = {
          type = "registry";
        };
        claude-acp = {
          type = "registry";
        };
      };

      agent = {
        dock = "right";
        inline_assistant_model = {
          provider = "copilot_chat";
          model = "gemini-3.1-pro-preview";
          enable_thinking = false;
        };
        default_model = {
          provider = "copilot_chat";
          model = "gpt-5-mini";
          enable_thinking = false;
        };
        favorite_models = [ ];
        model_parameters = [ ];
      };

      icon_theme = "Catppuccin Macchiato";
      base_keymap = "VSCode";

      ui_font_family = "JetBrains Mono";
      buffer_font_family = "JetBrains Mono";
      ui_font_fallbacks = japaneseFallbacks;
      buffer_font_fallbacks = japaneseFallbacks;
      ui_font_size = 16;
      buffer_font_size = 15;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Catppuccin Frappé";
      };

      terminal = {
        shell = {
          program = "fish";
        };
      };
    };
  };
}
