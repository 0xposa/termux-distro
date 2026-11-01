#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Installation & Booster Engine (Clean & Multilingual)
# ==============================================================================

ensure_dependencies() {
    local missing=()
    for cmd in proot-distro curl jq tar; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        log_warn "Missing required packages: ${missing[*]}"
        echo -ne "  Install missing dependencies via pkg now? (Y/n): "
        read -r ans
        if [[ -z "$ans" || "$ans" =~ ^[Yy]$ ]]; then
            pkg update -y && pkg install -y proot-distro curl jq tar xz-utils
        else
            log_error "Installation aborted due to missing dependencies."
            return 1
        fi
    fi
    return 0
}

menu_install_distro() {
    clear_screen
    print_banner
    print_system_status
    print_section "$(t "catalog_title")" "[CATALOG]"
    echo ""

    local idx=1
    for key in "${DISTRO_KEYS[@]}"; do
        local d_name d_tag d_desc d_status
        d_name=$(get_distro_prop "$key" "name")
        d_tag=$(get_distro_prop "$key" "tag")
        d_desc=$(get_distro_prop "$key" "desc")

        if is_distro_installed "$key"; then
            d_status="${C_GREEN}${C_BOLD}$(t "status_installed")${C_RESET}"
        else
            d_status="${C_DARK_GRAY}$(t "status_available")${C_RESET}"
        fi

        printf "  ${C_BOLD}${C_AQUA}[ %2d ]${C_RESET} ${C_BOLD}${C_CYAN}%-6s${C_RESET} ${C_BOLD}${C_WHITE}%-30s${C_RESET} %b\n" "$idx" "$d_tag" "$d_name" "$d_status"
        printf "         ${C_DARK_GRAY}↳ %s${C_RESET}\n" "$d_desc"
        ((idx++))
    done

    echo ""
    printf "  ${C_BOLD}${C_MAGENTA}[  C ]${C_RESET} ${C_BOLD}${C_PURPLE}[OCI] ${C_RESET} ${C_BOLD}${C_WHITE}%-30s${C_RESET} ${C_BLACK}${BG_CYAN} DOCKER HUB ${C_RESET}\n" "$(t "custom_distro_option")"
    printf "         ${C_DARK_GRAY}↳ %s${C_RESET}\n" "$(t "custom_distro_desc")"
    printf "  ${C_BOLD}${C_RED}[ 00 ]${C_RESET} ${C_GRAY}%s${C_RESET}\n" "$(t "cancel_return")"
    echo ""

    printf "  ${C_BOLD}${C_CYAN}$(t "prompt_catalog_select")${C_RESET}" "${#DISTRO_KEYS[@]}"
    read -r choice

    if [[ "$choice" == "0" || "$choice" == "00" || -z "$choice" ]]; then
        return 0
    fi

    if [[ "$choice" =~ ^[Cc]$ ]]; then
        install_custom_distro
        return 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#DISTRO_KEYS[@]} )); then
        local selected_key="${DISTRO_KEYS[$((choice - 1))]}"
        process_distro_install "$selected_key"
    else
        log_error "$(t "invalid_choice")"
        sleep 1.2
    fi
}

