{ ... }:
{
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
