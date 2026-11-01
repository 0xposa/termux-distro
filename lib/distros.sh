#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Distribution Catalog & Trilingual Metadata
# ==============================================================================

DISTRO_KEYS=(
    "debian"
    "ubuntu"
    "kali"
    "archlinux"
    "alpine"
    "fedora"
    "void"
    "opensuse"
    "rocky"
    "almalinux"
    "manjaro"
    "nixos"
)

get_distro_prop() {
    local key="$1"
    local prop="$2"
    local lang="${3:-$CURRENT_LANG}"

    case "$key" in
        debian)
            case "$prop" in
                name) echo "Debian 12 (Bookworm)" ;;
                image) echo "debian:12" ;;
                default_name) echo "debian" ;;
                tag) echo "[DEB]" ;;
                badge) echo "RECOMMENDED" ;;
                pkg_mgr) echo "apt" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Standar stabilitas tinggi, hemat memori, dan dukungan repositori terbesar." ;;
                        zh) echo "稳定性标杆，极低内存开销，拥有最庞大的 APT 软件包生态。" ;;
                        *)  echo "Gold standard of stability, rock-solid, and largest package ecosystem." ;;
                    esac
                    ;;
            esac
            ;;
        ubuntu)
            case "$prop" in
                name) echo "Ubuntu 24.04 LTS (Noble)" ;;
                image) echo "ubuntu:24.04" ;;
                default_name) echo "ubuntu" ;;
                tag) echo "[UBU]" ;;
                badge) echo "LTS STABLE" ;;
                pkg_mgr) echo "apt" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Distro terpopuler, ramah pemula, dukungan komunitas dan dokumentasi luas." ;;
                        zh) echo "最主流的 Linux 发行版，新手友好，软件兼容性极佳。" ;;
                        *)  echo "Most widely used Linux distribution, beginner friendly with modern packages." ;;
                    esac
                    ;;
            esac
            ;;
        kali)
            case "$prop" in
                name) echo "Kali Linux (Rolling)" ;;
                image) echo "kalilinux/kali-rolling:latest" ;;
                default_name) echo "kali" ;;
                tag) echo "[KALI]" ;;
                badge) echo "SECURITY" ;;
                pkg_mgr) echo "apt" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Standar industri pengujian penetrasi, audit keamanan siber, dan forensik." ;;
                        zh) echo "业界权威的网络安全渗透测试、逆向工程与数字取证发行版。" ;;
                        *)  echo "The industry standard for penetration testing, security auditing, and research." ;;
                    esac
                    ;;
            esac
            ;;
        archlinux)
            case "$prop" in
                name) echo "Arch Linux" ;;
                image) echo "archlinux:latest" ;;
                default_name) echo "archlinux" ;;
                tag) echo "[ARCH]" ;;
                badge) echo "ROLLING" ;;
                pkg_mgr) echo "pacman" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Selalu mutakhir (rolling-release), minimalis, dengan paket Pacman cepat." ;;
                        zh) echo "激进的滚动更新发行版，轻量纯粹，搭载极速 Pacman 包管理器。" ;;
                        *)  echo "Bleeding-edge rolling release, minimalist philosophy, powered by Pacman." ;;
                    esac
                    ;;
            esac
            ;;
        alpine)
            case "$prop" in
                name) echo "Alpine Linux (v3.21)" ;;
                image) echo "alpine:latest" ;;
                default_name) echo "alpine" ;;
                tag) echo "[ALP]" ;;
                badge) echo "MICRO LIGHT" ;;
                pkg_mgr) echo "apk" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Ukuran rootfs hanya ~5MB! Boot instan berbasis musl libc & busybox." ;;
                        zh) echo "体积仅约 5MB 的超轻量级系统，基于 musl libc 和 BusyBox 构建。" ;;
                        *)  echo "Ultra-lightweight rootfs (~5MB), instant boot, based on musl libc & busybox." ;;
                    esac
                    ;;
            esac
            ;;
        fedora)
            case "$prop" in
                name) echo "Fedora Linux 41" ;;
                image) echo "fedora:41" ;;
                default_name) echo "fedora" ;;
                tag) echo "[FED]" ;;
                badge) echo "MODERN" ;;
                pkg_mgr) echo "dnf" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Inovasi terkini ekosistem Red Hat, manajer paket DNF, dan kernel mutakhir." ;;
                        zh) echo "Red Hat 前沿创新实验平台，搭载新一代 DNF 包管理器与最新技术栈。" ;;
                        *)  echo "Upstream innovation from Red Hat, powered by DNF and modern tooling." ;;
                    esac
                    ;;
            esac
            ;;
        void)
            case "$prop" in
                name) echo "Void Linux (glibc)" ;;
                image) echo "ghcr.io/void-linux/void-glibc:latest" ;;
                default_name) echo "void" ;;
                tag) echo "[VOID]" ;;
                badge) echo "INDEPENDENT" ;;
                pkg_mgr) echo "xbps" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Distro independen tanpa systemd, sangat cepat dengan manajer paket XBPS." ;;
                        zh) echo "原生不依赖 systemd 的独立轻量发行版，XBPS 包管理极速响应。" ;;
                        *)  echo "Independent systemd-free distribution, lightning fast with XBPS package manager." ;;
                    esac
                    ;;
            esac
            ;;
        opensuse)
            case "$prop" in
                name) echo "openSUSE Tumbleweed" ;;
                image) echo "opensuse/tumbleweed:latest" ;;
                default_name) echo "opensuse" ;;
                tag) echo "[SUSE]" ;;
                badge) echo "ENTERPRISE" ;;
                pkg_mgr) echo "zypper" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Distro rolling-release kelas enterprise dari SUSE dengan manajer Zypper." ;;
                        zh) echo "来自 SUSE 的企业级稳定滚动更新发行版，搭载强大灵活的 Zypper。" ;;
                        *)  echo "Enterprise-grade rolling release by SUSE, powered by Zypper." ;;
                    esac
                    ;;
            esac
            ;;
        rocky)
            case "$prop" in
                name) echo "Rocky Linux 9" ;;
                image) echo "rockylinux/rockylinux:9" ;;
                default_name) echo "rocky" ;;
                tag) echo "[ROCKY]" ;;
                badge) echo "ENTERPRISE" ;;
                pkg_mgr) echo "dnf" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Kompatibilitas 1:1 binary dengan Red Hat Enterprise Linux untuk server." ;;
                        zh) echo "1:1 纯正兼容 Red Hat Enterprise Linux (RHEL) 的企业生产级系统。" ;;
                        *)  echo "1:1 bug-for-bug compatible with Red Hat Enterprise Linux (RHEL)." ;;
                    esac
                    ;;
            esac
            ;;
        almalinux)
            case "$prop" in
                name) echo "AlmaLinux 9" ;;
                image) echo "almalinux:9" ;;
                default_name) echo "almalinux" ;;
                tag) echo "[ALMA]" ;;
                badge) echo "ENTERPRISE" ;;
                pkg_mgr) echo "dnf" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Distro enterprise RHEL yang didukung komunitas dan yayasan non-profit." ;;
                        zh) echo "由非盈利开源基金会支持的 RHEL 100% 二进制兼容企业发行版。" ;;
                        *)  echo "Community-owned enterprise Linux operating system 1:1 compatible with RHEL." ;;
                    esac
                    ;;
            esac
            ;;
        manjaro)
            case "$prop" in
                name) echo "Manjaro Linux (Base)" ;;
                image) echo "manjarolinux/base:latest" ;;
                default_name) echo "manjaro" ;;
                tag) echo "[MANJ]" ;;
                badge) echo "ROLLING" ;;
                pkg_mgr) echo "pacman" ;;
                gui_ready) echo "true" ;;
                desc)
                    case "$lang" in
                        id) echo "Kekuatan ekosistem Arch Linux dengan repositori yang lebih teruji." ;;
                        zh) echo "基于 Arch 的友好衍生系统，具备更充分的稳定测试周期与工具支持。" ;;
                        *)  echo "User-friendly Arch derivative with curated stability and rolling packages." ;;
                    esac
                    ;;
            esac
            ;;
        nixos)
            case "$prop" in
                name) echo "NixOS (Nix)" ;;
                image) echo "nixos/nix:latest" ;;
                default_name) echo "nixos" ;;
                tag) echo "[NIX]" ;;
                badge) echo "DECLARATIVE" ;;
                pkg_mgr) echo "nix" ;;
                gui_ready) echo "false" ;;
                desc)
                    case "$lang" in
                        id) echo "Manajemen sistem fungsional dan deklaratif yang mencegah konflik dependensi." ;;
                        zh) echo "基于纯函数式声明式配置的现代系统，彻底杜绝依赖版本冲突。" ;;
                        *)  echo "Purely functional and declarative package and configuration management." ;;
                    esac
                    ;;
            esac
            ;;
        *)
            echo ""
            ;;
    esac
}

is_distro_installed() {
    local name="$1"
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro list -q 2>/dev/null | grep -Fxq "$name"
        return $?
    fi
    return 1
}

get_installed_distros() {
    if command -v proot-distro >/dev/null 2>&1; then
        proot-distro list -q 2>/dev/null
    fi
}
