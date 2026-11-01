#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Desktop GUI Wizard (Clean & Multilingual)
# ==============================================================================

menu_gui_setup() {
    clear_screen
    print_banner
    print_box_header "$(t "gui_title")" "$C_AQUA"
    echo ""

    local installed_list=()
    while IFS= read -r line; do
        [[ -n "$line" ]] && installed_list+=("$line")
    done < <(get_installed_distros)

    if [[ ${#installed_list[@]} -eq 0 ]]; then
        log_warn "$(t "gui_no_distros")"
        press_any_key
        return 0
    fi

    echo -e "  ${C_BOLD}${C_WHITE}Available installed containers:${C_RESET}\n"
    local i=1
    for d in "${installed_list[@]}"; do
        printf "  ${C_CYAN}[%2d]${C_RESET} %-16s\n" "$i" "$d"
        ((i++))
    done
    printf "  ${C_RED}[00]${C_RESET} %s\n\n" "$(t "cancel_return")"

    printf "  ${C_CYAN}$(t "gui_select_target")${C_RESET}" "${#installed_list[@]}"
    read -r choice

    if [[ "$choice" == "0" || "$choice" == "00" || -z "$choice" ]]; then
        return 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#installed_list[@]} )); then
        local target="${installed_list[$((choice - 1))]}"
        setup_distro_gui "$target" "apt"
        press_any_key
    else
        log_error "$(t "invalid_choice")"
        sleep 1.2
    fi
}

setup_distro_gui() {
    local target="$1"
    local pkg_mgr="${2:-apt}"

    log_step "Installing XFCE4 desktop environment and TigerVNC on '${target}'..."

    case "$pkg_mgr" in
        apt)
            proot-distro login "$target" -- sh -c '
                export DEBIAN_FRONTEND=noninteractive
                apt-get update -y
                apt-get install -y xfce4 xfce4-terminal dbus-x11 tigervnc-standalone-server tigervnc-tools net-tools
            ' 2>/dev/null || log_warn "Some GUI packages were skipped."
            ;;
        pacman)
            proot-distro login "$target" -- sh -c '
                pacman -Sy --noconfirm xfce4 xfce4-terminal tigervnc net-tools
            ' 2>/dev/null || log_warn "Pacman GUI packages had minor issues."
            ;;
        *)
            log_warn "Manual setup may be required for this distribution."
            ;;
    esac

    # Configure VNC startup file inside guest
    proot-distro login "$target" -- sh -c '
        mkdir -p /root/.vnc
        cat << "VEOF" > /root/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
export XKL_XMODMAP_DISABLE=1
dbus-launch --exit-with-session startxfce4 &
VEOF
        chmod +x /root/.vnc/xstartup
    ' 2>/dev/null || true

    local launcher_script="$PREFIX/bin/start-desktop-$target"
    local stop_script="$PREFIX/bin/stop-desktop-$target"

    cat << 'EOF' > "$launcher_script"
#!/usr/bin/env bash
CONTAINER="NAME_PLACEHOLDER"

echo "[::] Starting Desktop VNC Server for $CONTAINER ..."
proot-distro login "$CONTAINER" -- sh -c '
    if [ ! -f /root/.vnc/passwd ]; then
        echo "123456" | vncpasswd -f > /root/.vnc/passwd
        chmod 600 /root/.vnc/passwd
    fi
    vncserver -kill :1 >/dev/null 2>&1 || true
    vncserver :1 -geometry 1280x720 -depth 24
'

echo ""
echo "┌─────────────────────────────────────────────────────────────┐"
echo "│  DESKTOP GUI SERVICE STARTED                                │"
echo "├─────────────────────────────────────────────────────────────┤"
echo "│  Client App : Open 'VNC Viewer' / 'AVNC' on Android         │"
echo "│  Address    : 127.0.0.1:5901 or localhost:1                 │"
echo "│  Password   : 123456                                        │"
echo "│  To Stop    : Execute 'stop-desktop-CONTAINER'              │"
echo "└─────────────────────────────────────────────────────────────┘"
echo ""
EOF

    cat << 'EOF' > "$stop_script"
#!/usr/bin/env bash
CONTAINER="NAME_PLACEHOLDER"

echo "[::] Stopping Desktop VNC Server for $CONTAINER ..."
proot-distro login "$CONTAINER" -- sh -c 'vncserver -kill :1'
echo "[OK] Desktop VNC server terminated."
EOF

    sed -i "s/NAME_PLACEHOLDER/$target/g" "$launcher_script"
    sed -i "s/NAME_PLACEHOLDER/$target/g" "$stop_script"
    chmod +x "$launcher_script" "$stop_script"

    echo ""
    log_success "Desktop GUI configuration complete for '${target}'."
    echo -e "  ${TAG_ARROW} Start command : ${C_CYAN}start-desktop-${target}${C_RESET}"
    echo -e "  ${TAG_ARROW} Stop command  : ${C_RED}stop-desktop-${target}${C_RESET}"
}
