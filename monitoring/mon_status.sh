#!/usr/bin/bash
# which bash

export LANG=ko_KR.UTF-8

MON_PATH=/script/mon_server

SECONDS=0
printf "Program started. date = %s\n" "($(date))"
# printf "##### CHECK %s STATUS ##### \n\n" "${SERVICE_NAME^^}"
printf "##### CHECK STATUS #################################################################\n\n"

# check hw
$MON_PATH/mon_hw.sh

# check apache2
$MON_PATH/mon_apache2.sh

# check mariadb
$MON_PATH/mon_mariadb.sh

# check solapi
$MON_PATH/mon_solapi.sh

# check tomcat
$MON_PATH/mon_tomcat.sh

printf "Program finished, elapsed time = %s seconds \n\n\n\n\n" "$SECONDS"
exit 0