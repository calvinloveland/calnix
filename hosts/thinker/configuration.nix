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
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../homely-man.nix
    ../../python-dev.nix
  ];

  # Hostname
  networking.hostName = "Thinker";

  # ThinkPad-specific TLP power management settings
  services.tlp.settings = {
    CPU_MAX_PERF_ON_BAT = 20;
    # Battery health optimization
    START_CHARGE_THRESH_BAT0 = 70;
    STOP_CHARGE_THRESH_BAT0 = 80;
  };

  # ThinkPad-specific auto-mounting configuration
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
}
