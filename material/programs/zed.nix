{ ... }:
{

  # home.packages = with pkgs; [
  # 	zed
  # ];

  programs.zed-editor = {
    enable = true;
    # add java make latex dart kotlin python
    extensions = [
      "Dart"
      "Dockerfile"
      "Flutter Snippets"
      "Github MCP Server"
      "HTML"
      "Java"
      "LaTeX"
      "Make"
      "Material Icon Theme"
      "Nix"
      "Not Material Theme"
      "Svelte"
      "TOML"
      "Terraform"
      "Vue"
      "wakatime"
      "dart"
      "java"
      "kotlin"
      "latex"
      "make"
      "nix"
      "toml"
      "Slint"
    ];

    userSettings = {
      theme = {
        light = "Catppuccin Latte";
        dark = "Catppuccin Frappé";
      };

      icon_theme = {
        light = "Catppuccin Latte";
        dark = "Catppuccin Frappé";
      };

      lsp = {
        rust-analyzer = {
          binary.path_loookup = true;
        };

        nix = {
          binary = {
            path_lookup = true;
          };
        };
      };

      languages = {
        Markdown = {
          formatter = "prettier";
        };

        Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter = {
            external = {
              command = "nixfmt";
              arguments = [
                "--quiet"
                "--"
              ];
            };
          };
        };
      };

      features = {
        edit_prediction_provider = "copilot";
      };

      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      auto_update = false;
      hour_format = "hour24";
      vim_mode = false;

      terminal = {
        font = "JetBrainsMono Nerd Font";
        size = 14;
      };

      load_direnv = "shell_hook";
      base_keymap = "VSCode";
    };
  };
}
