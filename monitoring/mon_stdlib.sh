#!/usr/bin/bash
which bash

export LANG=ko_KR.UTF-8
# shellcheck source=/dev/null
. ./lib/stdlib.sh
# shellcheck source=/dev/null
. mon_settings.sh
#
# Extended functions
#

print_header() {
    printf "$COLOR_BOLD$COLOR_BLUE %s\n $COLOR_OFF" "$@"
}

print_failure() {
    printf "${COLOR_RED}FAILURE: %s\n $COLOR_OFF" "$@"
}

print_title() {
    printf "$COLOR_YELLOW %s\n $COLOR_OFF" "$@"
}

print_title_inline() {
    printf "$COLOR_YELLOW %s\n $COLOR_OFF" "$@"
}

print_message_inline() {
    printf "%s" "$@"
}

print_newline() {
    printf "%s\n" "$@"
}

#
# Definitions
#

set_log_level "INFO"
set_log_file "./logs/monitor.log"
# set_log_level "$LOG_LEVEL"
# set_log_file "$LOG_PATH"
