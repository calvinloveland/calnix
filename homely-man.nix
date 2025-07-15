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
      # Allow unfree packages for this user
      nixpkgs.config.allowUnfree = true;

      # Set Home Manager state version
      home.stateVersion = "23.11";

      home.packages = [
        pkgs.atool
        pkgs.httpie
        pkgs.brightnessctl
        # Browsers
        pkgs.google-chrome
        # Fonts
        pkgs.fira-code # Fira Code font with ligatures
        pkgs.font-awesome # Required for waybar icons
        pkgs.nerd-fonts.fira-code # Nerd Font version of Fira Code
        pkgs.nerd-fonts.dejavu-sans-mono # Nerd Font version of DejaVu Sans Mono
        # Waybar dependencies
        pkgs.playerctl # For media controls
        pkgs.ncdu # Disk usage analyzer
        pkgs.curl # For weather info
        # Bluetooth utilities
        pkgs.bluetuith # Terminal-based Bluetooth manager
        pkgs.bluez-alsa # ALSA plugin for Bluetooth audio
        # Development tools
        pkgs.vscode # Visual Studio Code editor
        pkgs.kitty # Kitty terminal emulator
      ];

      # Set default applications
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "google-chrome.desktop";
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
          "x-scheme-handler/unknown" = "google-chrome.desktop";
        };
      };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          # Import colorscheme from 'wal' asynchronously
          if test -f ~/.cache/wal/sequences
            cat ~/.cache/wal/sequences
          end

          # For TTY support, check if we're in a Linux console and apply colors
          if test "$TERM" = "linux"
            if test -f ~/.cache/wal/colors-tty.sh
              # Convert the bash script to fish-compatible commands
              grep "printf" ~/.cache/wal/colors-tty.sh | sed 's/printf/printf/' | source
            end
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

      # Configure Kitty terminal with proper fonts and pywal colors
      programs.kitty = {
        enable = true;
        font = {
          name = "Fira Code";
          size = 12;
        };
        settings = {
          # Window settings
          window_padding_width = 10;
          background_opacity = "0.95";

          # Cursor settings
          cursor_blink_interval = 0;

          # Tab settings
          tab_bar_edge = "bottom";
          tab_bar_style = "powerline";

          # Performance
          repaint_delay = 10;
          input_delay = 3;
          sync_to_monitor = "yes";

          # Include pywal colors
          include = "~/.cache/wal/colors-kitty.conf";
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        config = rec {
          modifier = "Mod4";
          terminal = "kitty";

          # Touchpad configuration
          input = {
            "type:touchpad" = {
              tap = "enabled";
              dwt = "enabled";  # Disable while typing
              natural_scroll = "enabled";
              middle_emulation = "enabled";
              tap_button_map = "lrm";  # Left, right, middle button
              drag = "enabled";
              drag_lock = "enabled";  # Enable drag lock (double tap to drag)
              accel_profile = "adaptive";
              pointer_accel = "0.2";  # Pointer acceleration
            };
          };

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
            inner = 2;
            outer = 1;
          };

          # Assign applications to specific workspaces
          assigns = {
            "1" = [ { class = "Code"; } ]; # VS Code uses class "Code"
            "2" = [
              { class = "Google-chrome"; }
              { class = "Chromium"; }
              { class = "chrome"; }
            ];
            "3" = [ { app_id = "kitty"; } ]; # Kitty uses app_id, not class
            "4" = [
              { class = "Steam"; }
              { class = "steam"; }
            ];
          };

          # Let waybar be managed by systemd/Home Manager
          bars = [];

          # Key bindings
          keybindings = lib.mkOptionDefault {
            # Audio controls (using WirePlumber)
            "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 5%-";
            "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_SINK@ toggle";

            # Brightness controls (using brightnessctl)
            "XF86MonBrightnessUp" = "exec brightnessctl set +10%";
            "XF86MonBrightnessDown" = "exec brightnessctl set 1";

            # Bluetooth controls
            "${modifier}+b" = "exec blueberry"; # Open Bluetooth manager GUI
            "${modifier}+Shift+b" = "exec ${terminal} -e bluetuith"; # Open terminal Bluetooth manager

            # Pywal controls - generate colors from wallpaper and update Sway
            "${modifier}+w" = "exec ~/.config/sway/update-colors.sh";

            # Alternative: choose wallpaper with file picker
            "${modifier}+Shift+w" = "exec ~/.config/sway/choose-wallpaper.sh";
          };
          startup = [
            { command = "wal -R"; } # Restore last pywal color scheme
            { command = "~/.config/sway/apply-colors.sh"; } # Apply colors to Sway
            { command = "swaybg -o '*' -i ~/Pictures/background.jpg"; }

            # Auto-start applications - they will be assigned to workspaces automatically
            { command = "sleep 2 && code"; }
            { command = "sleep 3 && google-chrome-stable"; }
            { command = "sleep 4 && kitty"; }
            { command = "sleep 5 && steam"; }
          ];
        };

        # Include pywal colors dynamically
        extraConfig = ''
          # Include pywal color scheme if available
          include ~/.cache/wal/colors-sway
        '';
      };

      # Waybar configuration with CPU and power monitoring
      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "sway-session.target"; # Ensure waybar starts with Sway
        };
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            
            modules-left = ["sway/workspaces" "sway/mode" "custom/media"];
            modules-center = ["sway/window"];
            modules-right = [
              "cpu" 
              "memory"
              "temperature"
              "disk"
              "battery"
              "network#wifi"
              "network#ethernet"
              "network#disconnected"
              "pulseaudio" 
              "backlight"
              "custom/weather"
              "clock"
              "tray"
            ];

            # CPU usage with detailed monitoring
            "cpu" = {
              format = " CPU: {usage}%";
              tooltip-format = "CPU Usage: {usage}%\nLoad: {load}";
              interval = 2;
              on-click = "kitty -e htop";
            };

            # Memory usage
            "memory" = {
              format = " RAM: {}%";
              tooltip-format = "Memory: {used:0.1f}G / {total:0.1f}G ({percentage}%)\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
              interval = 2;
              on-click = "kitty -e htop";
            };

            # Disk space
            "disk" = {
              format = " Disk: {percentage_used}%";
              path = "/";
              interval = 30;
              tooltip-format = "Disk usage: {used} used out of {total} on {path} ({percentage_used}%)";
              on-click = "kitty -e ncdu /";
            };

            # CPU temperature
            "temperature" = {
              critical-threshold = 80;
              format-critical = " Temp: {temperatureC}°C!";
              format = " Temp: {temperatureC}°C";
              tooltip-format = "CPU Temperature: {temperatureC}°C";
              interval = 5;
            };

            # Battery with power consumption - optimized for HP Elitebook
            "battery" = {
              bat = "BAT0";
              adapter = "AC";
              interval = 10;
              states = {
                "warning" = 30;
                "critical" = 15;
              };
              # Using Unicode symbols that don't require special fonts
              format = "{capacity}% {icon}";
              format-charging = "⚡ {capacity}%";
              format-plugged = "🔌 {capacity}%";
              # Unicode battery icons as fallback
              format-icons = ["▁" "▂" "▃" "▄" "▅"];
              tooltip = true;
            };

            # Audio
            "pulseaudio" = {
              format = "{icon} Vol: {volume}%";
              format-bluetooth = " BT: {volume}%";
              format-muted = " Muted";
              format-source = " Mic: {volume}%";
              format-source-muted = " Mic Off";
              format-icons = {
                "headphone" = "";
                "hands-free" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = ["" "" ""];
              };
              scroll-step = 1;
              on-click = "pavucontrol";
            };

            # Backlight
            "backlight" = {
              format = "{icon} Light: {percent}%";
              format-icons = ["" ""];
              on-scroll-up = "brightnessctl set +5%";
              on-scroll-down = "brightnessctl set 5%-";
            };

            # Network - split into multiple modules for better control
            "network#wifi" = {
              interface = "wlp*";  # Updated to match your wlp0s20f3 interface
              format-wifi = " WiFi: {essid} ({signalStrength}%)";
              format-ethernet = "";
              format-disconnected = "";
              tooltip-format-wifi = "WiFi: {essid} ({signalStrength}%)\nIP: {ipaddr}/{cidr}\nFrequency: {frequency}GHz\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
              interval = 5;
              on-click = "kitty -e nmtui";
            };

            "network#ethernet" = {
              interface = "eth*";
              format-wifi = "";
              format-ethernet = " Net: {ipaddr}/{cidr}";
              format-disconnected = "";
              tooltip-format-ethernet = "Ethernet: {ifname}\nIP: {ipaddr}/{cidr}\nUp: {bandwidthUpBits} Down: {bandwidthDownBits}";
              interval = 5;
              on-click = "kitty -e nmtui";
            };

            "network#disconnected" = {
              interface = "*";
              format-wifi = "";
              format-ethernet = "";
              format-disconnected = "⚠ Network Down";
              interval = 5;
              tooltip-format-disconnected = "No network connection";
              on-click = "kitty -e nmtui";
            };

            # Weather
            "custom/weather" = {
              exec = "${pkgs.bash}/bin/bash ~/.config/waybar/weather.sh";
              interval = 600; # Update every 10 minutes
              return-type = "json";
              format = "{icon} {}";
              format-icons = {
                "Clear" = "☀️";
                "Clouds" = "☁️";
                "Rain" = "🌧️";
                "Snow" = "❄️";
                "default" = "🌈";
              };
              on-click = "${pkgs.xdg-utils}/bin/xdg-open https://wttr.in";
            };

            # Media player
            "custom/media" = {
              format = "{icon} Media: {}";
              return-type = "json";
              max-length = 40;
              format-icons = {
                "spotify" = "";
                "default" = "🎜";
              };
              escape = true;
              exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{artist}} - {{album}} - {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
              on-click = "playerctl play-pause";
            };

            # Clock
            "clock" = {
              format = " {:%H:%M}";
              format-alt = " {:%Y-%m-%d}";
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            };

            # System tray
            "tray" = {
              icon-size = 21;
              spacing = 10;
            };
          };
        };

        # Simple styling
        style = ''
          * {
            font-family: "DejaVu Sans Mono", FontAwesome;
            font-size: 13px;
          }

          window#waybar {
            background-color: rgba(43, 48, 59, 0.9);
            color: #ffffff;
          }

          #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ffffff;
            border-bottom: 3px solid transparent;
          }

          #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
          }

          #workspaces button.focused {
            background-color: #64727D;
            border-bottom: 3px solid #ffffff;
          }

          #workspaces button.urgent {
            background-color: #eb4d4b;
          }

          #cpu {
            background-color: #2ecc71;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #memory {
            background-color: #9b59b6;
            color: #ffffff;
            padding: 0 8px;
            margin: 0 2px;
          }

          #disk {
            background-color: #546E7A;
            color: #ffffff;
            padding: 0 8px;
            margin: 0 2px;
          }

          #temperature {
            background-color: #f39c12;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #temperature.critical {
            background-color: #eb4d4b;
          }

          #battery {
            background-color: #ffffff;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #battery.charging {
            background-color: #26A65B;
            color: #ffffff;
          }

          #battery.warning:not(.charging) {
            background-color: #ffbe61;
            color: black;
          }

          #battery.critical:not(.charging) {
            background-color: #f53c3c;
            color: white;
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          #network, #network\\.wifi, #network\\.ethernet, #network\\.disconnected {
            background-color: #2980b9;
            color: #ffffff;
            padding: 0 8px;
            margin: 0 2px;
          }

          #network\\.disconnected {
            background-color: #f53c3c;
          }

          #pulseaudio {
            background-color: #f1c40f;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #pulseaudio.muted {
            background-color: #90b1b1;
            color: #2a5c45;
          }

          #backlight {
            background-color: #90b1b1;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #custom-weather {
            background-color: #7DAEA3;
            color: #000000;
            padding: 0 8px;
            margin: 0 2px;
          }

          #clock {
            background-color: #64727D;
            padding: 0 8px;
            margin: 0 2px;
          }

          #custom-media {
            background-color: #66cc99;
            color: #2a5c45;
            padding: 0 8px;
            margin: 0 4px;
            min-width: 100px;
          }

          #custom-media.playing {
            background-color: #2980b9;
            color: #ffffff;
          }

          #custom-media.paused {
            background-color: #90b1b1;
            color: #2a5c45;
          }

          #tray {
            padding: 0 8px;
            margin: 0 2px;
          }

          @keyframes blink {
            to {
              background-color: #ffffff;
              color: #000000;
            }
          }
        '';
      };

      # Create scripts for color management and utilities
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
# Pywal color scheme for Sway
# Colors (colorscheme: $wallpaper)
set \$background $color0
set \$foreground $color15
set \$cursor $cursor

