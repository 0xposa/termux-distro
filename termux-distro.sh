#!/usr/bin/env bash
# ==============================================================================
# TERMUX DISTRO MANAGER - Minimalist, Clean & Trilingual Linux Container Suite
# Languages: English (en), Bahasa Indonesia (id), Simplified Chinese (zh)
# Supported Distros: Debian, Ubuntu, Kali, Arch, Alpine, Fedora, Void,
# openSUSE, Rocky Linux, AlmaLinux, Manjaro, NixOS, and custom Docker Hub images.
# ==============================================================================

set -e

# Resolve script directory (handles symlinks properly)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
    DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" >/dev/null 2>&1 && pwd)"

# Source Libraries
# shellcheck source=/dev/null
source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/i18n.sh"
source "$SCRIPT_DIR/lib/distros.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/lib/installer.sh"
source "$SCRIPT_DIR/lib/gui.sh"
source "$SCRIPT_DIR/lib/manager.sh"

trap 'echo -e "\n\n  ${C_CYAN}Exiting Termux Distro Manager.${C_RESET}\n"; exit 0' INT TERM

handle_cli_args() {
    # Check for language flag
    if [[ "$1" == "--lang" && -n "$2" ]]; then
        case "$2" in
            id|ID) CURRENT_LANG="id" ;;
            zh|ZH|cn|CN) CURRENT_LANG="zh" ;;
            *) CURRENT_LANG="en" ;;
        esac
        save_language_config "$CURRENT_LANG"
        shift 2 || true
    fi

    local cmd="$1"
    shift || true

    case "$cmd" in
        install|i|add)
            ensure_dependencies
            if [[ -n "$1" ]]; then
                process_distro_install "$1"
            else
                menu_install_distro
            fi
            exit 0
            ;;
        login|sh|run)
            if [[ -n "$1" ]]; then
                exec proot-distro login "$@"
            else
                menu_login_distro
            fi
            exit 0
            ;;
        list|ls)
            menu_list_distros
            exit 0
            ;;
        gui)
            if [[ -n "$1" ]]; then
                setup_distro_gui "$1"
            else
                menu_gui_setup
            fi
            exit 0
            ;;
        backup)
            process_backup
            exit 0
            ;;
        restore)
            process_restore
            exit 0
            ;;
        search)
            if [[ -n "$1" ]]; then
                proot-distro search "$@"
            else
                menu_search_hub
            fi
            exit 0
            ;;
        remove|rm)
            menu_remove_distro
            exit 0
            ;;
        clean|clear-cache)
            proot-distro clear-cache
            exit 0
            ;;
        lang|language)
            prompt_language_select
            exit 0
            ;;
        help|--help|-h)
            echo -e "${C_BOLD}${C_CYAN}Termux Distro Manager (tdistro) - Usage:${C_RESET}"
            echo -e "  tdistro                     Launch interactive TUI dashboard"
            echo -e "  tdistro --lang <en|id|zh>   Set interface language"
            echo -e "  tdistro install <distro>    Install distribution directly (e.g. debian, ubuntu)"
            echo -e "  tdistro login <distro>      Start container shell session"
            echo -e "  tdistro list                Display installed containers and storage usage"
            echo -e "  tdistro gui <distro>        Configure XFCE4 Desktop GUI & VNC"
            echo -e "  tdistro backup              Export container to .tar.gz archive"
            echo -e "  tdistro restore             Import container from archive"
            echo -e "  tdistro search <query>      Search images on Docker Hub"
            echo -e "  tdistro clean               Clear OCI image download cache"
            exit 0
            ;;
        "")
            ;;
        *)
            if is_distro_installed "$cmd"; then
                exec proot-distro login "$cmd" "$@"
            else
                echo -e "${TAG_ERR} Unknown command: ${cmd}"
                echo -e "  Run 'tdistro --help' for available commands."
                exit 1
            fi
            ;;
    esac
}

menu_booster_manual() {
    clear_screen
    print_banner
    print_box_header "$(t "menu_booster")" "$C_GOLD"
    echo ""

    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_warn "No installed containers found."
        press_any_key
        return 0
    fi

    echo -e "  ${C_BOLD}${C_WHITE}Select container to optimize:${C_RESET}\n"
    local i=1
    for d in "${installed_list[@]}"; do
        printf "  ${C_BOLD}${C_AQUA}[ %2d ]${C_RESET} %s\n" "$i" "$d"
        ((i++))
    done
    printf "  ${C_BOLD}${C_RED}[ 00 ]${C_RESET} %s\n\n" "$(t "cancel_return")"

    echo -ne "  Select container [1-${#installed_list[@]}, 0]: "
    read -r bsel

    if [[ "$bsel" =~ ^[0-9]+$ ]] && (( bsel >= 1 && bsel <= ${#installed_list[@]} )); then
        local target="${installed_list[$((bsel - 1))]}"
        run_post_install_booster "$target" "apt"
        press_any_key
    fi
}

main_dashboard() {
    ensure_dependencies

    while true; do
        clear_screen
        print_banner
        print_system_status

        print_section "$(t "main_menu_title")" "[MENU]"
        echo ""

        print_menu_item "01" "[INS]" "$(t "menu_install")" "$(t "menu_install_desc")" "CATALOG"
        print_menu_item "02" "[RUN]" "$(t "menu_login")"   "$(t "menu_login_desc")"   "SHELL"
        print_menu_item "03" "[GUI]" "$(t "menu_gui")"     "$(t "menu_gui_desc")"     "DESKTOP"
        print_menu_item "04" "[BST]" "$(t "menu_booster")" "$(t "menu_booster_desc")" "BOOSTER"
        print_menu_item "05" "[LST]" "$(t "menu_list")"    "$(t "menu_list_desc")"    "STATUS"
        print_menu_item "06" "[BAK]" "$(t "menu_backup")"  "$(t "menu_backup_desc")"  "BACKUP"
        print_menu_item "07" "[HUB]" "$(t "menu_search")"  "$(t "menu_search_desc")"  "DOCKER"
        print_menu_item "08" "[DEL]" "$(t "menu_remove")"  "$(t "menu_remove_desc")"  "REMOVE"
        print_menu_item "09" "[CLN]" "$(t "menu_clean")"   "$(t "menu_clean_desc")"   "CACHE"
        echo ""
        print_menu_item " L" "[LNG]" "$(t "menu_lang")"    "$(t "menu_lang_desc")"    "LANGUAGE"
        print_menu_item "00" "[ESC]" "$(t "menu_exit")"    ""                          ""
        echo ""

        echo -ne "  ${C_BOLD}${C_CYAN}$(t "prompt_menu_select")${C_RESET}"
        read -r main_choice

        case "$main_choice" in
            1|01) menu_install_distro ;;
            2|02) menu_login_distro ;;
            3|03) menu_gui_setup ;;
            4|04) menu_booster_manual ;;
            5|05) menu_list_distros ;;
            6|06) menu_backup_distro ;;
            7|07) menu_search_hub ;;
            8|08) menu_remove_distro ;;
            9|09) menu_clear_cache ;;
            l|L) prompt_language_select ;;
            0|00|q|Q|exit)
                clear_screen
                echo -e "\n  ${TAG_OK} Goodbye!\n"
                exit 0
                ;;
            *)
                log_error "$(t "invalid_choice")"
                sleep 1.0
                ;;
        esac
    done
}

# Entrypoint
init_language "$@"
handle_cli_args "$@"
main_dashboard
