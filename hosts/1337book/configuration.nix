{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/gaming.nix
    ../../homely-man.nix
    ../../python-dev.nix
  ];

  # Home Manager configuration
  home-manager.backupFileExtension = "backup";

  # HP Elitebook-specific boot configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "1337book";
  networking.networkmanager.enable = true;

  # HP Elitebook-specific packages
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

  # HP Elitebook power management
  services.thermald.enable = true;
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
      CPU_MAX_PERF_ON_BAT = 30; # Slightly higher than ThinkPad for HP's power profile

      # Battery health optimization (HP Elitebook specific)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 85;
    };
  };

  # Timezone management
  services.tzupdate = {
    enable = true;
  };
  systemd.timers."tzupdate.timer".timerConfig = {
    OnBootSec = "5min";
    OnUnitActiveSec = "1d";
  };

  # Audio configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth service
  services.blueman.enable = true;

  # Security and authentication
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sway.enableGnomeKeyring = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  security.rtkit.enable = true;

  # Sleep configuration
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=60min
  '';

  # Add user to additional groups for HP Elitebook functionality
  users.users.calvin.extraGroups = [
    "wheel"
    "networkmanager" 
    "video"
    "docker"
  ];

  # Enable auto-mounting service for removable devices
  services.udisks2.enable = true;

  # HP-specific optimizations
  # Enable fwupd for firmware updates (HP has good Linux support)
  services.fwupd.enable = true;
}
