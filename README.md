# Termux Distro Manager (`tdistro`)

> **Minimalist, Clean, and Multi-language Linux Container Manager for Android Termux.**  
> Effortlessly deploy Debian, Ubuntu, Kali Linux, Arch Linux, Alpine, Fedora, and custom OCI distributions without root access.

---

```
  ┌─────────────────────────────────────────────────────────────┐
  │  TERMUX-DISTRO // Linux Container Management Utility        │
  │  Multi-Language: English • Bahasa Indonesia • 中文 (Mandarin)│
  └─────────────────────────────────────────────────────────────┘
```

## Features

- **Clean Minimalist CLI/TUI**: High-contrast, zero-emoji, clean terminal interface built with precise box-drawing characters and status tags (`[OK]`, `[INFO]`, `[WARN]`, `[ERROR]`).
- **Trilingual Support**:
  - English (`en`)
  - Bahasa Indonesia (`id`)
  - Simplified Chinese / 中文 (`zh`)
  - *First-time launch automatically prompts for language selection in English.*
- **Comprehensive Distro Catalog**:
  - `[DEB]` Debian 12 (Bookworm) - High stability, minimal overhead
  - `[UBU]` Ubuntu 24.04 LTS (Noble) - Beginner-friendly, modern packages
  - `[KALI]` Kali Linux (Rolling) - Penetration testing & cyber security research
  - `[ARCH]` Arch Linux - Bleeding-edge rolling release with Pacman
  - `[ALP]` Alpine Linux (v3.21) - Ultra-lightweight (~5MB) musl/busybox
  - `[FED]` Fedora Linux 41 - Upstream modern Red Hat ecosystem
  - `[VOID]` Void Linux (glibc) - Independent systemd-free distribution
  - `[SUSE]` openSUSE Tumbleweed - Enterprise-grade rolling release
  - `[ROCKY]` Rocky Linux 9 - 1:1 RHEL binary compatible server
  - `[ALMA]` AlmaLinux 9 - Community enterprise RHEL alternative
  - `[MANJ]` Manjaro Linux (Base) - User-friendly Arch derivative
  - `[NIX]` NixOS - Pure functional & declarative package management
  - `[OCI]` Custom image / Docker Hub search
- **Automated System Booster**: Fixes DNS resolution (`1.1.1.1` & `8.8.8.8`), updates package repositories, and installs core tools (`curl`, `wget`, `sudo`, `git`, `nano`, `htop`, `bash-completion`).
- **Instant Command Shortcuts**: Generates global binary shortcuts in `$PREFIX/bin` for every installed container (e.g. run `debian` or `kali` straight from any terminal prompt).
- **Desktop GUI Setup (XFCE4)**: Configures lightweight XFCE4 graphical environment, TigerVNC server (`127.0.0.1:5901`), and Termux:X11 integration.
- **Backup & Restore**: Export container rootfs to compressed `.tar.gz` archives and restore anytime.

---

## Installation

Install in Termux via one-line curl command:
```bash
curl -sSL https://raw.githubusercontent.com/0xposa/termux-distro/main/install.sh | bash
```

Or manually clone and install:
```bash
git clone https://github.com/0xposa/termux-distro.git ~/projects/termux-distro
cd ~/projects/termux-distro
chmod +x install.sh && ./install.sh
```

---

## Quick Start

### 1. Launch Interactive Dashboard
```bash
tdistro
```
*(Or alias: `termux-distro`)*

*When launched for the first time without a config, the language selection prompt will appear in English.*

### 2. Switch Language
```bash
# Switch directly via CLI flag:
tdistro --lang en    # English
tdistro --lang id    # Bahasa Indonesia
tdistro --lang zh    # 中文 (Mandarin)

# Or change it anytime from the interactive menu: Option [ L ]
```

---

## Direct CLI Commands

You can execute common operations directly without navigating the menu:

| Command | Description |
|---|---|
| `tdistro` | Launch interactive TUI dashboard |
| `tdistro --lang <en\|id\|zh>` | Set and persist interface language |
| `tdistro install debian` | Direct install Debian 12 container |
| `tdistro install ubuntu` | Direct install Ubuntu 24.04 LTS container |
| `tdistro install kali` | Direct install Kali Linux container |
| `tdistro login <container>` | Start interactive shell in container |
| `tdistro list` | View installed containers and disk usage |
| `tdistro gui <container>` | Setup XFCE4 Desktop GUI & VNC |
| `tdistro backup` | Launch backup wizard to `.tar.gz` |
| `tdistro restore` | Restore container from archive file |
| `tdistro search <keyword>` | Search images on Docker Hub |
| `tdistro clean` | Clear cached OCI layers to reclaim space |

---

## Desktop GUI (XFCE4) Guide

If you enable Desktop GUI for a container (e.g. `debian`):

1. **Start the GUI service**:
   ```bash
   start-desktop-debian
   ```
2. **Connect via Android VNC App** (*AVNC*, *RealVNC*, or *VNC Viewer*):
   - Address: `127.0.0.1:5901` (or `localhost:1`)
   - Default password: `123456`
3. **Stop the GUI service when done**:
   ```bash
   stop-desktop-debian
   ```

---

## Project Structure

```
~/projects/termux-distro/
├── termux-distro.sh      # Main script & command router
├── install.sh            # Global installer for $PREFIX/bin/tdistro
├── README.md             # Documentation
├── MEMORY.md             # Project memory state
└── lib/
    ├── colors.sh         # Clean ANSI color palette & tags (no emojis)
    ├── i18n.sh           # Trilingual engine (English, Indonesian, Mandarin)
    ├── distros.sh        # Distro catalog & trilingual metadata
    ├── ui.sh             # Minimalist ASCII banner, status bar, menu renderer
    ├── installer.sh      # Container installer, DNS booster, & CLI shortcut generator
    ├── gui.sh            # XFCE4 Desktop & TigerVNC wizard
    └── manager.sh        # Shell launcher, disk usage, backup, restore, search
```
