#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Internationalization & Localization Engine
# Languages: English (en), Bahasa Indonesia (id), Simplified Chinese (zh)
# ==============================================================================

CONFIG_DIR="$HOME/.config/tdistro"
CONFIG_FILE="$CONFIG_DIR/config.env"
CURRENT_LANG="en"

# Associative translation tables
declare -A T_EN
declare -A T_ID
declare -A T_ZH

# ==============================================================================
# Translation Dictionaries
# ==============================================================================

# Common / Status
T_EN["status_installed"]="[INSTALLED]"
T_ID["status_installed"]="[TERPASANG]"
T_ZH["status_installed"]="[已安装]"

T_EN["status_available"]="[AVAILABLE]"
T_ID["status_available"]="[TERSEDIA]"
T_ZH["status_available"]="[可安装]"

T_EN["press_enter"]="Press [ENTER] to continue..."
T_ID["press_enter"]="Tekan [ENTER] untuk melanjutkan..."
T_ZH["press_enter"]="按 [ENTER] 键继续..."

T_EN["invalid_choice"]="Invalid selection! Please enter a valid option."
T_ID["invalid_choice"]="Pilihan tidak valid! Silakan masukkan opsi yang benar."
T_ZH["invalid_choice"]="输入无效！请输入有效选项。"

T_EN["cancel_return"]="[00] Back to Main Menu"
T_ID["cancel_return"]="[00] Kembali ke Menu Utama"
T_ZH["cancel_return"]="[00] 返回主菜单"

# Header & Info Bar
T_EN["app_subtitle"]="Linux Container Management Utility"
T_ID["app_subtitle"]="Utilitas Manajemen Kontainer Linux"
T_ZH["app_subtitle"]="Linux 容器运行与管理工具"

T_EN["arch"]="Arch"
T_ID["arch"]="Arsitektur"
T_ZH["arch"]="系统架构"

T_EN["installed_count"]="Installed"
T_ID["installed_count"]="Terpasang"
T_ZH["installed_count"]="已安装"

T_EN["free_space"]="Free Space"
T_ID["free_space"]="Ruang Kosong"
T_ZH["free_space"]="可用空间"

# Main Menu
T_EN["main_menu_title"]="MAIN DASHBOARD"
T_ID["main_menu_title"]="MENU UTAMA"
T_ZH["main_menu_title"]="主控制台"

T_EN["menu_install"]="Install New Distribution"
T_ID["menu_install"]="Pasang Distro Baru"
T_ZH["menu_install"]="安装新 Linux 发行版"
T_EN["menu_install_desc"]="Debian, Ubuntu, Kali, Arch, Alpine, Fedora, etc."
T_ID["menu_install_desc"]="Debian, Ubuntu, Kali, Arch, Alpine, Fedora, dll."
T_ZH["menu_install_desc"]="Debian, Ubuntu, Kali, Arch, Alpine, Fedora 等"

T_EN["menu_login"]="Launch / Terminal Shell"
T_ID["menu_login"]="Masuk / Jalankan Sesi Distro"
T_ZH["menu_login"]="启动 / 进入终端 Shell"
T_EN["menu_login_desc"]="Start interactive shell session inside container"
T_ID["menu_login_desc"]="Mulai sesi terminal interaktif dalam kontainer"
T_ZH["menu_login_desc"]="进入已安装容器的交互式命令行会话"

T_EN["menu_gui"]="Setup Desktop GUI (XFCE4)"
T_ID["menu_gui"]="Setup Desktop GUI (XFCE4)"
T_ZH["menu_gui"]="配置图形桌面环境 (XFCE4)"
T_EN["menu_gui_desc"]="Configure lightweight XFCE4 desktop via VNC / Termux:X11"
T_ID["menu_gui_desc"]="Pasang desktop XFCE4 via VNC / Termux:X11"
T_ZH["menu_gui_desc"]="一键部署 XFCE4 图形桌面并通过 VNC / Termux:X11 运行"

T_EN["menu_booster"]="System Optimization & Booster"
T_ID["menu_booster"]="Optimasi & Booster Sistem"
T_ZH["menu_booster"]="系统网络优化与基础包增强"
T_EN["menu_booster_desc"]="Configure DNS resolver, package repos & core utilities"
T_ID["menu_booster_desc"]="Perbaiki DNS resolver, update paket & alat esensial"
T_ZH["menu_booster_desc"]="修复 DNS 解析配置、更新软件源并安装基础开发工具"

