#!/bin/bash
export LANG=ko_KR.UTF-8

source lib/stdlib.sh
source mon_settings.sh
#
# Extended functions
#

print_header() {
    printf "$COLOR_BOLD$COLOR_BLUE"
    printf '%s\n' "$@"
    printf "$COLOR_OFF"
}

print_failure() {
    printf "${COLOR_RED}FAILURE: "
    printf '%s\n' "$@"
    printf "$COLOR_OFF"
}

print_title() {
    printf "$COLOR_YELLOW"
    printf '%s\n' "$@"
    printf "$COLOR_OFF"
}

print_title_inline() {
    printf "$COLOR_YELLOW"
    printf '%s' "$@"
    printf "$COLOR_OFF"
}

print_message_inline() {
    printf '%s' "$@"
}

print_newline() {
    printf '%s\n' ""
}

#
# Definitions
#

set_log_level ${LOG_LEVEL}
# set_log_file ${LOG_PATH}
