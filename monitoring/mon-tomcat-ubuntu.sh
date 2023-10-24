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

PID_FILE="$SERVICE_PATH/catalina.pid"

if [ -r "$PID_FILE" ]; then
    SERVICE_PID="$(cat $PID_FILE)"
    printf "SERVICE_PID (%s) \n" "$SERVICE_PID"

    printf "Service %s, status: active (%s) \n" "$SERVICE_NAME" "$(date)"

    printf "Service %s(PID: %s) is already running...\n" "$SERVICE_NAME" "$SERVICE_PID"
else
    printf "Service %s, status: inactive (%s) \n" "$SERVICE_NAME" "$(date)"

    SERVICE_PID="$(ps -ef | grep tomcat | grep apache | grep -v grep | awk '{print $2}')"
    ARR_PID=(${SERVICE_PID})
    PID_CNT=${#ARR_PID[@]}

    printf "ARR_PID (%s)(cnt: %d) \n" "${ARR_PID[*]}" "$PID_CNT"

    if [ "$PID_CNT" -ne 0 ]; then
        printf "Service %s is checking...\n" "$SERVICE_NAME"
        for pid in "${ARR_PID[@]}"; do
            printf "Tomcat process PID %s \n" "$pid"
            kill -9 "$pid"
            sleep 3
        done
    else
        printf "Service %s is nothing...\n" "$SERVICE_NAME"
    fi

    printf "Service %s is restarting...\n" "$SERVICE_NAME"
    printf "Service path: %s/startup.sh \n" "$SERVICE_PATH"
    # shellcheck source=/dev/null
    # sh $SERVICE_PATH/startup.sh
    # sleep 10
fi

printf "=======================================================================================\n"
