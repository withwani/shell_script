#!/usr/bin/bash
# which bash

export LANG=ko_KR.UTF-8

SERVICE_NAME="tomcat"
SERVICE_PATH=/opt/apache-tomcat-9.0.70/bin

printf "=======================================================================================\n"
# printf "##### CHECK %s STATUS ##### \n\n" "${SERVICE_NAME^^}"
printf "##### CHECK %s STATUS ##### \n\n" "$SERVICE_NAME"

# echo "test1 : $(pgrep -f java -l)"
# echo "test2 : $(pgrep -f tomcat -l)"

# SERVICE_PID="$(pgrep -f java)"
SERVICE_PID="$(pgrep -f java | grep -v mon_mariadb.sh | grep -v grep | awk '{print $1}')"
ARR_PID=(${SERVICE_PID}) # split by space
PID_CNT=${#ARR_PID[@]}
printf "Service %s, PID cnt: %d \n" "$SERVICE_NAME" "$PID_CNT"

if [ "$PID_CNT" -ne 1 ]; then
    if [ "$PID_CNT" -ne 0 ]; then
        printf "Service %s is checking...\n" "$SERVICE_NAME"
        for pid in "${ARR_PID[@]}"; do
            printf "Tomcat process PID %s \n" "$pid"
        done
        # printf "Service %s is killing...\n" "$SERVICE_NAME"
        # for pid in "${ARR_PID[@]}"; do
        #     printf "Kill -2 %s \n" "$pid"
        #     kill -2 "$pid"
        #     sleep 1
        # done

        # sleep 1
    else
        printf "Service %s is nothing...\n" "$SERVICE_NAME"
    fi

    printf "Service %s is restarting...\n" "$SERVICE_NAME"
    printf "Service path: %s/startup.sh \n" "$SERVICE_PATH"
    # shellcheck source=/dev/null
    sh $SERVICE_PATH/startup.sh
    sleep 10
else
    printf "Service %s(PID: %s) is already running...\n" "$SERVICE_NAME" "$SERVICE_PID"
fi

printf "=======================================================================================\n"
