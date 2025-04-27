{ config, pkgs, lib, ... }:

let
  home-manager = (builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
    sha256 = "1qsvg11b5d05z2gvxq2pp6xfg3gpcd363id0h52sicikx3vai93s";});
in
{
  imports =
    [
      (import "${home-manager}/nixos")
    ];

  users.users.calvin.isNormalUser = true;
  home-manager.users.calvin = { pkgs, ... }: {
    home.packages = [ pkgs.atool pkgs.httpie ];
    programs.home-manager.enable = true;
    
    programs.git = {
	    enable = true;
	    userName = "Calvin Loveland";
	    userEmail = "calvinloveland@gmail.com";
	  }; 
    

      wayland.windowManager.sway = {
	    enable = true;
	    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
	    config = rec {
	      modifier = "Mod4";
	      terminal = "alacritty"; 
	      startup = [
		# Launch Fish on start
		{command = "fish";}
	      ];
	    };
  };

 
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
