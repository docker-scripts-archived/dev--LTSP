#!/bin/bash -x
source settings.sh
NETWORK="$(echo $LAN_IP | cut -d'.' -f1-3)"
DEVICE=ltsptest01

help() {
    cat <<-_EOF
    
$0
This script creates virtual network adapter which can be used for bridging

Usage:
$0 [options]
Options:
    -h, --help  Display this help menu
    start       This option will create virtual adapter
    stop        This option will destory virtual adapter
    
_EOF
}

if [[ -z $(which sudo) ]]; then
    echo "Please install sudo first. For example see this tutorial:"
    echo "https://www.vultr.com/docs/how-to-use-sudo-on-debian-centos-and-freebsd"
    exit 1
fi

if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] ; then
    help
    exit 0
fi

case $1 in
    start )
        
        echo "creating virtual interface.."
        sudo modprobe dummy
        sudo ip link add ${DEVICE} type dummy
        sudo ip link set ${DEVICE} up
        sudo ip addr add ${NETWORK}.100/24 brd + dev ${DEVICE}
        sed -i settings.sh -e "/^LAN_IF/ c LAN_IF=\"${DEVICE}\"" 
        
        vagrant destroy -f
        cd dhcp
        vagrant destroy -f
        cd -
       
        if [ ${STANDALONE,,} != "yes" ] ; then
        	cd dhcp
        	vagrant up
        	cd -
        fi
        vagrant up && ./client.sh
        ;;	
    stop )
        
        echo "destroying virtual interface.."
        sudo ip addr del ${NETWORK}.100/24 brd + dev ${DEVICE}
        sudo ip link delete ${DEVICE} type dummy
        sed -i settings.sh -e '/^LAN_IF/ c LAN_IF="" '  
        sudo rmmod dummy
        
        VBoxManage controlvm ltsp-client poweroff 2>/dev/null
        sleep 0.5
        VBoxManage unregistervm ltsp-client --delete 2>/dev/null 
        
        vagrant halt
        vagrant destroy -f
        cd dhcp/
        vagrant destroy -f
        cd -
        ;;
    * )
        echo "error: invalid arguments provided"
        help
        ;;
esac 
