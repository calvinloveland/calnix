{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core Python tools
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.setuptools
    python3Packages.wheel
    poetry # Use top-level poetry package
    uv # Fast Python package installer and resolver

    # Development tools
    python3Packages.black # code formatter
    python3Packages.flake8 # linter
    python3Packages.pylsp-mypy # type checker
    python3Packages.python-lsp-server # language server for editors
    python3Packages.debugpy # debugger
    ruff # fast Python linter and formatter

    # Testing & interactive development
    python3Packages.pytest # testing framework
    python3Packages.ipython # interactive Python shell
    python3Packages.jupyter # notebook environment

    # Popular libraries
    python3Packages.requests # commonly used HTTP library
    python3Packages.numpy # scientific computing
    python3Packages.pandas # data analysis
    python3Packages.matplotlib # plotting

    # SDL libraries for pygame
    SDL2 # Core SDL2 library
    SDL2_image # Image loading support (PNG, JPG, etc.)
    SDL2_mixer # Audio mixing support
    SDL2_ttf # TrueType font support
    SDL2_net # Networking support
    SDL2_gfx # Additional graphics primitives

    # Additional multimedia libraries that pygame might use
    libpng # PNG image support
    libjpeg # JPEG image support
    freetype # Font rendering
    portaudio # Cross-platform audio I/O

    # pygame package itself
    python3Packages.pygame # pygame for Python
  ];
}
