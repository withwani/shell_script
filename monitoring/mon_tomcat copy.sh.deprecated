#!/bin/bash
export LANG=ko_KR.UTF-8

source mon_stdlib.sh
source mon_settings.sh

#
# update status file and loda to DB
#
function update_status() {
    (($#)) || return

    local val=$1
    # Using tomcat_status.sh
    # log_debug "call tomcat_status.sh"
    # sh ${TOMCAT_SBIN_PATH}/tomcat_status.sh

    # Using direct input to file
    log_debug "updating ${val} > ${TOMCAT_SBIN_PATH}/${TOMCAT_STATUS_TEXT}"
    # echo "${val}" >${TOMCAT_SBIN_PATH}/${TOMCAT_STATUS_TEXT}
    echo "${val}" | sudo tee ${TOMCAT_SBIN_PATH}/${TOMCAT_STATUS_TEXT} >"/dev/null"
    # echo ${val} >../test.txt # for test
    print_success "[TOMCAT] updated ${TOMCAT_STATUS_TEXT} < ${val}"

    # log_debug "call load.sh"
    # sh ${TOMCAT_SBIN_PATH}/load.sh

    # (($(mysql -u${DB_ID} -p${DB_PW} -D town -e " truncate table tb_status"))) && {
    $(sudo mysql -u${DB_ID} -p${DB_PW} -D town -e " truncate table tb_status")
    (($?)) && {
        return 1
    } || {
        # print_success "[TOMCAT] updated ${TOMCAT_STATUS_TEXT}"
        # return 0
        # (($(mysql -u${DB_ID} -p${DB_PW} -D town -e " load data local infile '${TOMCAT_SBIN_PATH}/${TOMCAT_STATUS_TEXT}' INTO TABLE tb_status"))) && {
        $(sudo mysql -u${DB_ID} -p${DB_PW} -D town -e " load data local infile '${TOMCAT_SBIN_PATH}/${TOMCAT_STATUS_TEXT}' INTO TABLE tb_status")
        (($?)) && {
            return 1
        } || {
            print_success "[TOMCAT] updated tb_status table from ${TOMCAT_STATUS_TEXT}"
            return 0
        }
    }

    return 1
}

#
# tomcat start action
#
function action_tomcat() {
    (($#)) || return

    local act=$1
    log_debug "action_tomcat(), arg: act=${act}"

    case ${act} in

    START | Start | start)
        # tomcat start
        log_info "TOMCAT starting..."
        (($(sh ${TOMCAT_BIN_PATH}/startup.sh))) && {
            return 1
        } || {
            print_success "[TOMCAT] Service started"
            return 0
        }
        ;;

    SHUTDOWN | Shutdown | shutdown | STOP | Stop | stop)
        # tomcat shutdown
        log_info "TOMCAT stoping..."
        (($(sh ${TOMCAT_BIN_PATH}/shutdown.sh))) && {
            return 1
        } || {
            print_success "[TOMCAT] Service stoped"
            return 0
        }
        ;;

    RESTART | Restart | restart)
        # tomcat restart
        log_info "TOMCAT restarting..."
        log_debug "TOMCAT restarting..."
        (($(sh ${TOMCAT_BIN_PATH}/shutdown.sh))) && {
            return 1
        } || {
            (($(sh ${TOMCAT_BIN_PATH}/startup.sh))) && {
                return 1
            } || {
                print_success "[TOMCAT] Service restarted"
                return 0
            }
        }
        ;;

    *)
        log_error "Unknown actions: ${act}"
        ;;

    esac
    return 1
}

echo "======================================================================================="
echo "===== CHECK TOMCAT STATUS"
echo "======================================================================================="
TOMCAT_PID_LIST=($(ps -ef | grep tomcat | grep apache | awk {'print $2'}))
log_debug "$ ps -ef | grep -wv grep | grep apache-tomcat | awk {'print \$2'}"

if [ -z ${TOMCAT_PID_LIST[0]} ]; then TOMCAT_PID="NULL"; else TOMCAT_PID=${TOMCAT_PID_LIST[0]}; fi
log_info "Tomcat PID: ${TOMCAT_PID}"
log_info "Tomcat PID CNT: ${#TOMCAT_PID_LIST[@]}"

log_debug "if [ ${#TOMCAT_PID_LIST[*]} -ne 1 ]"
if [ ${#TOMCAT_PID_LIST[@]} -ne 1 ]; then
    log_debug "Tomcat PID is empty or not ONE"
    log_debug "Tomcat is not alive! plz start the service"
    # input value(1) to /usr/sbin/tomcat_status.txt
    update_status 1
    (($?)) && {
        log_error "Refer to previous error"
    }
    # service tomcat start
    (($(action_tomcat start))) && {
        log_error "Refer to previous error"
    } || {
        print_success "[TOMCAT] Service started"
    }
else
    log_debug "if [ -f ${TOMCAT_BIN_PATH}/catalina.pid ]"
    if [ -f ${TOMCAT_BIN_PATH}/catalina.pid ]; then
        log_debug "$ cat ${TOMCAT_BIN_PATH}/catalina.pid"
        CATALINA_PID=($(sudo cat ${TOMCAT_BIN_PATH}/catalina.pid))
        log_info "Tomcat PID: ${TOMCAT_PID}"
        log_info "Catalina PID CNT: ${CATALINA_PID}"

        log_debug "if [ -z ${TOMCAT_PID} ] || [ -z ${CATALINA_PID} ] || [ ${TOMCAT_PID} -ne ${CATALINA_PID} ]"
        if [ -z ${TOMCAT_PID} ] || [ -z ${CATALINA_PID} ] || [ ${TOMCAT_PID} -ne ${CATALINA_PID} ]; then
            # log_debug "Tomcat PID is different"
            # log_debug "Tomcat has some problem. plz restart the service"
            # input value(1) to /usr/sbin/tomcat_status.txt
            update_status 1
            (($?)) && {
                log_error "Refer to previous error"
            }
            # service tomcat restart
            (($(action_tomcat restart))) && {
                print_failure "Refer to previous error"
            } || {
                print_success "[TOMCAT] Service restarted"
            }
        else
            # log_debug "Tomcat PID same"
            # log_debug "Tomcat is alive!"
            # input value(2) to /usr/sbin/tomcat_status.txt
            update_status 2
            (($?)) && {
                log_error "Refer to previous error"
            }

            print_success "[TOMCAT] Service is alived"
        fi
    else
        update_status 2
        (($?)) && {
            log_error "Refer to previous error"
        }
        print_success "[TOMCAT] Service is alived"
    fi
fi

#echo "======================================================================================="

exit 0
