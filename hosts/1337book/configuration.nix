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

  hardware.enableAllFirmware = true;

  # Hostname
  networking.hostName = "1337book";

  # HP Elitebook-specific TLP power management settings
  services.tlp.settings = {
    CPU_MAX_PERF_ON_BAT = 30; # Slightly higher than ThinkPad for HP's power profile
    # Battery health optimization (HP Elitebook specific)
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 85;
  };

  # HP-specific optimizations
  # Enable fwupd for firmware updates (HP has good Linux support)
  services.fwupd.enable = true;
}
