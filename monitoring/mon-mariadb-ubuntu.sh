#!/usr/bin/bash
# which bash

export LANG=ko_KR.UTF-8

SERVICE_NAME="mariadb"

printf "=======================================================================================\n"
# printf "##### CHECK %s STATUS ##### \n\n" "${SERVICE_NAME^^}"
printf "##### CHECK %s STATUS ##### \n\n" "$SERVICE_NAME"

# echo "test1 : $(pgrep -f mariadbd -l)"
# echo "test2 : $(pgrep -f mariadb -l)"

SERVICE_STATUS=$(systemctl is-active $SERVICE_NAME)
printf "Service %s, status: %s \n" "$SERVICE_NAME" "$SERVICE_STATUS"
if [ "$SERVICE_STATUS" = "inactive" ]; then
    printf "Service %s is restarting...\n" "$SERVICE_NAME"
    systemctl restart $SERVICE_NAME
    sleep 5
else
    # SERVICE_PID="$(pgrep -f mariadbd | grep -v ${0##*/} | grep -v grep | awk '{print $1}'))"
    SERVICE_PID="$(pgrep -f mariadbd | grep -v mon_mariadb.sh | grep -v grep | awk '{print $1}')"
    ARR_PID=(${SERVICE_PID}) # split by space
    PID_CNT=${#ARR_PID[@]}
    printf "Service %s, PID cnt: %d \n" "$SERVICE_NAME" "$PID_CNT"
    for pid in "${ARR_PID[@]}"; do
        printf "Service %s(PID: %s) is already running...\n" "$SERVICE_NAME" "$pid"
    done
fi

printf "=======================================================================================\n"
