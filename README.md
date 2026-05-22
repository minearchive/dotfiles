# minearchive/dotfiles

NixOS + Home Manager dotfiles with a modern Wayland desktop environment powered by Hyprland, QuickShell (QML), and dynamic Material Design 3 theming.

## Overview

This repository manages system configurations for multiple NixOS hosts and Home Manager profiles using Nix Flakes.

- **Primary Desktop Environment**: pastel (Active)
- **Deprecated Profile**: material (Deprecated)
- **Minimal CLI Profile**: wsl (Windows Subsystem for Linux)

---

## Technology Stack

- **Window Manager**: [Hyprland](https://hyprland.org/) — Wayland compositor
- **Desktop Shell**: [QuickShell](https://git.outfoxxed.me/outfoxxed/quickshell) — QML-based desktop shell components (topbar, panels)
- **Theming**: [Matugen](https://github.com/InioX/Matugen) — Material Design 3 dynamic color generation from the current wallpaper
- **Shell**: [Fish Shell](https://fishshell.com/) — Interactive user shell
- **Editor**: [Neovim](https://neovim.io/) — Declaratively configured via [Nixvim](https://github.com/nix-community/nixvim)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/) — GPU-accelerated terminal emulator
- **Input Method**: Fcitx5-Mozc — Japanese IME

---

## System Architecture

### Hosts (hosts/)

| Hostname | Target Hardware | Core Features |
|:---|:---|:---|
| `msiLaptop` | Intel GPU Laptop | Intel graphics drivers, KDE Connect |
| `desktop` | NVIDIA GPU Desktop | NVIDIA open drivers, Secure Boot ([Lanzaboote](https://github.com/nix-community/lanzaboote)), Samba |
| `wsl` | Windows Subsystem for Linux | Minimal headless environment |

### Home Manager Profiles

| Profile | Desktop Environment | Core Focus / Active State |
|:---|:---|:---|
| `pastel` | **Hyprland + QuickShell** | **Current & Active Environment**. Premium Material Design 3 integration. |
| `wsl` | Headless (CLI only) | Minimal CLI environment (Fish shell + LLM agents). |
| `material` | *None* | **Deprecated**. Kept for historical reference. |

---

## Setup & Deployment

### 1. Clone the Repository
```bash
git clone https://github.com/minearchive/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Initialization
Run the initialization script to select your host and Home Manager profile. This generates the necessary `rebuild.sh` and `update-home.sh` scripts, which do not exist initially:
```bash
sh init.sh
```

### 3. Host Configuration (NixOS)
Apply the system configuration using the generated `rebuild.sh` script:
```bash
sh rebuild.sh
```
Or run the system rebuild directly:
```bash
sudo nixos-rebuild switch --flake .#<host>
# e.g., sudo nixos-rebuild switch --flake .#desktop
```

### 4. User Configuration (Home Manager)
Apply the user profile using the generated `update-home.sh` script:
```bash
sh update-home.sh
```
Or run Home Manager directly:
```bash
NIXPKGS_ALLOW_UNFREE=1 home-manager switch --flake .#pastel -b backup --impure
```

---

## License

MIT License
