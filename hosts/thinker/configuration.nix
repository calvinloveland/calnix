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

  # ThinkPad-specific boot configuration
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "Thinker";
  networking.networkmanager.enable = true;

  # ThinkPad-specific packages
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

  # ThinkPad power management
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
      CPU_MAX_PERF_ON_BAT = 20;

      # Battery health optimization
      START_CHARGE_THRESH_BAT0 = 70;
      STOP_CHARGE_THRESH_BAT0 = 80;
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

  # Add user to additional groups for ThinkPad functionality
  users.users.calvin.extraGroups = [
    "wheel"
    "networkmanager" 
    "video"
    "docker"
  ];

  # Auto-mounting configuration for ThinkPad only
  fileSystems."/mnt/insta360" = {
    device = "/dev/disk/by-uuid/4A21-0000";
    fsType = "exfat";
    options = [ 
      "noauto" # Don't mount at boot
      "user" # Allow regular users to mount
      "uid=calvin" # Set owner to calvin
      "gid=users" # Set group to users
      "umask=0022" # Set permissions
    ];
  };

  fileSystems."/mnt/nas" = {
    device = "//192.168.0.179/best-shared-folder";
    fsType = "cifs";
    options = [ 
      "noauto" # Don't mount at boot
      "user" # Allow regular users to mount
      "credentials=/home/calvin/.nas-credentials"
      "uid=calvin"
      "gid=users"
      "file_mode=0664"
      "dir_mode=0775"
    ];
  };

  # Enable auto-mounting service for removable devices
  services.udisks2.enable = true;
}