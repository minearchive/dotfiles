{ ... }:
{
  xdg.configFile = {
    "matugen/config.toml".text = ''
      [config]

      [templates.rofi]
      input_path = "~/.local/share/matugen/template/template.rasi"
      output_path = "~/.config/rofi/colors.rasi"

      [templates.qt5ct]
      input_path = '~/.local/share/matugen/template/qt.conf'
      output_path = '~/.config/qt5ct/colors/matugen.conf'

      [templates.starship]
      input_path = '~/.local/share/matugen/template/settings.toml'
      output_path = '~/.config/starship.toml'

      [templates.kitty]
      input_path = '~/.local/share/matugen/template/kitty-colors.conf'
      output_path = '~/.config/kitty/colors.conf'
      post_hook = 'pkill -SIGUSR1 kitty'

      [templates.quickshell]
      input_path = '~/.local/share/matugen/template/template.qml'
      output_path = '~/.local/share/qs-bar/theme/Colors.qml'

      [templates.gtk3]
      input_path = '~/.local/share/matugen/template/gtk_theme.css'
      output_path = '~/.config/gtk-3.0/colors.css'
      post_hook = 'gsettings set org.gnome.desktop.interface gtk-theme ""; gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-{{mode}}'

      [templates.gtk4]
      input_path = '~/.local/share/matugen/template/gtk_theme.css'
      output_path = '~/.config/gtk-4.0/colors.css'

      [templates.one_material3_zed]
      input_path = '~/.local/share/matugen/template/one-material3.json'
      output_path = '~/.config/zed/themes/material-you.json'
    '';
    # [templates.one_material3_css]
    # input_path = '~/.local/share/matugen/template/one-material3.css'
    # output_path = '~/.config/gtk-3.0/one-material3.css'

    # [templates.one_material3_vars]
    # input_path = '~/.local/share/matugen/template/one-material3.css'
    # output_path = '~/.local/share/themes/one-material3/material3-vars.css'
  };

  home.file = {
    ".local/share/matugen/template/gtk_theme.css" = {
      text = ''
        /*
        * GTK Colors
        * Generated with Matugen
        */

        @define-color accent_color {{colors.primary_fixed_dim.default.hex}};
        @define-color accent_fg_color {{colors.on_primary_fixed.default.hex}};
        @define-color accent_bg_color {{colors.primary_fixed_dim.default.hex}};
        @define-color window_bg_color {{colors.surface_dim.default.hex}};
        @define-color window_fg_color {{colors.on_surface.default.hex}};
        @define-color headerbar_bg_color {{colors.surface_dim.default.hex}};
        @define-color headerbar_fg_color {{colors.on_surface.default.hex}};
        @define-color popover_bg_color {{colors.surface_dim.default.hex}};
        @define-color popover_fg_color {{colors.on_surface.default.hex}};
        @define-color view_bg_color {{colors.surface.default.hex}};
        @define-color view_fg_color {{colors.on_surface.default.hex}};
        @define-color card_bg_color {{colors.surface.default.hex}};
        @define-color card_fg_color {{colors.on_surface.default.hex}};
        @define-color sidebar_bg_color @window_bg_color;
        @define-color sidebar_fg_color @window_fg_color;
        @define-color sidebar_border_color @window_bg_color;
        @define-color sidebar_backdrop_color @window_bg_color;
      '';
    };

    ".local/share/matugen/template/kitty-colors.conf".text = ''
      cursor {{colors.on_surface.default.hex}}
      cursor_text_color {{colors.on_surface_variant.default.hex}}

      foreground            {{colors.on_surface.default.hex}}
      background            {{colors.surface.default.hex}}
      selection_foreground  {{colors.on_secondary.default.hex}}
      selection_background  {{colors.secondary_fixed_dim.default.hex}}
      url_color             {{colors.primary.default.hex}}

      # black
      color8   #262626
      color0   #4c4c4c

      # red
      color1   #ac8a8c
      color9   #c49ea0

      # green
      color2   #8aac8b
      color10  #9ec49f

      # yellow
      color3   #aca98a
      color11  #c4c19e

      # blue
      /* color4  #8f8aac */
      color4  {{colors.primary.default.hex}}
      color12 #a39ec4

      # magenta
      color5   #ac8aac
      color13  #c49ec4

      # cyan
      color6   #8aacab
      color14  #9ec3c4

      # white
      color15   #e7e7e7
      color7  #f0f0f0
    '';

    ".local/share/matugen/template/qt.conf".text = ''
      [ColorScheme]
      active_colors={{colors.on_background.default.hex}}, {{colors.surface.default.hex}}, #ffffff, #cacaca, #9f9f9f, #b8b8b8, {{colors.on_background.default.hex}}, #ffffff, {{colors.on_surface.default.hex}}, {{colors.background.default.hex}}, {{colors.background.default.hex}}, {{colors.shadow.default.hex}}, {{colors.primary_container.default.hex}}, {{colors.on_primary_container.default.hex}}, {{colors.secondary.default.hex}}, {{colors.primary.default.hex}}, {{colors.surface.default.hex}}, {{colors.scrim.default.hex}}, {{colors.surface.default.hex}}, {{colors.on_surface.default.hex}}, {{colors.secondary.default.hex}}
      disabled_colors={{colors.on_background.default.hex}}, {{colors.surface.default.hex}}, #ffffff, #cacaca, #9f9f9f, #b8b8b8, {{colors.on_background.default.hex}}, #ffffff, {{colors.on_surface.default.hex}}, {{colors.background.default.hex}}, {{colors.background.default.hex}}, {{colors.shadow.default.hex}}, {{colors.primary_container.default.hex}}, {{colors.on_primary_container.default.hex}}, {{colors.secondary.default.hex}}, {{colors.primary.default.hex}}, {{colors.surface.default.hex}}, {{colors.scrim.default.hex}}, {{colors.surface.default.hex}}, {{colors.on_surface.default.hex}}, {{colors.secondary.default.hex}}
      inactive_colors={{colors.on_background.default.hex}}, {{colors.surface.default.hex}}, #ffffff, #cacaca, #9f9f9f, #b8b8b8, {{colors.on_background.default.hex}}, #ffffff, {{colors.on_surface.default.hex}}, {{colors.background.default.hex}}, {{colors.background.default.hex}}, {{colors.shadow.default.hex}}, {{colors.primary_container.default.hex}}, {{colors.on_primary_container.default.hex}}, {{colors.secondary.default.hex}}, {{colors.primary.default.hex}}, {{colors.surface.default.hex}}, {{colors.scrim.default.hex}}, {{colors.surface.default.hex}}, {{colors.on_surface.default.hex}}, {{colors.secondary.default.hex}}
    '';

    ".local/share/matugen/template/settings.toml".text = ''
      format = """
      [╭╴ ](primary)\
      [](primary)\
      $directory\
      [](fg:primary bg:secondary_fixed)\
      $git_branch\
      $git_status\
      [](fg:secondary_fixed bg:#ffffff)\
      $nodejs\
      $rust\
      $golang\
      $php\
      $python\
      [](fg:#ffffff bg:surface_bright)\
      $time\
      $battery\
      [ ](fg:surface_bright)\
      \n$character"""

      add_newline = false
      palette = 'colors'

      [palettes.colors]
      primary = '{{colors.primary.default.hex}}'
      on_primary = '{{colors.on_primary.default.hex}}'
      primary_container = '{{colors.primary_container.default.hex}}'
      on_primary_container = '{{colors.on_primary_container.default.hex}}'
      inverse_primary = '{{colors.inverse_primary.default.hex}}'
      primary_fixed = '{{colors.primary_fixed.default.hex}}'
      primary_fixed_dim = '{{colors.primary_fixed_dim.default.hex}}'
      on_primary_fixed = '{{colors.on_primary_fixed.default.hex}}'
      on_primary_fixed_variant = '{{colors.on_primary_fixed_variant.default.hex}}'
      secondary = '{{colors.secondary.default.hex}}'
      on_secondary = '{{colors.on_secondary.default.hex}}'
      secondary_container = '{{colors.secondary_container.default.hex}}'
      on_secondary_container = '{{colors.on_secondary_container.default.hex}}'
      secondary_fixed = '{{colors.secondary_fixed.default.hex}}'
      secondary_fixed_dim = '{{colors.secondary_fixed_dim.default.hex}}'
      on_secondary_fixed = '{{colors.on_secondary_fixed.default.hex}}'
      on_secondary_fixed_variant = '{{colors.on_secondary_fixed_variant.default.hex}}'
      tertiary = '{{colors.tertiary.default.hex}}'
      on_tertiary = '{{colors.on_tertiary.default.hex}}'
      tertiary_container = '{{colors.tertiary_container.default.hex}}'
      on_tertiary_container = '{{colors.on_tertiary_container.default.hex}}'
      tertiary_fixed = '{{colors.tertiary_fixed.default.hex}}'
      tertiary_fixed_dim = '{{colors.tertiary_fixed_dim.default.hex}}'
      on_tertiary_fixed = '{{colors.on_tertiary_fixed.default.hex}}'
      error = '{{colors.error.default.hex}}'
      on_error = '{{colors.on_error.default.hex}}'
      error_container = '{{colors.error_container.default.hex}}'
      on_error_container = '{{colors.on_error_container.default.hex}}'
      surface_dim = '{{colors.surface_dim.default.hex}}'
      surface = '{{colors.surface.default.hex}}'
      surface_bright = '{{colors.surface_bright.default.hex}}'
      surface_container_lowest = '{{colors.surface_container_lowest.default.hex}}'
      surface_container_low = '{{colors.surface_container_low.default.hex}}'
      surface_container = '{{colors.surface_container.default.hex}}'
      surface_container_high = '{{colors.surface_container_high.default.hex}}'
      surface_container_highest = '{{colors.surface_container_highest.default.hex}}'
      on_surface = '{{colors.on_surface.default.hex}}'
      on_surface_variant = '{{colors.on_surface_variant.default.hex}}'
      outline = '{{colors.outline.default.hex}}'
      outline_variant = '{{colors.outline_variant.default.hex}}'
      inverse_surface = '{{colors.inverse_surface.default.hex}}'
      inverse_on_surface = '{{colors.inverse_on_surface.default.hex}}'
      surface_variant = '{{colors.surface_variant.default.hex}}'
      background = '{{colors.background.default.hex}}'
      on_background = '{{colors.on_background.default.hex}}'
      shadow = '{{colors.shadow.default.hex}}'
      scrim = '{{colors.scrim.default.hex}}'
      on_tertiary_fixed_variant = '{{colors.on_tertiary_fixed_variant.default.hex}}'
      source_color = '{{colors.source_color.default.hex}}'

      [character]
      success_symbol = "[╰⎯](fg:primary)"
      error_symbol = "[╰⎯](fg:error)"

      [directory]
      style = "fg:on_primary bg:primary"
      format = "[ $path ]($style)"
      truncation_length = 3
      truncation_symbol = "…/"

      [directory.substitutions]
      "Documents" = "󰈙 "
      "Downloads" = " "
      "Music" = " "
      "Pictures" = " "

      [git_branch]
      symbol = ""
      style = "bg:secondary_fixed"
      format = '[[ $symbol $branch ](fg:on_secondary_fixed bg:secondary_fixed)]($style)'

      [git_status]
      style = "bg:secondary_fixed"
      format = '[[($all_status$ahead_behind )](fg:on_secondary_fixed bg:secondary_fixed)]($style)'

      [nodejs]
      symbol = ""
      style = "bg:#ffffff"
      format = '[[ $symbol ($version) ](fg:on_secondary_fixed_variant bg:#ffffff)]($style)'

      [rust]
      symbol = ""
      style = "bg:#ffffff"
      format = '[[ $symbol ($version) ](fg:on_secondary_fixed_variant bg:#ffffff)]($style)'

      [golang]
      symbol = ""
      style = "bg:#ffffff"
      format = '[[ $symbol ($version) ](fg:on_secondary_fixed_variant bg:#ffffff)]($style)'

      [php]
      symbol = ""
      style = "bg:#ffffff"
      format = '[[ $symbol ($version) ](fg:on_secondary_fixed_variant bg:#ffffff)]($style)'

      [python]
      symbol = ""
      style = "bg:#ffffff"
      format = '[[ $symbol ($version) \($virtualenv\) ](fg:on_secondary_fixed_variant bg:#ffffff)]($style)'

      [time]
      disabled = false
      time_format = "%R" # Hour:Minute Format
      style = "bg:surface_bright"
      format = '[[  $time ](fg:on_surface bg:surface_bright)]($style)'

      [battery]
      disabled = false
      charging_symbol = ""
      full_symbol = "󱟢"
      format = '[[ $symbol $percentage ](fg:on_surface bg:surface_bright)](bg:surface_bright)'

      [[battery.display]]
      threshold = 100
      style = "bg:primary fg:on_primary"
    '';

    ".local/share/matugen/template/template.qml".text = ''
      pragma Singleton
      import QtQuick

      QtObject {
          // Primary Colors
          readonly property color primary: "{{colors.primary.default.hex}}"
          readonly property color primary_fixed: "{{colors.primary_fixed.default.hex}}"
          readonly property color primary_fixed_dim: "{{colors.primary_fixed_dim.default.hex}}"
          readonly property color on_primary: "{{colors.on_primary.default.hex}}"
          readonly property color on_primary_fixed: "{{colors.on_primary_fixed.default.hex}}"
          readonly property color on_primary_fixed_variant: "{{colors.on_primary_fixed_variant.default.hex}}"
          readonly property color primary_container: "{{colors.primary_container.default.hex}}"
          readonly property color on_primary_container: "{{colors.on_primary_container.default.hex}}"

          // Secondary Colors
          readonly property color secondary: "{{colors.secondary.default.hex}}"
          readonly property color secondary_fixed: "{{colors.secondary_fixed.default.hex}}"
          readonly property color secondary_fixed_dim: "{{colors.secondary_fixed_dim.default.hex}}"
          readonly property color on_secondary: "{{colors.on_secondary.default.hex}}"
          readonly property color on_secondary_fixed: "{{colors.on_secondary_fixed.default.hex}}"
          readonly property color on_secondary_fixed_variant: "{{colors.on_secondary_fixed_variant.default.hex}}"
          readonly property color secondary_container: "{{colors.secondary_container.default.hex}}"
          readonly property color on_secondary_container: "{{colors.on_secondary_container.default.hex}}"

          // Tertiary Colors
          readonly property color tertiary: "{{colors.tertiary.default.hex}}"
          readonly property color tertiary_fixed: "{{colors.tertiary_fixed.default.hex}}"
          readonly property color tertiary_fixed_dim: "{{colors.tertiary_fixed_dim.default.hex}}"
          readonly property color on_tertiary: "{{colors.on_tertiary.default.hex}}"
          readonly property color on_tertiary_fixed: "{{colors.on_tertiary_fixed.default.hex}}"
          readonly property color on_tertiary_fixed_variant: "{{colors.on_tertiary_fixed_variant.default.hex}}"
          readonly property color tertiary_container: "{{colors.tertiary_container.default.hex}}"
          readonly property color on_tertiary_container: "{{colors.on_tertiary_container.default.hex}}"

          // Error Colors
          readonly property color error: "{{colors.error.default.hex}}"
          readonly property color on_error: "{{colors.on_error.default.hex}}"
          readonly property color error_container: "{{colors.error_container.default.hex}}"
          readonly property color on_error_container: "{{colors.on_error_container.default.hex}}"

          // Surface & Background Colors
          readonly property color surface: "{{colors.surface.default.hex}}"
          readonly property color on_surface: "{{colors.on_surface.default.hex}}"
          readonly property color on_surface_variant: "{{colors.on_surface_variant.default.hex}}"
          readonly property color surface_dim: "{{colors.surface_dim.default.hex}}"
          readonly property color surface_bright: "{{colors.surface_bright.default.hex}}"
          readonly property color surface_container_lowest: "{{colors.surface_container_lowest.default.hex}}"
          readonly property color surface_container_low: "{{colors.surface_container_low.default.hex}}"
          readonly property color surface_container: "{{colors.surface_container.default.hex}}"
          readonly property color surface_container_high: "{{colors.surface_container_high.default.hex}}"
          readonly property color surface_container_highest: "{{colors.surface_container_highest.default.hex}}"

          // Inverse Colors
          readonly property color inverse_surface: "{{colors.inverse_surface.default.hex}}"
          readonly property color inverse_on_surface: "{{colors.inverse_on_surface.default.hex}}"
          readonly property color inverse_primary: "{{colors.inverse_primary.default.hex}}"

          // Other Colors
          readonly property color outline: "{{colors.outline.default.hex}}"
          readonly property color outline_variant: "{{colors.outline_variant.default.hex}}"
          readonly property color shadow: "{{colors.shadow.default.hex}}"
          readonly property color scrim: "{{colors.scrim.default.hex}}"

          // Source Color
          readonly property color source_color: "{{colors.source_color.default.hex}}"

          // Background Colors
          readonly property color background: "{{colors.background.default.hex}}"
          readonly property color on_background: "{{colors.on_background.default.hex}}"
          readonly property color surface_variant: "{{colors.surface_variant.default.hex}}"
      }
    '';

    ".local/share/matugen/template/template.rasi".text = ''
      * {
          primary: {{colors.primary.default.hex}};
          primary-fixed: {{colors.primary_fixed.default.hex}};
          primary-fixed-dim: {{colors.primary_fixed_dim.default.hex}};
          on-primary: {{colors.on_primary.default.hex}};
          on-primary-fixed: {{colors.on_primary_fixed.default.hex}};
          on-primary-fixed-variant: {{colors.on_primary_fixed_variant.default.hex}};
          primary-container: {{colors.primary_container.default.hex}};
          on-primary-container: {{colors.on_primary_container.default.hex}};
          secondary: {{colors.secondary.default.hex}};
          secondary-fixed: {{colors.secondary_fixed.default.hex}};
          secondary-fixed-dim: {{colors.secondary_fixed_dim.default.hex}};
          on-secondary: {{colors.on_secondary.default.hex}};
          on-secondary-fixed: {{colors.on_secondary_fixed.default.hex}};
          on-secondary-fixed-variant: {{colors.on_secondary_fixed_variant.default.hex}};
          secondary-container: {{colors.secondary_container.default.hex}};
          on-secondary-container: {{colors.on_secondary_container.default.hex}};
          tertiary: {{colors.tertiary.default.hex}};
          tertiary-fixed: {{colors.tertiary_fixed.default.hex}};
          tertiary-fixed-dim: {{colors.tertiary_fixed_dim.default.hex}};
          on-tertiary: {{colors.on_tertiary.default.hex}};
          on-tertiary-fixed: {{colors.on_tertiary_fixed.default.hex}};
          on-tertiary-fixed-variant: {{colors.on_tertiary_fixed_variant.default.hex}};
          tertiary-container: {{colors.tertiary_container.default.hex}};
          on-tertiary-container: {{colors.on_tertiary_container.default.hex}};
          error: {{colors.error.default.hex}};
          on-error: {{colors.on_error.default.hex}};
          error-container: {{colors.error_container.default.hex}};
          on-error-container: {{colors.on_error_container.default.hex}};
          surface: {{colors.surface.default.hex}};
          on-surface: {{colors.on_surface.default.hex}};
          on-surface-variant: {{colors.on_surface_variant.default.hex}};
          outline: {{colors.outline.default.hex}};
          outline-variant: {{colors.outline_variant.default.hex}};
          shadow: {{colors.shadow.default.hex}};
          scrim: {{colors.scrim.default.hex}};
          inverse-surface: {{colors.inverse_surface.default.hex}};
          inverse-on-surface: {{colors.inverse_on_surface.default.hex}};
          inverse-primary: {{colors.inverse_primary.default.hex}};
          surface-dim: {{colors.surface_dim.default.hex}};
          surface-bright: {{colors.surface_bright.default.hex}};
          surface-container-lowest: {{colors.surface_container_lowest.default.hex}};
          surface-container-low: {{colors.surface_container_low.default.hex}};
          surface-container: {{colors.surface_container.default.hex}};
          surface-container-high: {{colors.surface_container_high.default.hex}};
          surface-container-highest: {{colors.surface_container_highest.default.hex}};
      }
    '';

    # Zed Material You Theme Template
    ".local/share/matugen/template/one-material3.json".text = ''
      {
        "$schema": "https://zed.dev/schema/themes/v0.2.0.json",
        "name": "Material You",
        "author": "Matugen",
        "themes": [
          {
            "name": "Material You {{mode}}",
            "appearance": "{{mode}}",
            "style": {
              "border": "{{colors.outline_variant.default.hex}}",
              "border.variant": "{{colors.surface_container_high.default.hex}}",
              "border.focused": "{{colors.primary.default.hex}}",
              "border.selected": "{{colors.primary.default.hex}}",
              "border.transparent": "#00000000",
              "border.disabled": "{{colors.surface_container_highest.default.hex}}",

              "elevated_surface.background": "{{colors.surface_container.default.hex}}",
              "surface.background": "{{colors.surface.default.hex}}",
              "background": "{{colors.background.default.hex}}",

              "element.background": "{{colors.surface_container.default.hex}}",
              "element.hover": "{{colors.surface_container_high.default.hex}}",
              "element.active": "{{colors.surface_container_highest.default.hex}}",
              "element.selected": "{{colors.secondary_container.default.hex}}",
              "element.disabled": "{{colors.surface_container_low.default.hex}}",

              "drop_target.background": "{{colors.primary_container.default.hex}}",

              "ghost_element.background": "{{colors.surface_container.default.hex}}",
              "ghost_element.hover": "{{colors.surface_container_high.default.hex}}",
              "ghost_element.active": "{{colors.surface_container_highest.default.hex}}",
              "ghost_element.selected": "{{colors.secondary_container.default.hex}}",
              "ghost_element.disabled": "{{colors.surface_container_low.default.hex}}",

              "text": "{{colors.on_surface.default.hex}}",
              "text.muted": "{{colors.on_surface_variant.default.hex}}",
              "text.placeholder": "{{colors.on_surface_variant.default.hex}}",
              "text.disabled": "{{colors.on_surface_variant.default.hex}}",
              "text.accent": "{{colors.primary.default.hex}}",

              "icon": "{{colors.on_surface.default.hex}}",
              "icon.muted": "{{colors.on_surface_variant.default.hex}}",
              "icon.disabled": "{{colors.on_surface_variant.default.hex}}",
              "icon.placeholder": "{{colors.on_surface_variant.default.hex}}",
              "icon.accent": "{{colors.primary.default.hex}}",

              "status_bar.background": "{{colors.surface.default.hex}}",
              "title_bar.background": "{{colors.surface.default.hex}}",
              "title_bar.inactive_background": "{{colors.surface_container_lowest.default.hex}}",
              "toolbar.background": "{{colors.surface_container.default.hex}}",
              "tab_bar.background": "{{colors.surface_container.default.hex}}",
              "tab.inactive_background": "{{colors.surface_container.default.hex}}",
              "tab.active_background": "{{colors.surface.default.hex}}",

              "search.match_background": "{{colors.secondary_container.default.hex}}66",
              "panel.background": "{{colors.surface_container.default.hex}}",
              "panel.focused_border": "{{colors.primary.default.hex}}",
              "pane.focused_border": "{{colors.primary.default.hex}}",
              "pane_group.border": "{{colors.outline_variant.default.hex}}",

              "scrollbar.thumb.background": "{{colors.surface_container_high.default.hex}}",
              "scrollbar.thumb.hover_background": "{{colors.surface_container_highest.default.hex}}",
              "scrollbar.thumb.border": "{{colors.surface_container_high.default.hex}}",
              "scrollbar.track.background": "#00000000",
              "scrollbar.track.border": "{{colors.outline_variant.default.hex}}",

              "editor.foreground": "{{colors.on_background.default.hex}}",
              "editor.background": "{{colors.background.default.hex}}",
              "editor.gutter.background": "{{colors.background.default.hex}}",
              "editor.subheader.background": "{{colors.surface_container.default.hex}}",
              "editor.active_line.background": "{{colors.surface_container_low.default.hex}}40",
              "editor.highlighted_line.background": "{{colors.surface_container_high.default.hex}}",
              "editor.line_number": "{{colors.on_surface_variant.default.hex}}",
              "editor.active_line_number": "{{colors.on_surface.default.hex}}",
              "editor.invisible": "{{colors.outline_variant.default.hex}}",
              "editor.wrap_guide": "{{colors.outline_variant.default.hex}}33",
              "editor.active_wrap_guide": "{{colors.outline_variant.default.hex}}66",
              "editor.document_highlight.read_background": "{{colors.secondary_container.default.hex}}",
              "editor.document_highlight.write_background": "{{colors.tertiary_container.default.hex}}",
              "editor.document_highlight.bracket_background": "{{colors.primary_container.default.hex}}",

              "terminal.background": "{{colors.background.default.hex}}",
              "terminal.foreground": "{{colors.on_background.default.hex}}",
              "terminal.bright_foreground": "{{colors.on_background.default.hex}}",
              "terminal.dim_foreground": "{{colors.on_surface_variant.default.hex}}",

              "terminal.ansi.black": "{{colors.on_background.default.hex}}",
              "terminal.ansi.bright_black": "{{colors.on_surface_variant.default.hex}}",
              "terminal.ansi.dim_black": "{{colors.shadow.default.hex}}",

              "terminal.ansi.red": "{{colors.error.default.hex}}",
              "terminal.ansi.bright_red": "{{colors.error_container.default.hex}}",
              "terminal.ansi.dim_red": "{{colors.on_error_container.default.hex}}",

              "terminal.ansi.green": "{{colors.tertiary.default.hex}}",
              "terminal.ansi.bright_green": "{{colors.tertiary_container.default.hex}}",
              "terminal.ansi.dim_green": "{{colors.on_tertiary_container.default.hex}}",

              "terminal.ansi.yellow": "{{colors.primary_fixed.default.hex}}",
              "terminal.ansi.bright_yellow": "{{colors.primary_fixed_dim.default.hex}}",
              "terminal.ansi.dim_yellow": "{{colors.on_primary_fixed.default.hex}}",

              "terminal.ansi.blue": "{{colors.primary.default.hex}}",
              "terminal.ansi.bright_blue": "{{colors.primary_container.default.hex}}",
              "terminal.ansi.dim_blue": "{{colors.on_primary_container.default.hex}}",

              "terminal.ansi.magenta": "{{colors.secondary.default.hex}}",
              "terminal.ansi.bright_magenta": "{{colors.secondary_container.default.hex}}",
              "terminal.ansi.dim_magenta": "{{colors.on_secondary_container.default.hex}}",

              "terminal.ansi.cyan": "{{colors.tertiary_fixed.default.hex}}",
              "terminal.ansi.bright_cyan": "{{colors.tertiary_fixed_dim.default.hex}}",
              "terminal.ansi.dim_cyan": "{{colors.on_tertiary_fixed.default.hex}}",

              "terminal.ansi.white": "{{colors.on_background.default.hex}}",
              "terminal.ansi.bright_white": "{{colors.surface_bright.default.hex}}",
              "terminal.ansi.dim_white": "{{colors.surface_dim.default.hex}}",

              "link_text.hover": "{{colors.primary.default.hex}}",

              "conflict": "{{colors.error.default.hex}}",
              "conflict.background": "{{colors.error_container.default.hex}}",
              "conflict.border": "{{colors.error.default.hex}}",

              "created": "{{colors.tertiary.default.hex}}",
              "created.background": "{{colors.tertiary_container.default.hex}}",
              "created.border": "{{colors.tertiary.default.hex}}",

              "deleted": "{{colors.error.default.hex}}",
              "deleted.background": "{{colors.error_container.default.hex}}",
              "deleted.border": "{{colors.error.default.hex}}",

              "error": "{{colors.error.default.hex}}",
              "error.background": "{{colors.error_container.default.hex}}",
              "error.border": "{{colors.error.default.hex}}",

              "hidden": "{{colors.on_surface_variant.default.hex}}",
              "hidden.background": "{{colors.surface_variant.default.hex}}",
              "hidden.border": "{{colors.outline.default.hex}}",

              "hint": "{{colors.primary.default.hex}}",
              "hint.background": "{{colors.primary_container.default.hex}}",
              "hint.border": "{{colors.primary.default.hex}}",

              "ignored": "{{colors.on_surface_variant.default.hex}}",
              "ignored.background": "{{colors.surface_variant.default.hex}}",
              "ignored.border": "{{colors.outline_variant.default.hex}}",

              "info": "{{colors.primary.default.hex}}",
              "info.background": "{{colors.primary_container.default.hex}}",
              "info.border": "{{colors.primary.default.hex}}",

              "modified": "{{colors.secondary.default.hex}}",
              "modified.background": "{{colors.secondary_container.default.hex}}",
              "modified.border": "{{colors.secondary.default.hex}}",

              "predictive": "{{colors.on_surface_variant.default.hex}}",
              "predictive.background": "{{colors.surface_variant.default.hex}}",
              "predictive.border": "{{colors.outline_variant.default.hex}}",

              "renamed": "{{colors.secondary.default.hex}}",
              "renamed.background": "{{colors.secondary_container.default.hex}}",
              "renamed.border": "{{colors.secondary.default.hex}}",

              "success": "{{colors.tertiary.default.hex}}",
              "success.background": "{{colors.tertiary_container.default.hex}}",
              "success.border": "{{colors.tertiary.default.hex}}",

              "unreachable": "{{colors.on_surface_variant.default.hex}}",
              "unreachable.background": "{{colors.surface_variant.default.hex}}",
              "unreachable.border": "{{colors.outline_variant.default.hex}}",

              "warning": "{{colors.primary_fixed_dim.default.hex}}",
              "warning.background": "{{colors.primary_container.default.hex}}",
              "warning.border": "{{colors.primary_fixed_dim.default.hex}}",

              "syntax": {
                "attribute": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "boolean": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "comment": {
                  "color": "{{colors.on_surface_variant.default.hex}}",
                  "font_style": "italic"
                },
                "comment.doc": {
                  "color": "{{colors.on_surface_variant.default.hex}}",
                  "font_style": "italic"
                },
                "constant": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "constructor": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "embedded": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "emphasis": {
                  "font_style": "italic"
                },
                "emphasis.strong": {
                  "font_weight": 700
                },
                "enum": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "function": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "hint": {
                  "color": "{{colors.on_surface_variant.default.hex}}",
                  "font_weight": 700
                },
                "keyword": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "label": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "link_text": {
                  "color": "{{colors.primary.default.hex}}",
                  "font_style": "italic"
                },
                "link_uri": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "number": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "operator": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "predictive": {
                  "color": "{{colors.on_surface_variant.default.hex}}",
                  "font_style": "italic"
                },
                "preproc": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "primary": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "property": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "punctuation": {
                  "color": "{{colors.on_surface_variant.default.hex}}"
                },
                "punctuation.bracket": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "punctuation.delimiter": {
                  "color": "{{colors.on_surface_variant.default.hex}}"
                },
                "punctuation.list_marker": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "punctuation.special": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "string": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "string.escape": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "string.regex": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "string.special": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "string.special.symbol": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "tag": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "text.literal": {
                  "color": "{{colors.tertiary.default.hex}}"
                },
                "title": {
                  "color": "{{colors.primary.default.hex}}",
                  "font_weight": 700
                },
                "type": {
                  "color": "{{colors.primary.default.hex}}"
                },
                "variable": {
                  "color": "{{colors.on_surface.default.hex}}"
                },
                "variable.special": {
                  "color": "{{colors.secondary.default.hex}}"
                },
                "variant": {
                  "color": "{{colors.secondary.default.hex}}"
                }
              }
            }
          }
        ]
      }
    '';

    ".local/share/matugen/template/one-material3.css".text = ''
      /*
      * One Material 3 Theme CSS Variables
      * Generated with Matugen based on Material Design 3 color tokens
      */

      :root {
        /* Primary Colors */
        --md-sys-color-primary: {{colors.primary.default.hex}};
        --md-sys-color-on-primary: {{colors.on_primary.default.hex}};
        --md-sys-color-primary-container: {{colors.primary_container.default.hex}};
        --md-sys-color-on-primary-container: {{colors.on_primary_container.default.hex}};
        --md-sys-color-primary-fixed: {{colors.primary_fixed.default.hex}};
        --md-sys-color-primary-fixed-dim: {{colors.primary_fixed_dim.default.hex}};
        --md-sys-color-on-primary-fixed: {{colors.on_primary_fixed.default.hex}};
        --md-sys-color-on-primary-fixed-variant: {{colors.on_primary_fixed_variant.default.hex}};

        /* Secondary Colors */
        --md-sys-color-secondary: {{colors.secondary.default.hex}};
        --md-sys-color-on-secondary: {{colors.on_secondary.default.hex}};
        --md-sys-color-secondary-container: {{colors.secondary_container.default.hex}};
        --md-sys-color-on-secondary-container: {{colors.on_secondary_container.default.hex}};
        --md-sys-color-secondary-fixed: {{colors.secondary_fixed.default.hex}};
        --md-sys-color-secondary-fixed-dim: {{colors.secondary_fixed_dim.default.hex}};
        --md-sys-color-on-secondary-fixed: {{colors.on_secondary_fixed.default.hex}};
        --md-sys-color-on-secondary-fixed-variant: {{colors.on_secondary_fixed_variant.default.hex}};

        /* Tertiary Colors */
        --md-sys-color-tertiary: {{colors.tertiary.default.hex}};
        --md-sys-color-on-tertiary: {{colors.on_tertiary.default.hex}};
        --md-sys-color-tertiary-container: {{colors.tertiary_container.default.hex}};
        --md-sys-color-on-tertiary-container: {{colors.on_tertiary_container.default.hex}};
        --md-sys-color-tertiary-fixed: {{colors.tertiary_fixed.default.hex}};
        --md-sys-color-tertiary-fixed-dim: {{colors.tertiary_fixed_dim.default.hex}};
        --md-sys-color-on-tertiary-fixed: {{colors.on_tertiary_fixed.default.hex}};
        --md-sys-color-on-tertiary-fixed-variant: {{colors.on_tertiary_fixed_variant.default.hex}};

        /* Error Colors */
        --md-sys-color-error: {{colors.error.default.hex}};
        --md-sys-color-on-error: {{colors.on_error.default.hex}};
        --md-sys-color-error-container: {{colors.error_container.default.hex}};
        --md-sys-color-on-error-container: {{colors.on_error_container.default.hex}};

        /* Surface Colors */
        --md-sys-color-surface: {{colors.surface.default.hex}};
        --md-sys-color-on-surface: {{colors.on_surface.default.hex}};
        --md-sys-color-surface-variant: {{colors.surface_variant.default.hex}};
        --md-sys-color-on-surface-variant: {{colors.on_surface_variant.default.hex}};
        --md-sys-color-surface-dim: {{colors.surface_dim.default.hex}};
        --md-sys-color-surface-bright: {{colors.surface_bright.default.hex}};
        --md-sys-color-surface-container-lowest: {{colors.surface_container_lowest.default.hex}};
        --md-sys-color-surface-container-low: {{colors.surface_container_low.default.hex}};
        --md-sys-color-surface-container: {{colors.surface_container.default.hex}};
        --md-sys-color-surface-container-high: {{colors.surface_container_high.default.hex}};
        --md-sys-color-surface-container-highest: {{colors.surface_container_highest.default.hex}};

        /* Background Colors */
        --md-sys-color-background: {{colors.background.default.hex}};
        --md-sys-color-on-background: {{colors.on_background.default.hex}};

        /* Outline Colors */
        --md-sys-color-outline: {{colors.outline.default.hex}};
        --md-sys-color-outline-variant: {{colors.outline_variant.default.hex}};

        /* Inverse Colors */
        --md-sys-color-inverse-surface: {{colors.inverse_surface.default.hex}};
        --md-sys-color-inverse-on-surface: {{colors.inverse_on_surface.default.hex}};
        --md-sys-color-inverse-primary: {{colors.inverse_primary.default.hex}};

        /* Other Colors */
        --md-sys-color-shadow: {{colors.shadow.default.hex}};
        --md-sys-color-scrim: {{colors.scrim.default.hex}};
        --md-sys-color-source-color: {{colors.source_color.default.hex}};
      }

      /* Material 3 Component Styles */
      .md3-button {
        background-color: var(--md-sys-color-primary);
        color: var(--md-sys-color-on-primary);
        border: none;
        border-radius: 20px;
        padding: 10px 24px;
        font-weight: 500;
      }

      .md3-button:hover {
        background-color: var(--md-sys-color-primary-container);
        color: var(--md-sys-color-on-primary-container);
      }

      .md3-card {
        background-color: var(--md-sys-color-surface-container);
        color: var(--md-sys-color-on-surface);
        border-radius: 12px;
        border: 1px solid var(--md-sys-color-outline-variant);
      }

      .md3-surface {
        background-color: var(--md-sys-color-surface);
        color: var(--md-sys-color-on-surface);
      }

      .md3-background {
        background-color: var(--md-sys-color-background);
        color: var(--md-sys-color-on-background);
      }
    '';
  };
}
