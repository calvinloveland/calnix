{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable parallel building for faster compilation
  nix.settings = {
    max-jobs = "auto"; # Use all available CPU cores
    cores = 0; # Use all available CPU cores for each job
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;

  # Common packages for all hosts
  environment.systemPackages = with pkgs; [
    # Fonts for proper terminal display
    dejavu_fonts # Includes DejaVu Sans Mono
    liberation_ttf # Liberation Mono - excellent terminal font
    font-awesome # For icons in status bars

    # Essential tools
    git # version control
    gh # github cli w/ copilot
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    
    # Archive tools
    zip
    xz
    unzip

    # Search and file tools
    ripgrep # fast grep search
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # System monitoring
    btop # hardware monitor
    fastfetch # system info

    # Network and storage tools
    cifs-utils # SMB/CIFS mounting for NAS access
    rsync # efficient file synchronization
    exfat # Support for exFAT filesystems (cameras, etc.)

    # Utilities
    cowsay
    glow # markdown viewer
    wget
    nixfmt-rfc-style # nix formatter
    home-manager # manage homes
  ];

  # Common programs
  programs.fish.enable = true;
  programs.ssh.startAgent = true;
  programs.neovim.enable = true;

  # User configuration
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

  # Docker (common for development)
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  system.stateVersion = "25.05";
}