#!/usr/bin/bash
# which bash

export LANG=ko_KR.UTF-8

MON_PATH=/script/mon_server

SECONDS=0
printf "Program started. date = %s\n" "($(date))"
# printf "##### CHECK %s STATUS ##### \n\n" "${SERVICE_NAME^^}"
printf "##### CHECK STATUS #################################################################\n\n"

# check hw
$MON_PATH/mon-hw-ubuntu.sh

# check apache2
$MON_PATH/mon-apache2-ubuntu.sh

# check mariadb
$MON_PATH/mon-mariadb-ubuntu.sh

# check solapi
$MON_PATH/mon-solapi-ubuntu.sh

# check tomcat
$MON_PATH/mon-tomcat-ubuntu.sh

printf "Program finished, elapsed time = %s seconds \n\n\n\n\n" "$SECONDS"
exit 0
