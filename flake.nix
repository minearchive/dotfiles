{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap.url = "github:xremap/nix-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    ags.url = "github:Aylur/ags";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/Matugen";
    };
    swww.url = "github:LGFae/swww";
  };

  outputs = inputs: {
    nixosConfigurations = {
      myNixOS = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/configuration.nix
	        ./system/hyprland.nix
        ];
	      specialArgs = {
           inherit inputs;
       };
      };
    };
    homeConfigurations = {
      myHome = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
	        system = "x86_64-linux";
	        config.allowUnfree = true;
	      };
	      extraSpecialArgs = {
	        inherit inputs;
	      };
	      modules = [
	        ./home.nix
	      ];
      };
    };
  };
}