process_distro_install() {
    local key="$1"
    local d_name d_image d_def_name d_pkg d_gui
    d_name=$(get_distro_prop "$key" "name")
    d_image=$(get_distro_prop "$key" "image")
    d_def_name=$(get_distro_prop "$key" "default_name")
    d_pkg=$(get_distro_prop "$key" "pkg_mgr")
    d_gui=$(get_distro_prop "$key" "gui_ready")

    clear_screen
    print_banner
    print_box_header "$(t "config_title"): ${d_name}" "$C_AQUA"
    echo ""

    if is_distro_installed "$d_def_name"; then
        log_warn "A container named '${d_def_name}' is already installed."
        echo -e "  ${C_GRAY}You can provide a unique custom name below to install a new instance.${C_RESET}\n"
    fi

    echo -e "  ${C_BOLD}${C_CYAN}::${C_RESET} ${C_GRAY}Target Distro :${C_RESET} ${C_WHITE}${d_name}${C_RESET}"
    echo -e "  ${C_BOLD}${C_CYAN}::${C_RESET} ${C_GRAY}OCI Image Ref :${C_RESET} ${C_CYAN}${d_image}${C_RESET}"
    echo -e "  ${C_BOLD}${C_CYAN}::${C_RESET} ${C_GRAY}Package Mgr   :${C_RESET} ${C_YELLOW}${d_pkg}${C_RESET}"
    echo ""

    local target_name
    printf "  ${C_CYAN}$(t "prompt_container_name")${C_RESET}" "$d_def_name"
    read -r target_name
    target_name="${target_name:-$d_def_name}"

    if [[ ! "$target_name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
        log_error "Container name can only contain letters, numbers, dot, dash, and underscore!"
        press_any_key
        return 1
    fi

    if is_distro_installed "$target_name"; then
        log_warn "Container '${target_name}' already exists!"
        echo -ne "  Reinstall / overwrite container '${target_name}'? (y/N): "
        read -r reinstall_ans
        if [[ "$reinstall_ans" =~ ^[Yy]$ ]]; then
            log_step "Removing existing container '${target_name}'..."
            proot-distro remove "$target_name"
        else
            log_error "Installation cancelled to protect existing data."
            press_any_key
            return 1
        fi
    fi

    echo -ne "  ${C_CYAN}$(t "prompt_booster")${C_RESET}"
    read -r booster_ans
    local do_booster=true
    if [[ "$booster_ans" =~ ^[Nn]$ ]]; then
        do_booster=false
    fi

    local do_gui=false
    if [[ "$d_gui" == "true" ]]; then
        echo -ne "  ${C_CYAN}$(t "prompt_setup_gui")${C_RESET}"
        read -r gui_ans
        if [[ "$gui_ans" =~ ^[Yy]$ ]]; then
            do_gui=true
        fi
    fi

    echo ""
    log_step "$(t "downloading_image")"
    echo ""

    if proot-distro install -n "$target_name" "$d_image"; then
        echo ""
        printf "  ${TAG_OK} ${C_GREEN}$(t "install_success")${C_RESET}\n" "$target_name"

        create_launcher_shortcut "$target_name"

        if [[ "$do_booster" == "true" ]]; then
            run_post_install_booster "$target_name" "$d_pkg"
        fi

        if [[ "$do_gui" == "true" ]]; then
            setup_distro_gui "$target_name" "$d_pkg"
        fi

        echo ""
        print_line 64 "$C_GREEN" "─"
        printf "  ${TAG_INFO} $(t "quick_start_hint")\n" "$target_name"
        echo -e "  ${TAG_INFO} Or execute: proot-distro login ${target_name}"
        print_line 64 "$C_GREEN" "─"
    else
        echo ""
        printf "  ${TAG_ERR} ${C_RED}$(t "install_failed")${C_RESET}\n" "$target_name"
    fi

    press_any_key
}

install_custom_distro() {
    clear_screen
    print_banner
    print_box_header "CUSTOM OCI IMAGE / REGISTRY" "$C_PURPLE"
    echo ""
    echo -e "  ${C_GRAY}Specify an image reference from Docker Hub or rootfs archive URL.${C_RESET}\n"

    echo -ne "  ${C_CYAN}Enter Image reference / URL: ${C_RESET}"
    read -r custom_ref
    if [[ -z "$custom_ref" ]]; then
        log_error "Reference cannot be empty!"
        press_any_key
        return 1
    fi

    echo -ne "  ${C_CYAN}Enter unique container name: ${C_RESET}"
    read -r custom_name
    if [[ -z "$custom_name" ]]; then
        log_error "Container name cannot be empty!"
        press_any_key
        return 1
    fi

    log_step "Installing '${custom_ref}' as '${custom_name}'..."
    if proot-distro install -n "$custom_name" "$custom_ref"; then
        log_success "Container '${custom_name}' installed successfully!"
        create_launcher_shortcut "$custom_name"
    else
        log_error "Failed to install '${custom_name}'!"
    fi
    press_any_key
}

create_launcher_shortcut() {
    local name="$1"
    local bin_path="$PREFIX/bin/$name"

    cat << 'EOF' > "$bin_path"
#!/usr/bin/env bash
CONTAINER="NAME_PLACEHOLDER"

if ! command -v proot-distro >/dev/null 2>&1; then
    echo "[ERROR] proot-distro utility not found!"
    exit 1
fi

echo "[::] Launching container: $CONTAINER ..."
exec proot-distro login "$CONTAINER" "$@"
EOF

    sed -i "s/NAME_PLACEHOLDER/$name/g" "$bin_path"
    chmod +x "$bin_path"
    log_info "Shortcut generated: ${C_CYAN}${name}${C_RESET} at ${bin_path}"
}

run_post_install_booster() {
    local name="$1"
    local pkg_mgr="$2"

    log_step "Applying System Booster (DNS configuration & core utilities)..."

    # Configure reliable nameservers (Cloudflare 1.1.1.1 and Google 8.8.8.8)
    proot-distro login "$name" -- sh -c 'echo "nameserver 1.1.1.1" > /etc/resolv.conf && echo "nameserver 8.8.8.8" >> /etc/resolv.conf' 2>/dev/null || true

    case "$pkg_mgr" in
        apt)
            log_info "Updating APT repositories and installing core CLI tools..."
            proot-distro login "$name" -- sh -c 'export DEBIAN_FRONTEND=noninteractive && apt-get update -y && apt-get install -y sudo curl wget git nano ca-certificates htop bash-completion' 2>/dev/null || log_warn "Some apt packages skipped."
            ;;
        pacman)
            log_info "Updating Pacman repositories and installing packages..."
            proot-distro login "$name" -- sh -c 'pacman -Sy --noconfirm --needed sudo curl wget git nano htop bash-completion ca-certificates' 2>/dev/null || log_warn "Some pacman packages skipped."
            ;;
        apk)
            log_info "Updating APK and installing core packages..."
            proot-distro login "$name" -- sh -c 'apk update && apk add sudo curl wget git nano bash htop ca-certificates' 2>/dev/null || log_warn "Some apk packages skipped."
            ;;
        dnf)
            log_info "Updating DNF and installing packages..."
            proot-distro login "$name" -- sh -c 'dnf install -y sudo curl wget git nano htop' 2>/dev/null || log_warn "Some dnf packages skipped."
            ;;
        xbps)
            log_info "Updating XBPS repository..."
            proot-distro login "$name" -- sh -c 'xbps-install -Syu && xbps-install -y sudo curl wget git nano htop' 2>/dev/null || log_warn "Some xbps packages skipped."
            ;;
    esac

    # Minimalist clean PS1
    proot-distro login "$name" -- sh -c '
        if [ -f /root/.bashrc ]; then
            echo "PS1=\"\\[\\033[1;32m\\]\\u@\\h\\[\\033[0m\\]:\\[\\033[1;34m\\]\\w\\[\\033[0m\\]\\$ \"" >> /root/.bashrc
            echo "alias ls=\"ls --color=auto\"" >> /root/.bashrc
            echo "alias ll=\"ls -lah --color=auto\"" >> /root/.bashrc
        fi
    ' 2>/dev/null || true

    log_success "System booster applied successfully."
}
