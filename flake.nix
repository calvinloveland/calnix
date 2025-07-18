{
  description = "Calvin's Multi-Host NixOS Configuration";
  inputs = {
    kickstart-nix-nvim = {
      url = "github:nix-community/kickstart-nix.nvim";
    };
    # User's nixpkgs - for user packages
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-wsl,
      kickstart-nix-nvim,
      ...
    }@inputs:
    let
      # Create an overlay to fix the Darktable build issue
      darktableOverlay = final: prev: {
        # Override darktable to disable AVIF support which is causing build issues
        darktable = prev.darktable.override {
          libavif = null; # Disable AVIF support to avoid the build error
        };
      };
    in
    {
      nixosConfigurations = {
        # ThinkPad configuration with gaming
        thinker = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ 
                kickstart-nix-nvim.overlays.default
                darktableOverlay # Add our Darktable fix overlay
              ]; 
            }
            home-manager.nixosModules.home-manager
            ./hosts/thinker/configuration.nix
          ];
        };

        # WSL work configuration without gaming
        work-wsl = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ 
                kickstart-nix-nvim.overlays.default
                # No darktable overlay needed for WSL as it doesn't include gaming module
              ]; 
            }
            nixos-wsl.nixosModules.wsl
            ./hosts/work-wsl/configuration.nix
          ];
        };

        # HP Elitebook configuration with gaming
        "1337book" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ 
                kickstart-nix-nvim.overlays.default
                darktableOverlay # Add our Darktable fix overlay
              ]; 
            }
            home-manager.nixosModules.home-manager
            ./hosts/1337book/configuration.nix
          ];
        };

        # Legacy configuration names for backward compatibility
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ 
                kickstart-nix-nvim.overlays.default 
                darktableOverlay # Add our Darktable fix overlay
              ]; 
            }
            home-manager.nixosModules.home-manager
            ./hosts/thinker/configuration.nix
          ];
        };

        Thinker = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ 
                kickstart-nix-nvim.overlays.default
                darktableOverlay # Add our Darktable fix overlay
              ]; 
            }
            home-manager.nixosModules.home-manager
            ./hosts/thinker/configuration.nix
          ];
        };
      };
    };
}
