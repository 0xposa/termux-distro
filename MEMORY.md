# Termux Distro Manager - Memory Bank

## 1. Overview & Architecture
- **Project**: Termux Distro Manager (`tdistro` / `termux-distro`)
- **Directory**: `/data/data/com.termux/files/home/projects/termux-distro` (symlink `ternux-distro`)
- **Design Philosophy**: High-aesthetic cyberpunk ASCII banner restored, clean box-drawing layout, zero emojis, professional CLI/TUI aesthetics.
- **Multilingual Engine**: Full trilingual localization in English (`en`), Bahasa Indonesia (`id`), and Mandarin / Simplified Chinese (`zh`).
- **Core Modules**:
  - `termux-distro.sh`: Master CLI entrypoint and interactive dashboard.
  - `install.sh`: Global binary installer for `$PREFIX/bin/tdistro`.
  - `lib/colors.sh`: High-contrast gradient neon palette with text tags (`[OK]`, `[INFO]`, `[WARN]`, `[ERROR]`, `[::]`, `❯`).
  - `lib/i18n.sh`: Localization engine, configuration persistence (`~/.config/tdistro/config.env`), and English first-run language selection prompt.
  - `lib/distros.sh`: Trilingual catalog of 12+ Linux distributions (Debian, Ubuntu, Kali, Arch, Alpine, Fedora, Void, openSUSE, Rocky, Alma, Manjaro, NixOS) + custom OCI images.
  - `lib/ui.sh`: Restored full Cyber ASCII banner, system status bar, styled section headers, and badge items without emojis.
  - `lib/installer.sh`: Container installation, DNS fix (`1.1.1.1` & `8.8.8.8`), package upgrades, and `$PREFIX/bin/<name>` shortcut generation.
  - `lib/gui.sh`: Desktop GUI configuration (XFCE4, TigerVNC `127.0.0.1:5901`, Termux:X11).
  - `lib/manager.sh`: Shell launcher, disk usage, backup, restore, rename, remove, and Docker Hub search.

## 2. Status & Active Tasks
- [x] Restored the full iconic cyber ASCII banner and system status header.
- [x] Removed all distracting emojis across menus, distros, and status tags.
- [x] Trilingual engine (`lib/i18n.sh`) implemented for English, Bahasa Indonesia, and Mandarin (中文).
- [x] Language selection prompt strictly in English on first launch or when triggered via `[L]` / `tdistro lang`.
- [x] CLI flag `--lang <en|id|zh>` fully supported.
- [x] Tested clean execution and graceful exits.

## 3. Key Decisions & User Preferences
- **Banner Retention**: Keep the iconic ASCII banner and styled status box as requested by user.
- **Strictly No Emojis**: Replaced with clean text tags (`[OK]`, `[INFO]`, `[DEB]`, `[UBU]`, `[CATALOG]`, `[SHELL]`, etc.).
- **Language Prompt Language**: MUST always be presented in English when asking the user to choose their preferred language.
