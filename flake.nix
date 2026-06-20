{
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    llm-agents-nix.url = "github:numtide/llm-agents.nix";

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

    matugen.url = "github:InioX/Matugen";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

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

    sidra = {
      url = "github:wimpysworld/sidra";
    };
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";

      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkSystem =
        modules:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system modules;
          specialArgs = { inherit inputs; };
        };

      mkHome =
        modules:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          inherit modules;
        };

      pre-commit-check = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks.nixfmt-rfc-style.enable = true;
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
        pastel = mkHome [ ./pastel/pastel.nix ];
        wsl = mkHome [ ./wsl/wsl.nix ];
      };

      checks.${system}.pre-commit-check = pre-commit-check;

      devShells.${system}.default = pkgs.mkShell {
        inherit (pre-commit-check) shellHook;
      };
    };
}
