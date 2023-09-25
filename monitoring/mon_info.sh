#!/bin/bash
export LANG=ko_KR.UTF-8

# import source
# source mon_stdlib.sh
# source mon_common.sh
# source mon_settings.sh

echo "======================================================================================="
echo "===== ACCESS INFORMATION"
echo "======================================================================================="

ALLOWED_LIST=./allowed_user.dat

# input id and password
print_header "ACCESS INFORMATION"

log_debug "settings, USER: ${USER}"
log_debug "settings, DB_ID: ${DB_ID}"
log_debug "settings, DB_PW: ${DB_PW}"

(($#)) && {
    log_debug "args, $1, $2, $3"
    email=$1
    user=$2
    pass=$3
} || {
    log_debug "not args"
    read -p "Email: " email
    is_null ${email}
    exit_if_error $? "Email is null"

    check_email ${ALLOWED_LIST} ${email}
    exit_if_error $? "Not guaranteed.[${?}] ${email}"
    log_debug "check_email() -> ${?}"
    if [ ${?} -ne 0 ]; then
        fatal_error "Not auaranteed. ${email}"
    fi
    log_debug "Guaranteed. ${email}"

    read -p "ID for DB: " user
    is_null ${user}
    exit_if_error $? "Username is null"

    read -sp "PW for DB: " pass
    is_null ${pass}
    exit_if_error $? "Password is null"
}

print_info "Allowed E-Mail: ${email}"
print_info "DB Account: ${user} / ${pass}"

echo "======================================================================================="