set \$color0 $color0
set \$color1 $color1
set \$color2 $color2
set \$color3 $color3
set \$color4 $color4
set \$color5 $color5
set \$color6 $color6
set \$color7 $color7
set \$color8 $color8
set \$color9 $color9
set \$color10 $color10
set \$color11 $color11
set \$color12 $color12
set \$color13 $color13
set \$color14 $color14
set \$color15 $color15

# Window decoration colors
# class                 border     backgr.    text       indicator  child_border
client.focused          \$color4   \$color4   \$color0   \$color4   \$color4
client.focused_inactive \$color8   \$color8   \$color7   \$color8   \$color8
client.unfocused        \$color0   \$color0   \$color7   \$color0   \$color0
client.urgent           \$color1   \$color1   \$color15  \$color1   \$color1
client.placeholder      \$color8   \$color8   \$color7   \$color8   \$color8

client.background       \$background
EOF
              
              # Create waybar colors configuration
              cat > ~/.cache/wal/waybar-colors.css << EOF
/* Pywal colors for waybar */
@define-color background $color0;
@define-color foreground $color15;
@define-color color1 $color1;
@define-color color2 $color2;
@define-color color3 $color3;
@define-color color4 $color4;
@define-color color5 $color5;
@define-color color6 $color6;
EOF
            fi
          '';
          executable = true;
        };

        ".config/waybar/weather.sh" = {
          text = ''
            #!/bin/bash
            # Weather script for waybar
            
            # Fetch weather information from wttr.in
            WEATHER_INFO=$(curl -s "https://wttr.in/?format=%c|%t|%C")
            
            # Parse the output (format: icon|temperature|condition)
            if [[ $? -eq 0 ]]; then
              IFS='|' read -r ICON TEMP CONDITION <<< "$WEATHER_INFO"
              # Format as JSON for waybar's custom module
              echo "{\"text\": \"$TEMP\", \"alt\": \"$CONDITION\", \"tooltip\": \"Condition: $CONDITION\nTemperature: $TEMP\"}"
            else
              # If curl fails, show error message
              echo "{\"text\": \"Weather Unavailable\", \"alt\": \"Error\", \"tooltip\": \"Weather service is currently unavailable\"}"
            fi
          '';
          executable = true;
        };
      };
    };
}
