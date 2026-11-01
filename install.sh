#!/usr/bin/env bash
# ==============================================================================
# Installer Script for Termux Distro Manager (tdistro)
# Repository: https://github.com/0xposa/termux-distro
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/termux-distro.sh"

echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  TERMUX DISTRO MANAGER - SYSTEM INSTALLER                   │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""

echo "[1/4] Checking core package dependencies..."
pkg update -y >/dev/null 2>&1 || true
pkg install -y proot-distro curl jq tar xz-utils git >/dev/null 2>&1

echo "[2/4] Verifying project files..."
if [[ ! -f "$MAIN_SCRIPT" ]]; then
    TARGET_DIR="$HOME/projects/termux-distro"
    if [[ ! -d "$TARGET_DIR" ]]; then
        echo "[*] Cloning repository to $TARGET_DIR..."
        git clone https://github.com/0xposa/termux-distro.git "$TARGET_DIR"
    fi
    MAIN_SCRIPT="$TARGET_DIR/termux-distro.sh"
fi

echo "[3/4] Setting executable permissions..."
chmod +x "$MAIN_SCRIPT"

echo "[4/4] Creating global symlinks in \$PREFIX/bin..."
ln -sf "$MAIN_SCRIPT" "$PREFIX/bin/tdistro"
ln -sf "$MAIN_SCRIPT" "$PREFIX/bin/termux-distro"
rm -f "$HOME/.config/tdistro/config.env"

echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  [OK] INSTALLATION COMPLETE                                 │"
echo "├─────────────────────────────────────────────────────────────┤"
echo "│  Global binary commands installed:                          │"
echo "│                                                             │"
echo "│    * tdistro                                                │"
echo "│    * termux-distro                                          │"
echo "│                                                             │"
echo "│  Run 'tdistro' from any directory to open the dashboard.    │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
