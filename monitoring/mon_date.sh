#!/usr/bin/bash -x
which bash

export LANG=ko_KR.UTF-8

# shellcheck source=/dev/null
source mon_stdlib.sh

function check_timezone() {
    (($#)) || return

    local tz=$1
    local DATE=("$(date)")
    ret=$?
    log_debug "check_timezone(), tz=${tz}, DATE=${DATE[*]}"

    if [[ -n $ret ]]; then
        exit_if_error $ret "run failed: $*"
    else
        if [[ "${DATE[*]}" =~ $tz ]]; then
            log_debug "check_timezone(), ${tz} [PASS]"
            return 0
        else
            log_debug "check_timezone(), ${tz} [FAIL]"
            return 1
        fi
    fi
}

#
# change timezone with location
#
function change_timezone() {
    (($#)) || return

    local loc=$1
    log_debug "change_timezone(), loc=${loc}"

    # set timezon to KST
    # $(timedatectl set-timezone ${loc})
    ($(timedatectl set-timezone ${loc}))
    (($?)) && {
        log_debug "change_timezone(), ${loc} [FAIL]"
        return 1
    } || {
        log_debug "change_timezone(), ${loc} [PASS]"
        return 0
    }

}

#
# check the timezone then set to timezone if the value is different.
#
function set_timezone() {
    (($#)) || return

    local tzone=$1
    local tloc=""

    log_debug "set_timezone(), tzone=${tzone}"

    # select a location of timezone
    case $tzone in
    # /kst/gi)
    KST | Kst | kst)
        tloc="Asia/Seoul"
        log_debug "set_timezone(), set tloc=${tloc}"
        ;;
    # /utc/gi)
    UTC | Utc | utc)
        echo "do nothing"
        ;;
    *) ;;
    esac

    # check timezone
    check_timezone "${tzone}"
    (($?)) && {
        # exit_if_error $? "run failed: $@"

        # change timezone
        change_timezone "${tloc}"
        (($?)) && {
            exit_if_error $? "run failed: $@"
        } || {
            # retry to check timezone
            check_timezone "${tzone}"
            (($?)) && {
                exit_if_error $? "run failed: $@"
            } || {
                print_info "Changed timezone to ${tzone}"
                return 0
            }
        }
    } || {
        print_info "Already set to ${tzone}"
        return 0
    }
    return 1
}

#
# Start script
#
print_header "CHECK DATE"

# set to KST
set_timezone "KST"
(($?)) && {
    exit_if_error $? "run failed: $@"
} || {
    # sync server time
    print_info "Next > sync server time"
    # ($(systemctl status chronyd))
}

exit 0
