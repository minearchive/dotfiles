{
  inputs = {
    #Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap.url = "github:xremap/nix-flake";
    
    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland"; # Prevents version mismatch.
    };

    # Ricing stuff
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/Matugen";
    };
    swww.url = "github:LGFae/swww";
    
    ags.url = "github:Aylur/ags";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      msiLaptop = inputs.nixpkgs.lib.nixosSystem {
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
      material = inputs.home-manager.lib.homeManagerConfiguration {
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
