#!/usr/bin/env bash

# Smart multi-host rebuild script for Calvin's NixOS configuration
# Automatically detects the environment and builds the appropriate configuration

detect_host() {
    # Check if running in WSL
    if grep -qi microsoft /proc/version 2>/dev/null || [ -n "${WSL_DISTRO_NAME}" ]; then
        echo "work-wsl"
        return
    fi
    
    # Check hostname
    hostname=$(hostname)
    case $hostname in
        Thinker|thinker)
            echo "thinker"
            return
            ;;
        work-wsl|work)
            echo "work-wsl"
            return
            ;;
    esac
    
    # Check for ThinkPad-specific hardware
    if [ -f /proc/acpi/ibm/version ] || lspci 2>/dev/null | grep -qi thinkpad; then
        echo "thinker"
        return
    fi
    
    # Default fallback
    echo "thinker"
}

# Allow manual override as first argument
if [ $# -gt 0 ]; then
    HOST="$1"
else
    HOST=$(detect_host)
    echo "Auto-detected host: $HOST"
fi

case $HOST in
  thinker)
    echo "🖥️  Rebuilding ThinkPad configuration..."
    sudo nixos-rebuild switch --flake .#thinker
    ;;
  work-wsl)
    echo "🖱️  Rebuilding WSL work configuration..."
    sudo nixos-rebuild switch --flake .#work-wsl
    ;;
  *)
    echo "❌ Unknown host: $HOST"
    echo ""
    echo "Usage: $0 [thinker|work-wsl]"
    echo "Available hosts:"
    echo "  thinker   - ThinkPad with gaming and desktop environment"
    echo "  work-wsl  - WSL work environment without gaming"
    echo ""
    echo "Auto-detection checks:"
    echo "  - WSL environment (/proc/version, WSL_DISTRO_NAME)"
    echo "  - Hostname (Thinker, work-wsl)"
    echo "  - ThinkPad hardware (/proc/acpi/ibm/version, lspci)"
    echo "  - Default: thinker"
    exit 1
    ;;
esac
