{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core Python tools
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.setuptools
    python3Packages.wheel
    poetry  # Use top-level poetry package

    # Development tools
    python3Packages.black  # code formatter
    python3Packages.flake8  # linter
    python3Packages.pylsp-mypy  # type checker
    python3Packages.python-lsp-server  # language server for editors
    python3Packages.debugpy  # debugger
    ruff  # fast Python linter and formatter

    # Testing & interactive development
    python3Packages.pytest  # testing framework
    python3Packages.ipython  # interactive Python shell
    python3Packages.jupyter  # notebook environment

    # Popular libraries
    python3Packages.requests  # commonly used HTTP library
    python3Packages.numpy  # scientific computing
    python3Packages.pandas  # data analysis
    python3Packages.matplotlib  # plotting
  ];
}