T_EN["menu_list"]="List Installed Distributions"
T_ID["menu_list"]="Daftar Distro & Penggunaan Disk"
T_ZH["menu_list"]="查看已安装发行版及存储空间"
T_EN["menu_list_desc"]="View container rootfs details, size, and shortcuts"
T_ID["menu_list_desc"]="Lihat lokasi rootfs, kapasitas memori, dan shortcut"
T_ZH["menu_list_desc"]="查看已安装容器路径、磁盘占用与快捷指令"

T_EN["menu_backup"]="Backup & Restore Container"
T_ID["menu_backup"]="Cadangkan & Pulihkan Kontainer"
T_ZH["menu_backup"]="容器备份与数据恢复"
T_EN["menu_backup_desc"]="Save container to .tar.gz archive or restore from file"
T_ID["menu_backup_desc"]="Simpan kontainer ke file .tar.gz atau pulihkan"
T_ZH["menu_backup_desc"]="将完整容器打包为 .tar.gz 文件或从备份恢复"

T_EN["menu_search"]="Search Docker Hub / OCI"
T_ID["menu_search"]="Cari Image di Docker Hub"
T_ZH["menu_search"]="在 Docker Hub 检索镜像"
T_EN["menu_search_desc"]="Discover public Linux images and runtime stacks"
T_ID["menu_search_desc"]="Cari ribuan image Linux dari registry publik"
T_ZH["menu_search_desc"]="在线查询 Docker Hub 上可用的 Linux 发行版与工具镜像"

T_EN["menu_remove"]="Remove / Reset Container"
T_ID["menu_remove"]="Hapus / Reset Distro"
T_ZH["menu_remove"]="删除或重置容器"
T_EN["menu_remove_desc"]="Delete unused container to reclaim storage space"
T_ID["menu_remove_desc"]="Hapus kontainer lama untuk membebaskan penyimpanan"
T_ZH["menu_remove_desc"]="安全删除不再需要的容器并释放存储空间"

T_EN["menu_clean"]="Clear Image Download Cache"
T_ID["menu_clean"]="Bersihkan Cache Unduhan"
T_ZH["menu_clean"]="清理镜像下载缓存"
T_EN["menu_clean_desc"]="Delete cached OCI layers to free internal memory"
T_ID["menu_clean_desc"]="Hapus cache layer OCI untuk melegakan penyimpanan"
T_ZH["menu_clean_desc"]="清理已下载的 OCI 缓存文件以释放内部存储"

T_EN["menu_lang"]="Change Language"
T_ID["menu_lang"]="Ganti Bahasa"
T_ZH["menu_lang"]="更改语言 (Language)"
T_EN["menu_lang_desc"]="Switch between English, Bahasa Indonesia, and 中文"
T_ID["menu_lang_desc"]="Pilih antara English, Bahasa Indonesia, dan 中文"
T_ZH["menu_lang_desc"]="切换界面显示语言 (English / 印尼语 / 中文)"

T_EN["menu_exit"]="Exit"
T_ID["menu_exit"]="Keluar"
T_ZH["menu_exit"]="退出程序"

T_EN["prompt_menu_select"]="Select an option [ 0 - 9, L ]: "
T_ID["prompt_menu_select"]="Pilih opsi [ 0 - 9, L ]: "
T_ZH["prompt_menu_select"]="请选择操作 [ 0 - 9, L ]: "

# Installer Module
T_EN["catalog_title"]="LINUX DISTRIBUTION CATALOG"
T_ID["catalog_title"]="KATALOG DISTRIBUSI LINUX"
T_ZH["catalog_title"]="LINUX 发行版官方仓库列表"

T_EN["prompt_catalog_select"]="Select distribution [1-%d, C, 0]: "
T_ID["prompt_catalog_select"]="Pilih nomor distro [1-%d, C, 0]: "
T_ZH["prompt_catalog_select"]="请选择发行版编号 [1-%d, C, 0]: "

T_EN["custom_distro_option"]="Custom Image / Docker Registry"
T_ID["custom_distro_option"]="Image Kustom / Docker Registry"
T_ZH["custom_distro_option"]="自定义镜像 / Docker Registry"

T_EN["custom_distro_desc"]="Pull any reference from Docker Hub or rootfs URL"
T_ID["custom_distro_desc"]="Gunakan image Docker Hub atau tautan file rootfs"
T_ZH["custom_distro_desc"]="拉取 Docker Hub 上的任意镜像或 rootfs 下载直链"

T_EN["config_title"]="INSTALLATION CONFIGURATION"
T_ID["config_title"]="KONFIGURASI INSTALASI"
T_ZH["config_title"]="安装配置详情"

