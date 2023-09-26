#!/usr/bin/bash
# which bash

# TARGET_PATH=$(dirname "$0")/logs
# LOG_PATH=$(dirname "$0")/logs/old
TARGET_PATH=/home/busmon/war/commuteBus/logs
LOG_PATH=/home/busmon/war/commuteBus/logs/old

# delete logs passed 30 days
printf "#################### %s delete log list ###########################" "$(date)" >>"$LOG_PATH"/deleteOldLog.log
find "$TARGET_PATH" -mtime +30 -type f -ls >>"$LOG_PATH"/deleteOldLog.log
find "$TARGET_PATH" -mtime +30 -type f -ls -exec rm -r {} \;
