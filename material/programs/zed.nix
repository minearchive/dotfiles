{ ... }:
{
  programs.zed-editor = {
    enable = true;
    # add java make latex dart kotlin python
    extensions = [
      "nix"
      "toml"
      "java"
      "make"
      "latex"
      "dart"
      "kotlin"
    ];

    userSettings = {
      home = {
        mode = "system";
        dark = "catppuccin frappe";
        light = "catppuccin latte";
      };
      default_model = {
        provider = "copilot_chat";
        model = "gpt-4.1";
      };
      inline_alternatives = [
        {
          provider = "copilot_chat";
          model = "gpt-3.5-turbo";
        }
      ];
      auto_update = false;
      hour_format = "hour24";
      vim_mode = true;

      terminal = {
        font = "JetBrainsMono Nerd Font";
        size = 14;
      };

      load_direnv = "shell_hook";
      base_keymap = "VSCode";
    };
  };
}
