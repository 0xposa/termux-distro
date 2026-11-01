#!/usr/bin/env bash
# ==============================================================================
# Termux Distro Manager - Colors & Terminal Styling Library (Zero Emoji)
# ==============================================================================

if [[ -t 1 ]]; then
    # Formatting
    C_RESET="\033[0m"
    C_BOLD="\033[1m"
    C_DIM="\033[2m"
    C_UNDERLINE="\033[4m"

    # Minimalist High-Contrast Palette
    C_BLACK="\033[38;5;232m"
    C_WHITE="\033[38;5;255m"
    C_GRAY="\033[38;5;244m"
    C_DARK_GRAY="\033[38;5;238m"

    # Vibrant Neon Gradient Colors
    C_CYAN="\033[38;5;51m"
    C_AQUA="\033[38;5;45m"
    C_BLUE="\033[38;5;39m"
    C_PURPLE="\033[38;5;141m"
    C_MAGENTA="\033[38;5;201m"
    C_PINK="\033[38;5;213m"
    C_ROSE="\033[38;5;203m"
    C_GREEN="\033[38;5;48m"
    C_YELLOW="\033[38;5;226m"
    C_GOLD="\033[38;5;220m"
    C_RED="\033[38;5;196m"

    # Backgrounds for Badges
    BG_CYAN="\033[48;5;39m"
    BG_PURPLE="\033[48;5;55m"
    BG_GREEN="\033[48;5;28m"
else
    C_RESET=""
    C_BOLD=""
    C_DIM=""
    C_UNDERLINE=""
    C_BLACK=""
    C_WHITE=""
    C_GRAY=""
    C_DARK_GRAY=""
    C_CYAN=""
    C_AQUA=""
    C_BLUE=""
    C_PURPLE=""
    C_MAGENTA=""
    C_PINK=""
    C_ROSE=""
    C_GREEN=""
    C_YELLOW=""
    C_GOLD=""
    C_RED=""
    BG_CYAN=""
    BG_PURPLE=""
    BG_GREEN=""
fi

# Modern Unicode Box Drawing
BOX_TL="╭"
BOX_TR="╮"
BOX_BL="╰"
BOX_BR="╯"
BOX_H="─"
BOX_V="│"

# Clean ASCII Tags (Zero Emoji)
TAG_OK="${C_GREEN}[OK]${C_RESET}"
TAG_INFO="${C_CYAN}[INFO]${C_RESET}"
TAG_WARN="${C_YELLOW}[WARN]${C_RESET}"
TAG_ERR="${C_RED}[ERROR]${C_RESET}"
TAG_STEP="${C_CYAN}[::]${C_RESET}"
TAG_ARROW="${C_CYAN}❯${C_RESET}"

print_line() {
    local width="${1:-61}"
    local color="${2:-$C_DARK_GRAY}"
    local char="${3:-─}"
    local line=""
    for ((i = 0; i < width; i++)); do
        line+="$char"
    done
    echo -e "${color}${line}${C_RESET}"
}

print_box_header() {
    local title="$1"
    local color="${2:-$C_CYAN}"
    local width=61
    local title_len=${#title}
    local left_pad=$(( (width - title_len - 2) / 2 ))
    local right_pad=$(( width - title_len - 2 - left_pad ))

    local h_line=""
    for ((i = 0; i < width; i++)); do h_line+="$BOX_H"; done

    local left_spaces=""
    for ((i = 0; i < left_pad; i++)); do left_spaces+=" "; done
    local right_spaces=""
    for ((i = 0; i < right_pad; i++)); do right_spaces+=" "; done

    echo -e "${color}${BOX_TL}${h_line}${BOX_TR}${C_RESET}"
    echo -e "${color}${BOX_V}${C_RESET}${left_spaces}${C_BOLD}${C_WHITE}${title}${C_RESET}${right_spaces}${color}${BOX_V}${C_RESET}"
    echo -e "${color}${BOX_BL}${h_line}${BOX_BR}${C_RESET}"
}

log_info() {
    echo -e "  ${TAG_INFO} ${C_WHITE}$1${C_RESET}"
}

log_success() {
    echo -e "  ${TAG_OK} ${C_GREEN}${C_BOLD}$1${C_RESET}"
}

log_warn() {
    echo -e "  ${TAG_WARN} ${C_YELLOW}$1${C_RESET}"
}

log_error() {
    echo -e "  ${TAG_ERR} ${C_RED}${C_BOLD}$1${C_RESET}"
}

log_step() {
    echo -e "\n  ${TAG_STEP} ${C_BOLD}${C_CYAN}$1${C_RESET}"
}
