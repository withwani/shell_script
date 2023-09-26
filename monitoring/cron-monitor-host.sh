#!/usr/bin/bash
# which bash

# Transfer some command from Host to Docker conatianer for cronjob

CON_ID=$(docker ps -aqf 'name=commuteBus')
CON_PATH=/script/mon_server

printf "CONTAINER_ID=%s \n" "$CON_ID"
printf "CONTAINER_PATH=%s \n" "$CON_PATH"

TODAY=$(date)

printf "[%s] docker exec %s sh %s/bin/mon-status-ubuntu.sh \n" "$TODAY" "$CON_ID" "$CON_PATH"
docker exec "$CON_ID" sh "$CON_PATH/mon-status-ubuntu.sh"

printf "process was done(result: %d). \n\n" "$?"
