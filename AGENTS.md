# Project Overview: dotfiles

This repository manages the system configuration for NixOS and Home Manager using Flakes.

## ⚠️ Critical Information for Agents
- **Primary Configuration:** The `pastel` home configuration is the current and active environment.
- **Deprecated:** The `material` home configuration is **deprecated**. Do not make changes to it unless explicitly requested.

## System Architecture

### Hosts
- `msiLaptop`: Laptop configuration.
- `desktop`: Desktop configuration with `lanzaboote` (Secure Boot) support.
- `wsl`: Windows Subsystem for Linux configuration.

### Home Configurations
- `pastel`: The modern, active environment.
  - **Window Manager:** Hyprland
  - **Shell:** fish
  - **UI Framework:** quickshell (QML-based)
  - **Key Tools:** `matugen` (Material You color generation), `fcitx5` (Input Method), `kitty`, `neovim`, `zen-browser`.
- `wsl`: Lightweight configuration for WSL environments.

## Directory Structure
- `hosts/`: NixOS system-level configurations per machine.
- `pastel/`: Active Home Manager configuration and tool settings.
- `material/`: (Deprecated) Old Home Manager configuration.
- `wsl/`: WSL-specific settings.

## Workflow
- Use `sh update-home.sh` to apply Home Manager changes.
- Configuration for various programs is located in `pastel/programs/`.
- General tools and services are managed in `pastel/tools.nix`.
