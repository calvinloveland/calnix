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
        # Bluetooth utilities
        pkgs.bluetuith  # Terminal-based Bluetooth manager
        pkgs.bluez-alsa # ALSA plugin for Bluetooth audio
      ];

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          # Import colorscheme from 'wal' asynchronously
          if test -f ~/.cache/wal/sequences
            cat ~/.cache/wal/sequences
          end
          
          # To add support for TTYs this line can be optionally added
          if test -f ~/.cache/wal/colors-tty.sh
            source ~/.cache/wal/colors-tty.sh
          end
        '';
      };

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

      # Configure Alacritty terminal with proper fonts and pywal colors
      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            normal = {
              family = "JetBrains Mono";
              style = "Regular";
            };
            bold = {
              family = "JetBrains Mono";
              style = "Bold";
            };
            italic = {
              family = "JetBrains Mono";
              style = "Italic";
            };
            size = 12.0;
          };
          window = {
            padding = {
              x = 10;
              y = 10;
            };
            opacity = 0.95;
          };
          # Import pywal colors
          import = [ "~/.cache/wal/colors-alacritty.yml" ];
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        config = rec {
          modifier = "Mod4";
          terminal = "alacritty";
          
          # Use actual color values instead of pywal variables during build
          colors = {
            focused = {
              border = "#7c3aed";
              background = "#7c3aed";
              text = "#ffffff";
              indicator = "#7c3aed";
              childBorder = "#7c3aed";
            };
            focusedInactive = {
              border = "#374151";
              background = "#374151";
              text = "#ffffff";
              indicator = "#374151";
              childBorder = "#374151";
            };
            unfocused = {
              border = "#1f2937";
              background = "#1f2937";
              text = "#9ca3af";
              indicator = "#1f2937";
              childBorder = "#1f2937";
            };
            urgent = {
              border = "#ef4444";
              background = "#ef4444";
              text = "#ffffff";
              indicator = "#ef4444";
              childBorder = "#ef4444";
            };
          };
          
          # Window and border settings
          window = {
            border = 2;
            titlebar = false;
          };
          
          # Gaps configuration
          gaps = {
            inner = 10;
            outer = 5;
          };

          keybindings = lib.mkOptionDefault {
            # Volume controls (PipeWire)
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

            # Brightness controls (using brightnessctl)
            "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
            "XF86MonBrightnessDown" = "exec brightnessctl set 10%-";
            
            # Bluetooth controls
            "${modifier}+b" = "exec blueberry";  # Open Bluetooth manager GUI
            "${modifier}+Shift+b" = "exec ${terminal} -e bluetuith";  # Open terminal Bluetooth manager
            
            # Pywal controls - generate colors from wallpaper and update Sway
            "${modifier}+w" = "exec ~/.config/sway/update-colors.sh";
            
            # Alternative: choose wallpaper with file picker
            "${modifier}+Shift+w" = "exec ~/.config/sway/choose-wallpaper.sh";
          };
          startup = [
            { command = "wal -R"; }  # Restore last pywal color scheme
            { command = "~/.config/sway/apply-colors.sh"; }  # Apply colors to Sway
            { command = "swaybg -o '*' -i ~/Pictures/background.jpg"; }
          ];
        };
        
        # Include pywal colors dynamically
        extraConfig = ''
          # Include pywal color scheme if available
          include ~/.cache/wal/colors-sway
        '';
      };

      # Create scripts for color management
      home.file = {
        ".config/sway/update-colors.sh" = {
          text = ''
            #!/bin/sh
            # Generate colors from current wallpaper
            if [ -f ~/Pictures/background.jpg ]; then
              wal -i ~/Pictures/background.jpg
              # Apply colors to Sway
              ~/.config/sway/apply-colors.sh
              # Reload Sway to pick up new colors
              swaymsg reload
            else
              notify-send "No wallpaper found" "Please place an image at ~/Pictures/background.jpg"
            fi
          '';
          executable = true;
        };
        
        ".config/sway/choose-wallpaper.sh" = {
          text = ''
            #!/bin/sh
            # Choose wallpaper with file picker
            WALLPAPER=$(find ~/Pictures -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | rofi -dmenu -p "Choose wallpaper:")
            if [ -n "$WALLPAPER" ]; then
              wal -i "$WALLPAPER"
              ~/.config/sway/apply-colors.sh
              swaymsg reload
            fi
          '';
          executable = true;
        };
        
        ".config/sway/apply-colors.sh" = {
          text = ''
            #!/bin/sh
            # Apply pywal colors to Sway configuration
            if [ -f ~/.cache/wal/colors.sh ]; then
              . ~/.cache/wal/colors.sh
              
              # Create Sway color configuration
              cat > ~/.cache/wal/colors-sway << EOF
# Pywal colors for Sway
set \$bg $color0
set \$fg $color7
set \$accent $color1
set \$urgent $color9
set \$inactive $color8

# Window colors        border  bg      text    indicator child_border
client.focused         \$accent \$accent \$fg     \$accent   \$accent
client.focused_inactive \$inactive \$inactive \$fg \$inactive \$inactive  
client.unfocused       \$bg     \$bg     \$fg     \$bg       \$bg
client.urgent          \$urgent \$urgent \$fg     \$urgent   \$urgent
EOF
            fi
          '';
          executable = true;
        };
      };

      home.stateVersion = "25.05";
    };
}
