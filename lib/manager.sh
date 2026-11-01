#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Lifecycle, Login, Backup & Maintenance Engine
# ==============================================================================

menu_login_distro() {
    clear_screen
    print_banner
    print_box_header "INTERACTIVE CONTAINER LOGIN" "$C_GREEN"
    echo ""

    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_warn "No installed distributions found. Please install one first."
        press_any_key
        return 0
    fi

    echo -e "  ${C_BOLD}${C_WHITE}Select container to launch:${C_RESET}\n"
    local i=1
    for d in "${installed_list[@]}"; do
        printf "  ${C_CYAN}[%2d]${C_RESET} %-20s ${C_DARK}(Command: ${C_WHITE}%s${C_DARK})${C_RESET}\n" "$i" "$d" "$d"
        ((i++))
    done
    printf "  ${C_RED}[00]${C_RESET} %s\n\n" "$(t "cancel_return")"

    echo -ne "  ${C_CYAN}Select container [1-${#installed_list[@]}, 0]: ${C_RESET}"
    read -r choice

    if [[ "$choice" == "0" || "$choice" == "00" || -z "$choice" ]]; then
        return 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#installed_list[@]} )); then
        local target="${installed_list[$((choice - 1))]}"
        clear_screen
        echo -e "${C_CYAN}[::] Entering interactive session: ${target} (Type 'exit' to leave)...${C_RESET}\n"
        proot-distro login "$target"
    else
        log_error "$(t "invalid_choice")"
        sleep 1.2
    fi
}

menu_list_distros() {
    clear_screen
    print_banner
    print_box_header "INSTALLED CONTAINERS & STORAGE" "$C_CYAN"
    echo ""

    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_info "No active containers installed on this system."
        press_any_key
        return 0
    fi

    local proot_base="$PREFIX/var/lib/proot-distro/installed-rootfs"

    echo -e "  ${C_BOLD}${C_WHITE}Active Rootfs Containers:${C_RESET}\n"
    local idx=1
    for d in "${installed_list[@]}"; do
        local dir_path="$proot_base/$d"
        local size="N/A"
        if [[ -d "$dir_path" ]]; then
            size=$(du -sh "$dir_path" 2>/dev/null | cut -f1 || echo "N/A")
        fi

        echo -e "  ${C_CYAN}[$idx] Container: ${C_BOLD}${C_WHITE}${d}${C_RESET}"
        echo -e "      ${C_DARK}*${C_RESET} ${C_GRAY}Disk Usage :${C_RESET} ${C_YELLOW}${size}${C_RESET}"
        echo -e "      ${C_DARK}*${C_RESET} ${C_GRAY}Location   :${C_RESET} ${C_DARK}${dir_path}${C_RESET}"
        echo -e "      ${C_DARK}*${C_RESET} ${C_GRAY}Quick Cmd  :${C_RESET} ${C_GREEN}${d}${C_RESET}"
        if [[ -f "$PREFIX/bin/start-desktop-$d" ]]; then
            echo -e "      ${C_DARK}*${C_RESET} ${C_GRAY}Desktop GUI:${C_RESET} ${C_CYAN}start-desktop-${d}${C_RESET}"
        fi
        echo ""
        ((idx++))
    done

    press_any_key
}

menu_backup_distro() {
    clear_screen
    print_banner
    print_box_header "$(t "backup_title")" "$C_GOLD"
    echo ""

    echo -e "  ${C_BOLD}${C_WHITE}Backup Operations:${C_RESET}\n"
    print_menu_item "01" "[TAR]" "$(t "backup_opt_create")" "Export guest rootfs to compressed archive"
    print_menu_item "02" "[RST]" "$(t "backup_opt_restore")" "Import and restore container from archive"
    print_menu_item "00" "[ESC]" "$(t "cancel_return")" ""
    echo ""

    echo -ne "  ${C_CYAN}Select option [1, 2, 0]: ${C_RESET}"
    read -r b_choice

    case "$b_choice" in
        1|01) process_backup ;;
        2|02) process_restore ;;
        *) return 0 ;;
    esac
}

