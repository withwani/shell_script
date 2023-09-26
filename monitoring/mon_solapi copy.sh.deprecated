#!/bin/bash
export LANG=ko_KR.UTF-8

source mon_stdlib.sh

echo "======================================================================================="
echo "===== CHECK SOLAPI STATUS"
echo "======================================================================================="
SOLAPI_PID_LIST=($(ps -ef | grep solapi | grep agent | awk {'print $2'}))
log_debug "$ ps -ef | grep solapi | grep agent | awk {'print \$2'}"

if [ -n ${SOLAPI_PID_LIST[@]} ]; then
    SOLAPI_PID=${SOLAPI_PID_LIST[0]}
fi
log_info "SOLAPI PID: ${SOLAPI_PID}"
log_info "SOLAPI PID CNT: ${#SOLAPI_PID_LIST[@]}"

# ((${#SOLAPI_PID_LIST[@]})) && {
((${SOLAPI_PID})) && {
    if [ ${#SOLAPI_PID_LIST[@]} -gt 1 ]; then
        log_error "multiple PID, solapi restart"
        # service solapi restart
        $(cd ${SOLAPI_PATH} && sudo ./agent stop)
        (($?)) && {
            print_failure "failed cmd: cd ${SOLAPI_PATH} && sudo ./agent stop"
        } || {
            $(cd ${SOLAPI_PATH} && sudo ./agent start)
            (($?)) && {
                print_failure "failed cmd: cd ${SOLAPI_PATH} && sudo ./agent start"
            } || {
                print_success "[SOLAPI] Service restarted"
            }
        }
    else
        print_success "[SOLAPI] Service is alived"
    fi
} || {
    # nothing pid, service start
    # service solapi start
    $(cd ${SOLAPI_PATH} && sudo ./agent start)
    (($?)) && {
        print_failure "failed cmd: cd ${SOLAPI_PATH} && sudo ./agent start"
    } || {
        print_success "[SOLAPI] Service started"
    }
}

#echo "======================================================================================="

exit 0
