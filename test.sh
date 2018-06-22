#!/bin/bash
source settings.sh
DEVICE=ltsptest01

help() {
    cat <<-_EOF
    
$0
This script creates virtual network adapter which can be used for bridging

Usage:
$0 [options]

Options:
    start   This option will create virtual adapter
    stop    This option will destory virtual adapter
    
_EOF
}

if [[ $UID != 0 ]]; then
	echo "error: use sudo or run script as root user"
	exit 1
fi

case $1 in
    start )
        echo "creating virtual interface.."
        modprobe dummy
        ip link add ${DEVICE} type dummy
        ip link set ${DEVICE} up
        ip addr add ${NETWORK}.100/24 brd + dev ${DEVICE}
        sed -i settings.sh -e "/^INTERFACE/ c INTERFACE=\"${DEVICE}\"" 
        ;;	
    stop )
        echo "destroying virtual interface.."
        ip addr del ${NETWORK}.100/24 brd + dev ${DEVICE}
        ip link delete ${DEVICE} type dummy
        sed -i settings.sh -e '/^INTERFACE/ c INTERFACE="" '  
        rmmod dummy
        ;;
    * )
        echo "error: invalid arguments provided"
        help
        ;;
esac    
