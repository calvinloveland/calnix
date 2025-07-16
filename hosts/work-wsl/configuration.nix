{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/base.nix
    ../../python-dev.nix
  ];

  # WSL-specific configuration
  wsl = {
    enable = true;
    defaultUser = "calvin";
    startMenuLaunchers = true;
  };

  # Hostname for work environment
  networking.hostName = "work-wsl";

  # Work-focused packages (no gaming)
  environment.systemPackages = with pkgs; [
    # Development tools
    vscode

    # Work-specific browsers
    firefox

    # Additional development utilities
    curl
    jq # JSON processor

    # Text processing
    pandoc # Document converter
    libreoffice # Office suite for documents, spreadsheets, presentations

    # Database tools
    postgresql # For database work
    sqlite # Lightweight database

    # Cloud tools
    awscli2 # AWS CLI
    kubectl # Kubernetes CLI
    docker-compose # Container orchestration
  ];

  # WSL-specific user groups (shell is inherited from base.nix)
  users.users.calvin.extraGroups = [
    "wheel"
    "docker"
  ];

  # Minimal networking for WSL
  networking.useDHCP = false;
  networking.interfaces = { };

  system.stateVersion = "25.05";
}
