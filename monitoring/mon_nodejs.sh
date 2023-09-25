#!/bin/bash
export LANG=ko_KR.UTF-8

source mon_stdlib.sh

echo "======================================================================================="
echo "===== CHECK NODEJS STATUS"
echo "======================================================================================="
NODEJS_PID_LIST=($(ps -ef | grep node | grep www | awk {'print $2'}))
log_debug "$ ps -ef | grep node | grep www | awk {'print \$2'}"

if [ -n ${NODEJS_PID_LIST[@]} ]; then
    NODEJS_PID=${NODEJS_PID_LIST[0]}
fi
log_info "NodeJS PID: ${NODEJS_PID}"
log_info "NodeJS PID CNT: ${#NODEJS_PID_LIST[@]}"

# ((${#NODEJS_PID_LIST[@]})) && {
((${NODEJS_PID})) && {
    if [ ${#NODEJS_PID_LIST[@]} -gt 1 ]; then
        log_error "multiple PID, nodejs restart"
        # service nodejs restart
        $(sudo pm2 stop www)
        (($?)) && {
            print_failure "failed cmd: sudo pm2 stop www"
        } || {
            $(sudo pm2 start www)
            (($?)) && {
                print_failure "failed cmd: sudo pm2 start www"
            } || {
                print_success "[NODEJS] Service restarted"
            }
        }
    else
        print_success "[NODEJS] Service is alived"
    fi
} || {
    # nothing pid, service start
    # service nodejs start
    $(sudo pm2 start www)
    (($?)) && {
        print_failure "failed cmd: sudo pm2 start www"
    } || {
        print_success "[NODEJS] Service started"
    }
}

#echo "======================================================================================="

exit 0
