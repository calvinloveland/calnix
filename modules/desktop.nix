{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Desktop environment configuration shared by all desktop hosts
  # (thinker and 1337book) - excludes work-wsl
  
  # Home Manager configuration
  home-manager.backupFileExtension = "backup";

  # Standard boot configuration for desktop hosts
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;

  # Network configuration
  networking.networkmanager.enable = true;

  # Desktop packages common to all desktop hosts
  environment.systemPackages = with pkgs; [
    # Color scheme generation from wallpapers
    pywal
    imagemagick # Required for pywal color generation

    # Bluetooth packages
    bluez
    bluez-tools
    blueberry # Bluetooth manager GUI

    # Wayland/Sway specific
    grim # screenshot functionality
    slurp # screenshot functionality
    rofi # launcher
    mako # notification system developed by swaywm maintainer
    swaybg # set background
    wluma # backlight control
    waybar # status bar with CPU and power monitoring

    # Power monitoring tools for waybar
    powertop # Advanced power usage statistics
    acpi # Battery information
    lm_sensors # Hardware monitoring (CPU temp, fan speeds)

    # Desktop applications
    alacritty # terminal emulator
    firefox # browser
    google-chrome # Google has their hooks in me
    pavucontrol # controls volume
    fortune-kind # good fortunes
    libreoffice # Office suite for documents, spreadsheets, presentations
    
    # Video editing and media
    vlc # Video player and basic editing
    ffmpeg # CLI video processing and stitching tool
    
    # System management
    bashmount # Interactive mount manager for USB drives
  ];

  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Common desktop services
  services.thermald.enable = true;
  services.blueman.enable = true;
  services.udisks2.enable = true;

  # Timezone management
  services.tzupdate = {
    enable = true;
  };

  # Enable location services for timezone
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  # Audio configuration
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  hardware.pulseaudio.enable = false; # Use PipeWire instead

  # Enable Sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      brightnessctl
      grim
      slurp
      rofi
      waybar # Add waybar to Sway extras
    ];
  };

  # Enable XDG desktop portal for screen sharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Touchpad configuration
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;            # Enable tap to click
      clickMethod = "clickfinger"; # Use 1/2/3 finger clicks for left/right/middle button
      tappingDragLock = true;    # Enable double tap to drag
      naturalScrolling = true;   # Use natural scrolling direction
      disableWhileTyping = true; # Disable touchpad while typing
      accelSpeed = 0.2;          # Adjust pointer acceleration
    };
  };

  # TLP power management - base settings
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT and battery thresholds will be set per host
    };
  };
}