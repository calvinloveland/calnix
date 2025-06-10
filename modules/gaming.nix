{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Gaming-related packages
  environment.systemPackages = with pkgs; [
    # Game Development
    # Godot installed via Flatpak to avoid patchelf issues
    flatpak # Package manager for sandboxed applications
    blender # 3D modeling, animation, and asset creation
    krita # Digital painting and 2D art creation
    audacity # Audio editing for game sounds
    gimp # Image editing and texture creation
    aseprite # Pixel art editor (great for 2D games)
    inkscape # Vector graphics editor for UI and icons
    darktable # RAW photo processing for textures

    # Games
    dwarf-fortress-packages.dwarf-fortress-full # fun
  ];

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Enable XDG Desktop Portals (required for Flatpak)
  xdg.portal = {
    enable = true;
    wlr.enable = true; # For Wayland/Sway compatibility
    # Fix for portal configuration warning
    config.common.default = "*";
  };

  # Enable Flatpak service
  services.flatpak.enable = true;

  # Add user to docker group for game development
  users.users.calvin.extraGroups = [ "docker" ];
}