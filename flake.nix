{
  description = "Calvin's Linux";
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
  };
  outputs =
    {
      self,
      nixpkgs,
      kickstart-nix-nvim,
      ...
    }@inputs:
    let
      HOSTNAME = "Thinker";
      nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ];
      config = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          inputs.home-manager.nixosModules.home-manager
          ./configuration.nix
        ];
      };
    in
    {
      nixpkgs.overlays = [ kickstart-nix-nvim.overlays.default ];
      nixosConfigurations.nixos = config;
      nixosConfigurations.Thinker = config;
    };
}
