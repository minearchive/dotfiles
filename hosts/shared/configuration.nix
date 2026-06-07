{
  inputs,
  config,
  lib,
  pkgs,
  options,
  ...
}:

{
  imports = [
    inputs.xremap.nixosModules.default
  ];

  networking.timeServers = options.networking.timeServers.default ++ [ "ntp.nict.jp" ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time = {
    timeZone = "Asia/Tokyo"; # ok fuck this setting
    hardwareClockInLocalTime = false;
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    extraLocaleSettings = {
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
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      fcitx5.waylandFrontend = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.jetbrains-mono
      nerd-fonts.blex-mono
      udev-gothic
    ];

    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  xdg.portal = {
    enable = true;
    #extraPortals = with pkgs; [
    #  xdg-desktop-portal-gtk
    #];
    #config.niri = {
    #  default = [ "gnome" "gtk" ];
    #  "org.freedesktop.impl.portal.Access" = "gtk";
    #  "org.freedesktop.impl.portal.Notification" = "gtk";
    #  "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
    #  "org.freedesktop.impl.portal.FileChooser" = "gtk";
    #  "org.freedesktop.impl.portal.ScreenCast" = "gnome";
    #};
  };

  services.xremap = {
    enable = true;
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
            not = [
              "Aracritty"
              "Kitty"
              "Wezterm"
            ];
          };
        }
      ];
    };
  };

  #services.timesyncd.enable = true;
  #services.ntp.enable = true;
  services = {
    chrony.enable = true;
    seatd.enable = true;
    flatpak.enable = true;
    blueman.enable = true;
    systembus-notify.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "jp";
        variant = "";
      };
    };
    displayManager = {
      gdm.enable = true;
      autoLogin = {
        enable = true;
        user = "minearchive";
      };
    };
    desktopManager.gnome.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        enable = true;
        configPackages = [
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-mitigate-annoying-profile-switch.conf" ''
            wireplumber.settings = {
              bluetooth.autoswitch-to-headset-profile = false
            }

            monitor.bluez.properties = {
              bluez5.roles = [ a2dp_sink a2dp_source ]
            }
          '')
        ];
      };
    };
    tailscale.enable = true;
    openssh.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  security.rtkit.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.minearchive = {
    isNormalUser = true;
    description = "MineArchive";
    extraGroups = [
      "networkmanager"
      "wheel"
      "seat"
    ];
    shell = pkgs.zsh;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
      seatd.serviceConfig = {
        Type = lib.mkForce "simple";
        ExecStart = lib.mkForce "${pkgs.seatd}/bin/seatd -u root -g seat -l info";
      };
    };
    packages = [ pkgs.cloudflare-warp ];
    targets.multi-user.wants = [ "warp-svc.service" ];
  };

  # installing systems packages
  environment = {
    systemPackages = with pkgs; [
      tzdata
      zsh
      vim
      wget
      seatd
      kitty
      rustup
      cargo
      fcitx5-gtk
      inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
      inputs.matugen.packages.${pkgs.stdenv.hostPlatform.system}.default

      libnotify
      mako
      cloudflare-warp
      sbctl
    ];
    variables.NIXOS_OZONE_WL = "1";
  };

  system.stateVersion = "24.11";

  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 21474836480;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "root" "@wheel" ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  nixpkgs.config.allowUnfree = true;

  hardware.graphics.enable = true;

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ config.services.tailscale.port ];

    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true; # $DOCKER_HOSTを設定
      };
    };

    waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };

  programs = {
    noisetorch.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    git = {
      enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    zsh = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    uwsm = {
      enable = true;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          comment = "Hyprland compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/start-hyprland";
        };
      };
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        openssl
        zlib
        curl
        glib
        libgcc
      ];
    };
  };
}
