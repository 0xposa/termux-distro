#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - High-Aesthetic UI & Layout Engine (Zero Emoji)
# ==============================================================================

clear_screen() {
    clear 2>/dev/null || tput clear 2>/dev/null || echo -e "\033[2J\033[H"
}

# The Iconic Cyber ASCII Banner (Restored & Zero Emoji)
print_banner() {
    echo -e "${C_CYAN}  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_AQUA}████████╗███████╗██████╗ ███╗   ███╗██╗   ██╗██╗  ██╗${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_BLUE}╚══██╔══╝██╔════╝██╔══██╗████╗ ████║██║   ██║╚██╗██╔╝${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_PURPLE}   ██║   █████╗  ██████╔╝██╔████╔██║██║   ██║ ╚███╔╝ ${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_MAGENTA}   ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║██║   ██║ ██╔██╗ ${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_PINK}   ██║   ███████╗██║  ██║██║ ╚═╝ ██║╚██████╔╝██╔╝ ██╗${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_ROSE}   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝${C_RESET}${C_CYAN}         ┃${C_RESET}"
    echo -e "${C_CYAN}  ┃  ${C_BOLD}${C_GOLD}        ─── [ LINUX DISTRO MANAGER SUITE ] ───        ${C_RESET}${C_CYAN}┃${C_RESET}"
    echo -e "${C_CYAN}  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛${C_RESET}"
}

# Clean System Status Bar
print_system_status() {
    local arch
    arch="$(uname -m 2>/dev/null || echo "unknown")"

    local installed_count=0
    if command -v proot-distro >/dev/null 2>&1; then
        installed_count=$(proot-distro list -q 2>/dev/null | grep -c . || true)
        installed_count=${installed_count:-0}
    fi

    local free_space
    free_space=$(df -h "$HOME" 2>/dev/null | awk 'NR==2 {print $4}' || echo "N/A")

    local lang_label="English"
    case "$CURRENT_LANG" in
        id) lang_label="Indonesia" ;;
        zh) lang_label="中文" ;;
    esac

    echo -e "  ${C_DARK_GRAY}╭─────────────────────────────────────────────────────────────╮${C_RESET}"
    echo -e "  ${C_DARK_GRAY}│${C_RESET} ${C_BOLD}$(t "arch"):${C_RESET} ${C_AQUA}${arch}${C_RESET} ${C_DARK_GRAY}•${C_RESET} ${C_BOLD}$(t "installed_count"):${C_RESET} ${C_GREEN}${installed_count}${C_RESET} ${C_DARK_GRAY}•${C_RESET} ${C_BOLD}$(t "free_space"):${C_RESET} ${C_GOLD}${free_space}${C_RESET} ${C_DARK_GRAY}•${C_RESET} ${C_BOLD}Lang:${C_RESET} ${C_CYAN}${lang_label}${C_RESET}  ${C_DARK_GRAY}│${C_RESET}"
    echo -e "  ${C_DARK_GRAY}╰─────────────────────────────────────────────────────────────╯${C_RESET}"
    echo ""
}

print_section() {
    local title="$1"
    local tag="${2:-[::]}"
    echo -e "  ${C_BOLD}${C_CYAN}${tag}${C_RESET} ${C_BOLD}${C_WHITE}${title}${C_RESET}"
    print_line 61 "$C_DARK_GRAY" "─"
}

print_menu_item() {
    local num="$1"
    local tag="$2"
    local title="$3"
    local desc="$4"
    local badge="$5"

    local badge_str=""
    if [[ -n "$badge" ]]; then
        badge_str=" ${C_BLACK}${BG_CYAN} ${badge} ${C_RESET}"
    fi

    printf "  ${C_BOLD}${C_AQUA}[ %-2s ]${C_RESET} ${C_BOLD}${C_CYAN}%-6s${C_RESET} ${C_BOLD}${C_WHITE}%-28s${C_RESET}%b\n" "$num" "$tag" "$title" "$badge_str"
    if [[ -n "$desc" ]]; then
        printf "         ${C_DARK_GRAY}↳ %s${C_RESET}\n" "$desc"
    fi
}

press_any_key() {
    echo ""
    echo -ne "  ${C_CYAN}${C_BOLD}$(t "press_enter")${C_RESET} "
    read -r _
}
