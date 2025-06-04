# Calnix - Calvin's NixOS Configuration

A personal NixOS configuration featuring Sway window manager, Home Manager, and a modern development environment.

## Overview

This is a flake-based NixOS configuration that provides:

- **Window Manager**: Sway (Wayland compositor)
- **Terminal**: Kitty with Fira Code font
- **Shell**: Fish shell
- **Editor**: Neovim and VS Code
- **Browser**: Google Chrome
- **Color Scheme**: Dynamic theming with pywal
- **Package Management**: Nix flakes with Home Manager

## Quick Start

1. **Clone and initialize**:
   ```bash
   git clone <this-repo> /etc/nixos
   cd /etc/nixos
   ```

2. **Generate hardware configuration**:
   ```bash
   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```

3. **Build and switch**:
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

4. **Set up wallpaper** (optional):
   ```bash
   mkdir -p ~/Pictures
   # Place a wallpaper image at ~/Pictures/background.jpg
   ```

## Key Features

### Sway Window Manager
- Custom keybindings for brightness, volume, and Bluetooth
- Dynamic color theming with pywal integration
- Workspace-specific application launching
- Window gaps and borders configured

### Development Environment
- VS Code with extensions
- Neovim with vim/vi aliases
- Git configured with user details
- Kitty terminal with ligature support

### Color Theming
- **Mod4+w**: Generate colors from current wallpaper
- **Mod4+Shift+w**: Choose wallpaper with file picker
- Automatic color application to Sway, Kitty, and other applications

### Default Applications
- All web content opens in Google Chrome
- Terminal applications use Kitty
- Text editing with Neovim

## File Structure

- `flake.nix` - Main flake configuration and inputs
- `configuration.nix` - System-wide NixOS configuration
- `hardware-configuration.nix` - Hardware-specific settings
- `homely-man.nix` - Home Manager user configuration
- `python-dev.nix` - Python development environment
- `rebuild.sh` - Convenience script for rebuilding

## Customization

### Adding Packages
Edit the `home.packages` list in `homely-man.nix`:

```nix
home.packages = [
  # Add your packages here
  pkgs.firefox
  pkgs.discord
];
```

### Modifying Sway Config
The Sway configuration is in `homely-man.nix` under `wayland.windowManager.sway.config`.

### Changing Keybindings
Keybindings are defined in the `keybindings` section of the Sway configuration.

## Rebuilding

Use the provided script:
```bash
./rebuild.sh
```

Or manually:
```bash
sudo nixos-rebuild switch --flake .
```

## Troubleshooting

### Pywal Colors Not Working
Ensure you have a wallpaper at `~/Pictures/background.jpg` and run:
```bash
wal -i ~/Pictures/background.jpg
swaymsg reload
```

### Brightness Controls Not Working
Make sure your user is in the appropriate groups for hardware access.

