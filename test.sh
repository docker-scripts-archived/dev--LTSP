#!/bin/bash
source settings.sh
DEVICE=eth10

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

case "$1" in
    "start" )
        echo "creating virtual interface.."
        sudo modprobe dummy
        sudo ip link add ${DEVICE} type dummy
        sudo ip link set ${DEVICE} up
        sudo ip addr add ${NETWORK}.100/24 brd + dev ${DEVICE}
        echo "INTERFACE=\"${DEVICE}\"" >> settings.sh 
        ;;

    "stop" )
        echo "destroying virtual interface.."
        sudo ip addr del ${NETWORK}.100/24 brd + dev ${DEVICE}
        sudo ip link delete ${DEVICE} type dummy
        sed -i settings.sh -e "/^INTERFACE/ c \ " 
        sudo rmmod dummy
        ;;
    * )
        echo "error: invalid arguments provided"
        help
        ;;
esac    
