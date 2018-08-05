#!/bin/bash -x
source settings.sh
NETWORK="$(echo $LAN_IP | cut -d'.' -f1-3)"
DISTRO="$(lsb_release -is)"
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

if [[ "$DISTRO" == "Ubuntu" ]] || [[ "$DISTRO" == "LinuxMint" ]] ; then
    use_sudo="sudo"
fi

if [[ "$use_sudo" == "" ]] && [[ "$EUID" != 0 ]] ; then
    echo "error: execute script as root user"
    exit 1
fi

case $1 in
    start )
        
        echo "creating virtual interface.."
        $use_sudo modprobe dummy
        $use_sudo ip link add ${DEVICE} type dummy
        $use_sudo ip link set ${DEVICE} up
        $use_sudo ip addr add ${NETWORK}.100/24 brd + dev ${DEVICE}
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
        $use_sudo ip addr del ${NETWORK}.100/24 brd + dev ${DEVICE}
        $use_sudo ip link delete ${DEVICE} type dummy  
        $use_sudo rmmod dummy
        sed -i settings.sh -e '/^LAN_IF/ c LAN_IF="" '
        
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
