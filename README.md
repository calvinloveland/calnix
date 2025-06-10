# Calnix - Calvin's Multi-Host NixOS Configuration

A personal NixOS configuration supporting multiple hosts with modular architecture.

## Hosts

### 🖥️ Thinker (ThinkPad)
Personal laptop configuration featuring:
- **Window Manager**: Sway (Wayland compositor)
- **Gaming**: Steam, game development tools, creative software
- **Desktop Environment**: Full desktop experience with Bluetooth, audio, etc.
- **Power Management**: ThinkPad-optimized TLP settings

### 🖱️ Work-WSL
Work-focused WSL configuration featuring:
- **Development Tools**: VS Code, Docker, cloud tools
- **No Gaming**: Clean work environment without gaming packages
- **Minimal**: Only essential packages for productivity

## Quick Start

### For ThinkPad (Thinker)
```bash
git clone <this-repo> /etc/nixos
cd /etc/nixos
sudo nixos-generate-config --show-hardware-config > hosts/thinker/hardware-configuration.nix
./rebuild.sh thinker
```

### For WSL (Work)
```bash
git clone <this-repo> /etc/nixos
cd /etc/nixos
./rebuild.sh work-wsl
```

## Testing

Before deploying changes, run the comprehensive test suite:

```bash
# Run all tests
./tests/run_tests.sh

# Quick validation only
./tests/run_tests.sh --quick

# Code quality checks only
./tests/run_tests.sh --lint-only
```

### Available Tests

- **Configuration Validation**: Checks file structure, imports, and gaming separation
- **Rebuild Script Tests**: Unit tests for host detection logic
- **Nix Flake Validation**: Syntax and build checks
- **Code Quality**: Linting and dead code detection
- **Security**: File permissions and basic security checks

### Individual Test Commands

```bash
# Test rebuild script logic
./tests/test_rebuild.sh

# Validate configuration structure
./tests/validate_config.py

# Nix-specific tests
nix flake check --no-build
```

## Architecture

```
├── flake.nix              # Multi-host flake configuration
├── rebuild.sh             # Smart host-aware rebuild script
├── hosts/
│   ├── thinker/           # ThinkPad configuration
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── work-wsl/          # WSL work configuration
│       └── configuration.nix
├── modules/
│   ├── base.nix           # Shared base configuration
│   └── gaming.nix         # Gaming-specific packages
├── tests/                 # Testing infrastructure
│   ├── run_tests.sh       # Master test runner
│   ├── test_rebuild.sh    # Rebuild script unit tests
│   ├── validate_config.py # Configuration validation
│   └── flake.nix          # Test environment
├── homely-man.nix         # Home Manager configuration
└── python-dev.nix         # Python development environment
```

## Building Specific Hosts

The rebuild script automatically detects your environment:

```bash
# Auto-detect and build appropriate configuration
./rebuild.sh

# Manual override
./rebuild.sh thinker      # Force ThinkPad build
./rebuild.sh work-wsl     # Force WSL build

# Or use nixos-rebuild directly
sudo nixos-rebuild switch --flake .#thinker
sudo nixos-rebuild switch --flake .#work-wsl
```

### Auto-Detection Logic

The script detects your environment using:
1. **WSL Detection** - Checks for Microsoft in `/proc/version` or `WSL_DISTRO_NAME`
2. **Hostname** - Recognizes "Thinker" or "work-wsl"
3. **Hardware** - Looks for ThinkPad-specific indicators
4. **Fallback** - Defaults to "thinker"

## Key Features

### Shared (Both Hosts)
- **Development**: Git, GitHub CLI, Docker, Python environment
- **Tools**: Fish shell, Neovim, essential CLI utilities
- **Base System**: Common NixOS configuration

### ThinkPad Only
- **Gaming**: Steam, Blender, Krita, Aseprite, Dwarf Fortress
- **Desktop**: Sway, Bluetooth, audio (PipeWire), power management
- **Creative**: Image editing, 3D modeling, digital art tools

### WSL Only
- **Work Tools**: AWS CLI, kubectl, PostgreSQL, cloud development
- **Minimal**: No desktop environment or gaming packages
- **Productivity**: Database tools, document processing

## Development Workflow

1. **Make Changes** to configuration files
2. **Run Tests** to validate changes:
   ```bash
   ./tests/run_tests.sh --quick
   ```
3. **Deploy** if tests pass:
   ```bash
   ./rebuild.sh
   ```

## Customization

### Adding Packages
- **All hosts**: Edit `modules/base.nix`
- **Gaming only**: Edit `modules/gaming.nix`
- **ThinkPad only**: Edit `hosts/thinker/configuration.nix`
- **WSL only**: Edit `hosts/work-wsl/configuration.nix`

### Creating New Hosts
1. Create `hosts/new-host/configuration.nix`
2. Add to `flake.nix` nixosConfigurations
3. Update `rebuild.sh` with new host option
4. Add tests for new configuration

## Troubleshooting

### ThinkPad-Specific
- Pywal colors: Ensure wallpaper at `~/Pictures/background.jpg`
- Brightness controls: User must be in `video` group
- Bluetooth: Use `Mod4+b` for GUI or `Mod4+Shift+b` for terminal

### WSL-Specific  
- Enable WSL systemd: `systemctl --user enable nixos-wsl.service`
- Docker: Use rootless mode (automatically configured)

### Testing Issues
- **Nix not found**: Install Nix or use `--quick` flag
- **Permission errors**: Ensure scripts are executable: `chmod +x tests/*.sh`
- **Python errors**: Ensure Python 3 is available

## Legacy Support

The flake maintains backward compatibility with:
- `nixos` and `Thinker` configurations (both point to thinker host)

