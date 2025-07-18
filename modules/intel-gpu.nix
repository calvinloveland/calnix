{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Enable graphics with Intel drivers (using the new hardware.graphics namespace)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit games like Steam
    extraPackages = with pkgs; [
      intel-media-driver         # LIBVA_DRIVER_NAME=iHD
      intel-compute-runtime      # Intel OpenCL implementation
      vpl-gpu-rt                 # Intel Video Processing Library runtime for hardware accelerated video encoding/decoding
    ];
    # For 32-bit applications (like Steam games)
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-vaapi-driver
    ];
  };

  # Essential Intel GPU tools
  environment.systemPackages = with pkgs; [
    intel-gpu-tools  # Intel-specific GPU tools
  ];
}