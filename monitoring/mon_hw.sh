#!/bin/bash
export LANG=ko_KR.UTF-8

# import source
# source stdlib.sh
# source mon_stdlib.sh
# source mon_settings.sh

scmd0=$(hostname)

# Hardware total info
# scmd1=$(lscpu | egrep "Architecture|^Thread|^Core|^Socket|^CPU|^Model name")
scmd1=$(lscpu | grep "Model name" | tr -d ' ')

# CPU info
scmd2=$(grep 'physical id' /proc/cpuinfo | sort -u | wc -l)
scmd3=$(grep 'cpu cores' /proc/cpuinfo | tail -1 | cut -d ":" -f2 | tr -d ' ')
scmd4=$(grep ^processor /proc/cpuinfo | wc -l)

# Memory info
scmd5=$(cat /proc/meminfo | grep MemTotal | tr -d ' ')

# Vendor info
scmd6=$(sudo cat /sys/class/dmi/id/board_vendor)
scmd7=$(sudo cat /sys/class/dmi/id/product_name)
scmd8=$(sudo cat /sys/class/dmi/id/product_serial)
scmd9=$(sudo cat /sys/class/dmi/id/bios_version)

# Storage info
scmd10=$(df -P | grep -v ^Filesystem | awk '{sum += $2} END {print sum/1024/1024 "GB"}')

# Network info
scmd11=$(uname -r)
scmda=$(hostname -I | tr ' ' '/')
# scmdb=`cat /etc/redhat-release`

if [ -n ${HOST_NAME} ]; then
    # already exists
    $(sed -i "/Auto-generated/d" mon_settings.sh)
    # print_header "Host Information"
    $(sed -i "/HOST_NAME/d" mon_settings.sh)
    $(sed -i "/HOST_ADDRESS/d" mon_settings.sh)
    # print_header "Hardware Information"
    $(sed -i "/MODEL_NAME/d" mon_settings.sh)
    $(sed -i "/CPU_CORES/d" mon_settings.sh)
    $(sed -i "/TOTAL_MEMORY/d" mon_settings.sh)
    $(sed -i "/TOTAL_DISK_SIZE/d" mon_settings.sh)
    # print_header "Vendor Information"
    $(sed -i "/KERNEL_VERSION/d" mon_settings.sh)
fi

# print_header "Host Information"
echo "##### Auto-generated, DO NOT EDIT BELOWS #####" >>mon_settings.sh
echo "export HOST_NAME=${scmd0}" >>mon_settings.sh
echo "export HOST_ADDRESS=${scmda}" >>mon_settings.sh
# print_header "Hardware Information"
echo "export MODEL_NAME=${scmd1#*@}" >>mon_settings.sh
echo "export CPU_CORES=${scmd3#*:}" >>mon_settings.sh
echo "export TOTAL_MEMORY=${scmd5#*:}" >>mon_settings.sh
echo "export TOTAL_DISK_SIZE=${scmd10}" >>mon_settings.sh
# print_header "Vendor Information"
echo "export KERNEL_VERSION=${scmd11}" >>mon_settings.sh

exit 0
