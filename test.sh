#!/bin/bash
source settings.sh

help() {
    cat <<-_EOF
    
test.sh
This script creates virtual network adapter which can be used for bridging

Usage:
$0 [options]

Options:
    start   This option will create virtual adpater
    stop    This option will destory virtual adpater
    
_EOF
}

if [ "$#" == 0 ]; then
    echo "error: No arguments provided"
    help
    exit
fi

if [ "$1" == "start" ]; then
    echo "creating virtual interface.."
    sudo modprobe dummy
    sudo ip link add eth10 type dummy
    sudo ip link set eth10 up
    sudo ip addr add ${NETWORK}.100/24 brd + dev eth10
    echo 'INTERFACE="eth10"' >> settings.sh

elif [ "$1" == "stop" ]; then
    echo "destroying virtual interface.."
    sudo ip addr del ${NETWORK}.100/24 brd + dev eth10
    sudo ip link delete eth10 type dummy
    sudo rmmod dummy
    sed -i '$d' settings.sh   
else
    echo "error: invalid arguments provided"
    help
fi
    
