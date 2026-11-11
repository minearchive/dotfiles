{
  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://pi.cachix.org"
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "pi.cachix.org-1:lGeoGJaZ5ZDabuRzkcD5EBTNnDM4HJ1vqeOxlWk1Flk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    llm-agents-nix.url = "github:numtide/llm-agents.nix";

    hermes-agent.url = "github:NousResearch/hermes-agent";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    herdr = {
      url = "github:ogulcancelik/herdr/v0.7.4";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    kyoshin-flake.url = "github:minearchive/kyoshin-flake";

    # The bar. `nix flake update my-shell` picks up new commits on the branch.
    my-shell.url = "github:minearchive/shell/spike/antiwebui";

    matugen.url = "github:InioX/Matugen";

    nixcord = {
      url = "github:4evy/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nixpkgs-yt-dlp.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    swww.url = "github:LGFae/swww";

    xremap.url = "github:xremap/nix-flake";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pi = {
      url = "github:lukasl-dev/pi.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sidra = {
      url = "github:wimpysworld/sidra";
    };

    shojiwm = {
      url = "github:bea4dev/ShojiWM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      user = import ./user.nix;

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkSystem =
        modules:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system modules;
          specialArgs = { inherit inputs user; };
        };

      mkHome =
        modules:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs user; };
          inherit modules;
        };

      pre-commit-check = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks.nixfmt.enable = true;
      };
    in
    {
      nixosConfigurations = {
        msiLaptop = mkSystem [ ./hosts/msiLaptop/configuration.nix ];
        desktop = mkSystem [
          ./hosts/desktop/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
        wsl = mkSystem [ ./hosts/wsl/configuration.nix ];
      };

      homeConfigurations = {
        material = mkHome [ ./material/material.nix ];
        "pastel@msiLaptop" = mkHome [
          ./pastel/pastel.nix
          ./pastel/hosts/msiLaptop.nix
        ];
        "pastel@desktop" = mkHome [
          ./pastel/pastel.nix
          ./pastel/hosts/desktop.nix
        ];
        wsl = mkHome [ ./wsl/wsl.nix ];
      };

      checks.${system} = {
        inherit pre-commit-check;

        fontconfig-compat =
          let
            host = inputs.self.nixosConfigurations.msiLaptop.config;
            defaults = host.fonts.fontconfig.defaultFonts;
          in
          pkgs.runCommand "fontconfig-compat-check"
            {
              FONTCONFIG_FILE = "${host.environment.etc.fonts.source}/fonts.conf";
            }
            ''
              export HOME="$TMPDIR/home" XDG_CACHE_HOME="$TMPDIR/cache"
              mkdir -p "$HOME" "$XDG_CACHE_HOME"
              check() {
                actual=$("$1" -f '%{family[0]}' "$2" 2> "$TMPDIR/warnings")
                test ! -s "$TMPDIR/warnings" || { cat "$TMPDIR/warnings"; exit 1; }
                test "$actual" = "$3" || { echo "$2: expected $3, got $actual"; exit 1; }
              }
              for matcher in \
                ${pkgs.fontconfig.bin}/bin/fc-match \
                ${inputs.nixpkgs-stable.legacyPackages.${system}.fontconfig.bin}/bin/fc-match; do
                check "$matcher" sans-serif ${pkgs.lib.escapeShellArg (builtins.head defaults.sansSerif)}
                check "$matcher" serif ${pkgs.lib.escapeShellArg (builtins.head defaults.serif)}
                check "$matcher" monospace ${pkgs.lib.escapeShellArg (builtins.head defaults.monospace)}
              done
              touch "$out"
            '';
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
      };
    };
}
