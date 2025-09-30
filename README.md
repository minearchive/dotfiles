
# minearchive/dotfiles

## Overview

This repository provides an automated dotfiles management environment using NixOS and Home Manager.  
It includes a rich desktop experience with Hyprland, QuickShell, Matugen, and unified configuration for various tools and applications.

## Features

- **NixOS**: Reproducible system configuration
- **Home Manager**: Declarative user environment management
- **Hyprland**: Next-generation Wayland compositor
- **QuickShell**: Custom QML shell environment
- **Matugen, swww, ags, spicetify-nix** and other desktop tools
- Japanese locale, fonts, and IME (fcitx5-mozc) support

## Setup

1. **Install NixOS**
2. Clone this repository
     ```sh
     git clone https://github.com/minearchive/dotfiles.git ~/.dotfiles
     cd ~/.dotfiles
     ```
3. **Apply Home Manager / System configuration**
     - System:  
         ```sh
         sudo nixos-rebuild switch --flake .#msiLaptop
         ```
     - User:  
         ```sh
         home-manager switch --flake .#material
         ```
     - Or
         ```sh
         ./rebuild.sh
         ./update-home.sh
         ```

## Directory Structure

- `flake.nix` / `flake.lock` ... Nix Flake configuration
- `system/` ... NixOS system configuration
- `home.nix` ... Home Manager configuration
- `material/` ... Desktop and application settings
- `material/quickshell/` ... QuickShell QML files
- `material/hypr/` ... Hyprland configuration
- `material/firefox/` ... Firefox custom CSS

## Dependencies

- NixOS (unstable)
- Home Manager
- Hyprland
- QuickShell
- Matugen
- swww
- ags
- spicetify-nix
- See also flake.nix

## License

MIT