T_EN["prompt_container_name"]="Enter unique container name [Default: %s]: "
T_ID["prompt_container_name"]="Nama unik kontainer [Default: %s]: "
T_ZH["prompt_container_name"]="设置容器唯一标识名称 [默认: %s]: "

T_EN["prompt_booster"]="Apply system booster (DNS resolver fix, package update & core tools)? (Y/n): "
T_ID["prompt_booster"]="Terapkan booster otomatis (DNS fix, update paket & tools)? (Y/n): "
T_ZH["prompt_booster"]="是否应用系统优化 (修复 DNS、更新软件源并安装基础工具)? (Y/n): "

T_EN["prompt_setup_gui"]="Setup XFCE4 Desktop GUI simultaneously? (y/N): "
T_ID["prompt_setup_gui"]="Pasang Desktop GUI XFCE4 sekaligus? (y/N): "
T_ZH["prompt_setup_gui"]="是否同时配置 XFCE4 图形桌面环境? (y/N): "

T_EN["downloading_image"]="Pulling OCI layers from registry. Please wait..."
T_ID["downloading_image"]="Mengunduh layer OCI dari registry. Harap tunggu..."
T_ZH["downloading_image"]="正在从镜像源拉取 OCI 分层数据，请稍候..."

T_EN["install_success"]="Container '%s' installed successfully!"
T_ID["install_success"]="Distro '%s' berhasil dipasang!"
T_ZH["install_success"]="容器 '%s' 安装成功！"

T_EN["install_failed"]="Failed to install container '%s'! Check your network connection."
T_ID["install_failed"]="Gagal memasang distro '%s'! Periksa koneksi internet Anda."
T_ZH["install_failed"]="安装容器 '%s' 失败！请检查网络连接。"

T_EN["quick_start_hint"]="Quick Launch: Type '%s' directly in Termux"
T_ID["quick_start_hint"]="Cara Masuk: Ketik '%s' langsung di Termux"
T_ZH["quick_start_hint"]="快捷启动: 在 Termux 中直接输入 '%s'"

# GUI Module
T_EN["gui_title"]="DESKTOP GUI CONFIGURATION (XFCE4 + VNC)"
T_ID["gui_title"]="WIZARD DESKTOP GUI (XFCE4 + VNC)"
T_ZH["gui_title"]="图形桌面环境配置向导 (XFCE4 + VNC)"

T_EN["gui_no_distros"]="No installed distribution found! Please install one first."
T_ID["gui_no_distros"]="Belum ada distro terpasang! Pasang distro terlebih dahulu."
T_ZH["gui_no_distros"]="尚未检测到已安装的发行版，请先安装一个发行版。"

T_EN["gui_select_target"]="Select container to install GUI on [1-%d, 0]: "
T_ID["gui_select_target"]="Pilih nomor kontainer untuk dipasangi GUI [1-%d, 0]: "
T_ZH["gui_select_target"]="选择需要配置图形桌面的容器 [1-%d, 0]: "

T_EN["gui_success_header"]="DESKTOP GUI ACTIVE"
T_ID["gui_success_header"]="DESKTOP GUI TELAH AKTIF"
T_ZH["gui_success_header"]="图形桌面环境配置完成"

T_EN["gui_vnc_client"]="Client App : Open 'VNC Viewer' / 'AVNC' on Android"
T_ID["gui_vnc_client"]="Aplikasi   : Buka 'VNC Viewer' / 'AVNC' di Android"
T_ZH["gui_vnc_client"]="客户端连接 : 在手机端打开 'VNC Viewer' 或 'AVNC'"

T_EN["gui_vnc_address"]="Address    : 127.0.0.1:5901 or localhost:1"
T_ID["gui_vnc_address"]="Alamat     : 127.0.0.1:5901 atau localhost:1"
T_ZH["gui_vnc_address"]="连接地址   : 127.0.0.1:5901 或 localhost:1"

T_EN["gui_vnc_password"]="Password   : 123456"
T_ID["gui_vnc_password"]="Sandi      : 123456"
T_ZH["gui_vnc_password"]="连接密码   : 123456"

# Backup / Restore
T_EN["backup_title"]="BACKUP & RESTORE ENGINE"
T_ID["backup_title"]="CADANGAN & PEMULIHAN DISTRO"
T_ZH["backup_title"]="容器备份与还原"

T_EN["backup_opt_create"]="[01] Backup container to .tar.gz archive"
T_ID["backup_opt_create"]="[01] Cadangkan kontainer ke arsip .tar.gz"
T_ZH["backup_opt_create"]="[01] 备份指定容器为 .tar.gz 压缩包"

