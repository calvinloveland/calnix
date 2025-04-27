{ config, pkgs, lib,kickstart-nix-nvim, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./homely-man.nix
  ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nvim-pkg # kickstart neovim
    git # vc
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
  ];
  networking.hostName = "Thinker";
  networking.networkmanager.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "auto";
  boot.loader.efi.canTouchEfiVariables = true;
  security.polkit.enable = true;
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

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 50; # 50 and below it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    package = pkgs.swayfx; 
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.fish.enable = true;

  programs.neovim = {
    enable = true;
  };

  users.users.calvin = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.fish;
  };  

  system.stateVersion = "25.05";
}
