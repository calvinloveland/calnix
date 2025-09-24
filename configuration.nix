{
  config,
  pkgs,
  lib,
  kickstart-nix-nvim,
  ...
}:
{
  imports = [
    ./homely-man.nix
    ./python-dev.nix
  ];

  # Home Manager configuration
  home-manager.backupFileExtension = "backup";


  # Enable parallel building for faster compilation
  nix.settings = {
    max-jobs = "auto"; # Use all available CPU cores
    cores = 0; # Use all available CPU cores for each job
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;

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

  environment.systemPackages = with pkgs; [
    # Fonts for proper terminal display
    dejavu_fonts # Includes DejaVu Sans Mono
    liberation_ttf # Liberation Mono - excellent terminal font
    font-awesome # For icons in status bars

    # Color scheme generation from wallpapers
    pywal
    imagemagick # Required for pywal color generation

    # Bluetooth packages
    bluez
    bluez-tools
    blueberry # Bluetooth manager GUI

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

    # nvim-pkg # kickstart neovim  # TODO make this actually work
    git # vc
    gh # github cli w/ copilot
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    rofi # launcher

    mako # notification system developed by swaywm maintainer
    alacritty # terminal emulator
    fish # good shell
    fortune-kind # good fortunes
    dwarf-fortress-packages.dwarf-fortress-full # fun
    fastfetch # gotta be able to show off
    firefox # browser

    zip # Archive tools
    xz
    unzip

    ripgrep # fast grep search

    cowsay # GNU utils
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    glow # markdown viewer
    btop # hardware monitor

    usbutils
    home-manager # manage homes

    swaybg # set background
    nixfmt-rfc-style # nix formatter
    google-chrome # Google has their hooks in me
    pavucontrol # controls volume

    wget # w getting stuff
    wluma # backlight control

    calibre # e-book management
  ];
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "Thinker";
  networking.networkmanager.enable = true;

  # enable sway window manager via Home Manager user config in homely-man.nix

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.fish.enable = true;
  programs.ssh.startAgent = true;

  programs.neovim = {
    enable = true;
  };

  # services.logind.lidSwitch = "suspend-then-hibernate"; # This does not do what I want it to
  services.thermald.enable = true;

  # Enable XDG Desktop Portals (required for Flatpak)
  xdg.portal = {
    enable = true;
    wlr.enable = true; # For Wayland/Sway compatibility
  };

  # Enable Flatpak service
  services.flatpak.enable = true;

  # Enable Bluetooth service
  services.blueman.enable = true;

  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Enable Bluetooth audio support
    wireplumber.enable = true;
  };
  # services.automatic-timezoned.enable = true; # Does nothing >:(
  # services.tzupdate.enable = true; # Also does nothing >:(
  # time.timeZone = "America/Denver"; # Remove this in hopes tzupdate works
  services.tzupdate = {
    enable = true;
  };
  systemd.timers."tzupdate.timer".timerConfig = {
    OnBootSec = "5min";
    OnUnitActiveSec = "1d";
  };
  # services.geoclue.enable = true; # not real, AI made this up
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

      #Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 70; # 50 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sway.enableGnomeKeyring = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { }; # Enable pam for swaylock
  security.rtkit.enable = true;
  systemd.sleep.extraConfig = ''
    	    HibernateDelaySec=60min
    	  '';

  users.users.calvin = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
    ];
    shell = pkgs.fish;
  };
  virtualisation.docker = {
    enable = true;
  };
  system.stateVersion = "25.05";
}
