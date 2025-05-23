{
  config,
  pkgs,
  lib,
  ...
}:

let
  home-manager = (
    builtins.fetchTarball {
      url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
      sha256 = "03z2v28ac11bisxf9n73brrjp85878wapqs9853p0f73vx8a5jfw";
    }
  );
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users.calvin.isNormalUser = true;
  home-manager.users.calvin =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.atool
        pkgs.httpie
      ];
      programs.home-manager.enable = true;

      programs.git = {
        enable = true;
        userName = "Calvin Loveland";
        userEmail = "calvinloveland@gmail.com";
        extraConfig.safe.directory = "*";
      };

      programs.neovim = {
        enable = true;
        vimAlias = true;
        viAlias = true;
      };
      programs.swaylock = {
        enable = true;
      };

      wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
        config = rec {
          modifier = "Mod4";
          terminal = "alacritty";
          startup = [
            # Launch swaybg
            { command = "swaybg -o '*' -i ~/Pictures/background.jpg"; }
          ];
        };
      };

      # The state version is required and should stay at the version you
      # originally installed.
      home.stateVersion = "25.05";
    };
}