process_backup() {
    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_warn "No installed containers available to backup."
        press_any_key
        return 0
    fi

    echo ""
    echo -e "  ${C_BOLD}${C_WHITE}Select container to backup:${C_RESET}"
    local i=1
    for d in "${installed_list[@]}"; do
        printf "  ${C_CYAN}[%2d]${C_RESET} %s\n" "$i" "$d"
        ((i++))
    done
    echo -ne "  Enter choice [1-${#installed_list[@]}]: "
    read -r sel
    if [[ ! "$sel" =~ ^[0-9]+$ ]] || (( sel < 1 || sel > ${#installed_list[@]} )); then
        log_error "$(t "invalid_choice")"
        press_any_key
        return 1
    fi

    local target="${installed_list[$((sel - 1))]}"
    local backup_dir="$HOME/distro-backups"
    mkdir -p "$backup_dir"
    local timestamp
    timestamp=$(date +%Y%m%d_%H%M%S)
    local out_file="$backup_dir/${target}_backup_${timestamp}.tar.gz"

    log_step "Creating compressed archive for '${target}'..."
    echo -e "  Target file: ${out_file}"
    echo -e "  This operation may take several minutes depending on container size...\n"

    if proot-distro backup --output "$out_file" "$target"; then
        log_success "Backup archive created at: ${out_file}"
    else
        log_error "Backup operation failed!"
    fi
    press_any_key
}

process_restore() {
    local backup_dir="$HOME/distro-backups"
    if [[ ! -d "$backup_dir" ]]; then
        log_warn "Backup directory ($backup_dir) does not exist."
        press_any_key
        return 1
    fi

    local backups=()
    while IFS= read -r f; do
        [[ -n "$f" ]] && backups+=("$f")
    done < <(find "$backup_dir" -type f \( -name "*.tar*" -o -name "*.tgz" \) 2>/dev/null)

    if [[ ${#backups[@]} -eq 0 ]]; then
        log_warn "No backup archives (.tar / .tar.gz) found in $backup_dir"
        press_any_key
        return 0
    fi

    echo ""
    echo -e "  ${C_BOLD}${C_WHITE}Select backup archive to restore:${C_RESET}"
    local i=1
    for b in "${backups[@]}"; do
        printf "  ${C_CYAN}[%2d]${C_RESET} %s\n" "$i" "$(basename "$b")"
        ((i++))
    done
    echo -ne "  Enter choice [1-${#backups[@]}]: "
    read -r sel
    if [[ ! "$sel" =~ ^[0-9]+$ ]] || (( sel < 1 || sel > ${#backups[@]} )); then
        log_error "$(t "invalid_choice")"
        press_any_key
        return 1
    fi

    local target_file="${backups[$((sel - 1))]}"
    echo -ne "  Enter new container name for restored instance: "
    read -r new_name
    if [[ -z "$new_name" ]]; then
        log_error "Container name cannot be empty!"
        press_any_key
        return 1
    fi

    log_step "Restoring container '${new_name}' from archive..."
    if proot-distro restore "$target_file" "$new_name"; then
        log_success "Container '${new_name}' restored successfully."
        create_launcher_shortcut "$new_name"
    else
        log_error "Container restoration failed."
    fi
    press_any_key
}

menu_remove_distro() {
    clear_screen
    print_banner
    print_box_header "$(t "remove_title")" "$C_RED"
    echo ""

    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_warn "No installed containers to remove."
        press_any_key
        return 0
    fi

    echo -e "  ${C_BOLD}${C_WHITE}Select container to remove:${C_RESET}\n"
    local i=1
    for d in "${installed_list[@]}"; do
        printf "  ${C_RED}[%2d]${C_RESET} %s\n" "$i" "$d"
        ((i++))
    done
    printf "  ${C_DARK}[00]${C_RESET} %s\n\n" "$(t "cancel_return")"

    echo -ne "  Select container [1-${#installed_list[@]}, 0]: "
    read -r choice

    if [[ "$choice" == "0" || "$choice" == "00" || -z "$choice" ]]; then
        return 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#installed_list[@]} )); then
        local target="${installed_list[$((choice - 1))]}"
        echo ""
        printf "  ${TAG_WARN} ${C_RED}$(t "remove_warning")${C_RESET}\n" "$target"
        echo -ne "  ${C_YELLOW}$(t "remove_confirm_prompt")${C_RESET}"
        read -r confirm

        if [[ "$confirm" == "DELETE" || "$confirm" == "HAPUS" ]]; then
            log_step "Removing container '${target}'..."
            if proot-distro remove "$target"; then
                rm -f "$PREFIX/bin/$target" "$PREFIX/bin/start-desktop-$target" "$PREFIX/bin/stop-desktop-$target"
                log_success "Container '${target}' and its command shortcuts have been removed."
            else
                log_error "Failed to remove container '${target}'."
            fi
        else
            log_info "Operation cancelled."
        fi
        press_any_key
    else
        log_error "$(t "invalid_choice")"
        sleep 1.2
    fi
}

menu_clear_cache() {
    clear_screen
    print_banner
    print_box_header "OCI LAYER CACHE CLEANER" "$C_YELLOW"
    echo ""
    echo -e "  ${C_GRAY}PRoot-Distro caches downloaded OCI layers to accelerate reinstalls.${C_RESET}"
    echo -e "  ${C_GRAY}If you are low on internal storage, you can clear this cache safely.${C_RESET}\n"

    echo -ne "  Clear cached OCI layers now? (y/N): "
    read -r ans

    if [[ "$ans" =~ ^[Yy]$ ]]; then
        log_step "Purging OCI download cache..."
        if proot-distro clear-cache; then
            log_success "Cache cleared successfully. Internal storage reclaimed."
        else
            log_info "Cache is already empty."
        fi
    else
        log_info "Cache purge skipped."
    fi
    press_any_key
}

menu_search_hub() {
    clear_screen
    print_banner
    print_box_header "DOCKER HUB REPOSITORY SEARCH" "$C_CYAN"
    echo ""
    echo -ne "  ${C_CYAN}Enter search keyword (e.g. debian, ubuntu, arch, rust): ${C_RESET}"
    read -r query

    if [[ -z "$query" ]]; then
        log_error "Search query cannot be empty!"
        press_any_key
        return 0
    fi

    echo ""
    log_step "Searching Docker Hub for '${query}'..."
    echo ""
    proot-distro search --limit 15 "$query" || log_error "Search request failed."

    echo ""
    echo -e "  ${TAG_INFO} To install any of the above, use Menu [01] -> Option [C]"
    press_any_key
}
