#!/bin/bash

# source mon_stdlib.sh

dev=$(ip route show default | awk '/default/ {print $5}')
ip=$(ip -4 -o addr show $dev | awk '{print $4}')
mac=$(cat /sys/class/net/$dev/address)

echo $dev $ip $mac

exit 0
