{ ... }:
{
  home.file = {
    ".config/matugen/config.toml".text = ''
      [config]
      [templates.kitty]
      input_path = "~/.local/share/matugen/template/kitty-colors.conf"
      output_path = "~/.config/kitty/colors.conf"
      post_hook = 'pkill -SIGUSR1 kitty'

      [templates.quickshell]
      input_path = "~/.local/share/matugen/template/template.qml"
      output_path = "~/shell/src/configurations/colors.qml"

      [templates.gtk3]
      input_path = "~/.local/share/matugen/template/gtk_theme.css"
      output_path = "~/.config/gtk-3.0/colors.css"
      post_hook = 'gsettings set org.gnome.desktop.interface gtk-theme ""; gsettings set org.gnome.desktop.interface gtk-theme adw-gtk3-{{mode}}'

      [templates.gtk4]
      input_path = "~/.local/share/matugen/template/gtk_theme.css"
      output_path = "~/.config/gtk-4.0/colors.css"
    '';

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

          readonly property string mode : "{{ mode }}"
      }
    '';

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
  };
}
