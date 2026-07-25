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
    # Base theme underneath the overrides below; supplies any token left unset.
    name = "catppuccin"

    [theme.custom]
    # Structural tokens, derived from the M3 scheme.
    accent = "{{colors.primary.default.hex}}"
    panel_bg = "{{colors.background.default.hex}}"

    # Fixed-hue tokens. M3 has no green/yellow/teal/peach role, so these hold the
    # same hues as the kitty palette (bright variants) rather than tracking the
    # wallpaper - herdr renders inside kitty, so the two should agree.
    red = "#c49ea0"
    green = "#9ec49f"
    yellow = "#c4c19e"
    blue = "#a39ec4"
    teal = "#9ec3c4"
    mauve = "#c49ec4"

    # To let these follow the wallpaper instead, swap in the M3 roles:
    # red = "{{colors.error.default.hex}}"
    # blue = "{{colors.secondary.default.hex}}"
    # mauve = "{{colors.tertiary.default.hex}}"

    # peach has no counterpart in either palette; left unset -> catppuccin's.
  '';
}
