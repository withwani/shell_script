#!/bin/bash
export LANG=ko_KR.UTF-8

# import source
# source stdlib.sh
source mon_stdlib.sh
# source mon_common.sh
source mon_settings.sh

SECONDS=0
print_info "Program started"

#set_log_level DEBUG

echo "======================================================================================="
echo "===== ACCESS INFORMATION"
echo "======================================================================================="

(($(sh ./mon_hw.sh))) || {
    print_header "Host Information"
    print_title "Host name: ${HOST_NAME}"
    print_title "Host address: ${HOST_ADDRESS}"
    print_header "Hardware Information"
    print_title "Model name: ${MODEL_NAME}"
    print_title "CPU core(s): ${CPU_CORES}"
    print_title "Total MEM: ${TOTAL_MEMORY}"
    print_title "Total DISK: ${TOTAL_DISK_SIZE}"
    print_header "Vendor Information"
    print_title "Kernel version: ${KERNEL_VERSION}"
}

#echo "======================================================================================="

# check mariadb
#./mon_mariadb.sh ${DB_ID} ${DB_PW}
./mon_mariadb.sh

# check tomcat
./mon_tomcat.sh

# check nodejs
./mon_nodejs.sh

# check solapi
./mon_solapi.sh

echo "======================================================================================="
print_info "Program finished, elapsed time = $SECONDS seconds"

exit 0
