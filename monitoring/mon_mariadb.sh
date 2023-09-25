#!/bin/bash
export LANG=ko_KR.UTF-8

source mon_stdlib.sh
source mon_common.sh
source mon_settings.sh

#
# test API mysqladmin ping
#
function run_mysqladmin_ping() {
    (($#)) || return

    local id=$1
    local pw=$2

    log_debug "run_mysqladmin_ping(), id=${id}, pw=${pw}"
    log_debug "run_mysqladmin_ping(), cmd=sudo mysqladmin ping -u${id} -p${pw} 2>&1"
    local result=($(sudo mysqladmin ping -u${id} -p${pw} 2>&1))
    # log_debug "run_mysqladmin_ping(), cmd=sudo mysqladmin ping -u${id} -p${pw}"
    # local result=($(sudo mysqladmin ping -u${id} -p${pw}))

    (($?)) && {
        return 1
    } || {
        local str="${result[@]}"
        log_debug "run_mysqladmin_ping(), result=${str}"
        [[ ${str} =~ "alive" ]] && {
            # ok
            print_success "[MARIADB] mysqladmin ping: [PSSS], result=${str}"
            return 0
        }

        [[ ${str} =~ "error" ]] && {
            # not ok
            log_debug "run_mysqladmin_ping(), result has 'error'"
            print_failure "[MARIADB] mysqladmin ping: [FAIL]"
            return 1
        }
    }
    return 1
}

#
# test API mysqlcheck -A
#
function run_mysqlcheck() {
    (($#)) || return

    local id=$1
    local pw=$2

    log_debug "run_mysqlcheck(), id=${id}, pw=${pw}"
    log_debug "run_mysqlcheck(), cmd=sudo mysqlcheck -A -u${id} -p${pw} | grep -v OK 2>&1"
    local result=($(sudo mysqlcheck -A -u${id} -p${pw} | grep -v OK 2>&1))
    # log_debug "run_mysqlcheck(), cmd=sudo mysqlcheck -A -u${id} -p${pw} | grep -v OK"
    # local result=($(sudo mysqlcheck -A -u${id} -p${pw} | grep -v OK))

    (($?)) && {
        return 1
    } || {
        local cnt="${#result[@]}"
        log_debug "run_mysqlcheck(), NOK table cnt=${cnt}"
        ((${cnt})) && {
            log_debug "NOK TBs: ${result[@]}"
            print_failure "[MARIADB] mysqlcheck -A: [FAIL], NOKs=${result[@]}"
            return 1
        } || {
            print_success "[MARIADB] mysqlcheck -A: [PSSS], NOKs=${cnt}"
            return 0
        }
    }

    return 1
}

#
# mariadb start action
#
function action_mariadb() {
    (($#)) || return

    local act=$1
    log_debug "action_mariadb(), arg: act=${act}"

    case ${act} in

    START | Start | start)
        # mariadb start
        log_info "MARIADB starting..."
        # (($(sudo systemctl start mariadb))) && {
        # (($(sudo service mysql start))) && {
        (($(sudo service mariadb start))) && {
            return 1
        } || {
            print_success "[MARIADB] Service started"
            # $(sudo systemctl status mariadb)
            # $(sudo service mariadb status)
            return 0
        }
        ;;

    SHUTDOWN | Shutdown | shutdown | STOP | Stop | stop)
        # mariadb stop
        log_info "MARIADB stoping..."
        # (($(sudo systemctl stop mariadb))) && {
        (($(sudo service mariadb stop))) && {
            return 1
        } || {
            print_success "[MARIADB] Service stoped"
            # $(sudo systemctl status mariadb)
            # $(sudo service mariadb status)
            return 0
        }
        ;;

    RESTART | Restart | restart)
        # mariadb restart
        log_info "MARIADB restarting..."
        log_debug "MARIADB restarting..."
        # (($(systemctl restart mariadb))) && {
        (($(sudo service mariadb restart))) && {
            return 1
        } || {
            print_success "[MARIADB] Service restarted"
            # $(sudo systemctl status mariadb)
            # $(sudo service mariadb status)
            return 0
        }
        ;;

    *)
        log_error "Unknown actions: ${act}"
        ;;

    esac
    return 1
}

echo "======================================================================================="
echo "===== CHECK MARIADB STATUS"
echo "======================================================================================="

# check mysqladmin ping
run_mysqladmin_ping ${DB_ID} ${DB_PW}

(($?)) && {
    print_failure "mysqladmin ping test failed!"
}

# check mysqlcheck -A
#run_mysqlcheck ${DB_ID} ${DB_PW}
#
#(($?)) && {
#    print_failure "mysqlcheck -A test failed!"
#}

# check pid
MARIADB_PID_LIST=($(ps -eF | grep mariadb | grep mysql | awk '{print $2}'))
log_debug "$ ps -eF | grep 'mariadb' | grep -v grep | awk '{print \$2}'"

if [ -n ${MARIADB_PID_LIST[@]} ]; then
    MARIADB_PID=${MARIADB_PID_LIST[0]}
fi
log_info "MariaDB PID: ${MARIADB_PID}"
log_info "MariaDB PID Cnt: ${#MARIADB_PID_LIST[@]}"

((${MARIADB_PID})) && {
    # MARIADB_PID=${MARIADB_PID_LIST}
    # log_info "MariaDB PID: ${MARIADB_PID}"
    MYSQLD_PID=($(sudo cat /run/mysqld/mysqld.pid))
    log_info "mysqld PID: ${MYSQLD_PID}"

    if [ ${#MARIADB_PID_LIST[@]} -gt 1 ] || [ ${MARIADB_PID} -ne ${MYSQLD_PID} ]; then
        # service mysql restart
        (($(action_mariadb restart))) && {
            print_failure "Refer to previous error"
        } || {
            print_success "[MARIADB] Service restarted"
        }
    else
        print_success "[MARIADB] Service is alived"
    fi
} || {
    # nothing pid, service start
    # service mysql start
    (($(action_mariadb start))) && {
        print_failure "Refer to previous error"
    } || {
        print_success "[MARIADB] Service started"
    }
}

#echo "======================================================================================="

exit 0
