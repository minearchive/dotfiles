{ inputs, config, pkgs, options, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ]

  ++ [
    inputs.xremap.nixosModules.default
  ];

    networking.timeServers = options.networking.timeServers.default ++ [ "ntp.nict.jp" ]; 

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [pkgs.fcitx5-mozc];
  };

  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
    ];

    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
	sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
	monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
	emoji = ["Noto Color Emoji"];
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  services.xremap = {
    userName = "minearchive";
    serviceMode = "system";
    config = {
      modmap = [
        {
	  name = "CapsLock is Ctrl";
	  remap = {
	    CapsLock = "Ctrl_L";
	  };
	}
      ];
      keymap = [
        {
	  name = "Ctrl+H should be enabled on all apps as BackSpace";
	  remap = {
	    C-h = "Backspace";
	  };
	  application = {
	    not = ["Aracritty" "Kitty"  "Wezterm"];
	  };
	}
      ];
    };
  };

  services.timesyncd.enable = true;
  services.ntp.enable = true;
  services.seatd.enable = true;
  services.flatpak.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.minearchive = {
    isNormalUser = true;
    description = "MineArchive";
    extraGroups = [ "networkmanager" "wheel" "seat"];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "minearchive";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    zsh
    vim
    wget
    neovim
    seatd
    kitty
    foot
    rustup
    cargo
    fcitx5-gtk
  ];
  system.stateVersion = "24.11";

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
    ];
  }; 


  #tailscale vpn
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    # tailscaleの仮想NICを信頼する
    # `<Tailscaleのホスト名>:<ポート番号>`のアクセスが可能になる
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true; # $DOCKER_HOSTを設定
      };
    };
  };

  boot.kernelParams = [ "i915.force_probe=a7aa" ];
  hardware.graphics.extraPackages = with pkgs; [ vaapiIntel intel-media-driver ];

  programs = {
    noisetorch.enable = true;

    git = {
      enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    starship = {
      enable = true;

      settings = {

      };
    };

    zsh = {
      enable = true;
    };

    fish.enable = true;
  };

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors = {
    hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.variables.NIXOS_OZONE_WL = "1";

  networking.firewall = rec {
    allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
    allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
  };

  programs.nix-ld.enable = true;
}
