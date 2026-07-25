{ ... }:
{
  home.file.".config/matugen/config.toml".text = ''
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

    [templates.zed]
    input_path = "~/.local/share/matugen/template/zed.json"
    output_path = "~/.config/zed/themes/matugen.json"

    [templates.shell]
    input_path = "/home/minearchive/project/gtk_shell/example/template.toml"
    output_path = "/home/minearchive/project/gtk_shell/example/theme.toml"

    [templates.herdr]
    input_path = "~/.local/share/matugen/template/herdr.toml"
    output_path = "~/.config/herdr/config.toml"
    post_hook = "herdr server reload-config"
  '';
}
