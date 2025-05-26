{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Ensure calvin user exists
  users.users.calvin.isNormalUser = true;

  # Home Manager user configuration
  home-manager.users.calvin =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.atool
        pkgs.httpie
        pkgs.brightnessctl
      ];

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

      programs.swaylock.enable = true;

      wayland.windowManager.sway = {
        enable = true;
        config = rec {
          modifier = "Mod4";
          terminal = "alacritty";
          keybindings = lib.mkOptionDefault {
            # Volume controls (PipeWire)
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

            # Brightness controls (using brightnessctl)
            "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
            "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
          };
          startup = [
            { command = "swaybg -o '*' -i ~/Pictures/background.jpg"; }
          ];
        };
      };

      home.stateVersion = "25.05";
    };
}
