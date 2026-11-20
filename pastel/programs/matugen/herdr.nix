{ ... }:
{
  home.file.".local/share/matugen/template/herdr.toml".text = ''
    [terminal]
    default_shell = "fish"

    [ui]
    agent_panel_sort = "priority"

    [experimental]
    kitty_graphics = true
    resume_agents_on_restore = true

    [theme]
    name = "catppuccin"

    [theme.custom]
    accent = "{{colors.primary.default.hex}}"
    panel_bg = "{{colors.background.default.hex}}"

    red = "#c49ea0"
    green = "#9ec49f"
    yellow = "#c4c19e"
    blue = "#a39ec4"
    teal = "#9ec3c4"
    mauve = "#c49ec4"
  '';
}
