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
  
  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-wsl,
    kickstart-nix-nvim,
    ...
  } @ inputs: {
    nixosConfigurations = {
      # ThinkPad configuration with gaming
      thinker = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./hosts/thinker/configuration.nix
        ];
      };
      
      # WSL work configuration without gaming
      work-wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ]; }
          nixos-wsl.nixosModules.wsl
          ./hosts/work-wsl/configuration.nix
        ];
      };

      # Legacy configuration names for backward compatibility
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./hosts/thinker/configuration.nix
        ];
      };
      
      Thinker = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ]; }
          home-manager.nixosModules.home-manager
          ./hosts/thinker/configuration.nix
        ];
      };
    };
  };
}