T_EN["backup_opt_restore"]="[02] Restore container from backup archive"
T_ID["backup_opt_restore"]="[02] Pulihkan kontainer dari file cadangan"
T_ZH["backup_opt_restore"]="[02] 从已有备份压缩包恢复容器"

# Remove
T_EN["remove_title"]="CONTAINER REMOVAL & RESET"
T_ID["remove_title"]="PENGHAPUSAN & RESET KONTAINER"
T_ZH["remove_title"]="容器删除与重置管理"

T_EN["remove_warning"]="WARNING: This will permanently erase container '%s'!"
T_ID["remove_warning"]="PERINGATAN: Tindakan ini akan menghapus permanen data '%s'!"
T_ZH["remove_warning"]="警告: 此操作将永久删除容器 '%s' 及其所有数据！"

T_EN["remove_confirm_prompt"]="Type 'DELETE' in uppercase to confirm: "
T_ID["remove_confirm_prompt"]="Ketik 'HAPUS' dengan huruf kapital untuk konfirmasi: "
T_ZH["remove_confirm_prompt"]="请输入大写 'DELETE' 确认删除: "

# Function to translate key
t() {
    local key="$1"
    local text=""

    case "$CURRENT_LANG" in
        id) text="${T_ID[$key]}" ;;
        zh) text="${T_ZH[$key]}" ;;
        *)  text="${T_EN[$key]}" ;;
    esac

    # Fallback to English if missing
    if [[ -z "$text" ]]; then
        text="${T_EN[$key]}"
    fi

    # Fallback to key itself if still empty
    if [[ -z "$text" ]]; then
        text="$key"
    fi

    echo "$text"
}

# Function to save language selection
save_language_config() {
    local lang="$1"
    mkdir -p "$CONFIG_DIR"
    echo "CURRENT_LANG=\"$lang\"" > "$CONFIG_FILE"
}

# English prompt for first-time or language switcher
# REQUIRED BY SPECIFICATION: "bahasa saat diminta untuk pilih bahasa harus bahasa ingris."
prompt_language_select() {
    clear_screen
    print_banner
    print_box_header "LANGUAGE CONFIGURATION" "$C_CYAN"
    echo ""
    echo -e "  ${C_BOLD}${C_WHITE}Please select your preferred language:${C_RESET}\n"
    printf "  ${C_BOLD}${C_AQUA}[ 1 ]${C_RESET} ${C_BOLD}${C_WHITE}%-24s${C_RESET} ${C_GRAY}(English - Default)${C_RESET}\n" "English"
    printf "  ${C_BOLD}${C_AQUA}[ 2 ]${C_RESET} ${C_BOLD}${C_WHITE}%-24s${C_RESET} ${C_GRAY}(Bahasa Indonesia)${C_RESET}\n" "Bahasa Indonesia"
    printf "  ${C_BOLD}${C_AQUA}[ 3 ]${C_RESET} ${C_BOLD}${C_WHITE}%-24s${C_RESET} ${C_GRAY}(中文 - Simplified Chinese)${C_RESET}\n" "中文"
    echo ""
    echo -ne "  ${C_BOLD}${C_CYAN}Select language [ 1 - 3 ] (Default: 1): ${C_RESET}"
    read -r choice

    case "$choice" in
        2) CURRENT_LANG="id" ;;
        3) CURRENT_LANG="zh" ;;
        *) CURRENT_LANG="en" ;;
    esac

    save_language_config "$CURRENT_LANG"
    echo ""
    case "$CURRENT_LANG" in
        id) echo -e "  ${TAG_OK} ${C_GREEN}Bahasa diatur ke: Bahasa Indonesia${C_RESET}" ;;
        zh) echo -e "  ${TAG_OK} ${C_GREEN}语言已设置为: 中文 (Simplified Chinese)${C_RESET}" ;;
        *)  echo -e "  ${TAG_OK} ${C_GREEN}Language set to: English${C_RESET}" ;;
    esac
    sleep 0.8
}

# Initialize Language on Startup
init_language() {
    local bypass_prompt=false
    for arg in "$@"; do
        if [[ "$arg" == "-h" || "$arg" == "--help" || "$arg" == "--lang" ]]; then
            bypass_prompt=true
            break
        fi
    done

    if [[ -f "$CONFIG_FILE" ]]; then
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
        if [[ "$CURRENT_LANG" != "en" && "$CURRENT_LANG" != "id" && "$CURRENT_LANG" != "zh" ]]; then
            CURRENT_LANG="en"
        fi
    else
        if [[ "$bypass_prompt" == "true" || ! -t 0 ]]; then
            CURRENT_LANG="en"
        else
            # First run: prompt in English (mandatory rule)
            prompt_language_select
        fi
    fi
}
