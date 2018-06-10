#!/bin/bash
#################################################
#  Simple script that creates LTSP clients      #
#  These clients can only boot from network     #
#  LTSP server is running before running script	#
#################################################

INTERFACE=$(ip route | grep -m 1 default | cut -d' ' -f5)

if [ $# -eq 0 ]; then
    vmname="ltsp_client"
else    
    vmname=$1
fi

VBoxManage createvm --name "${vmname}" --register
VBoxManage modifyvm "${vmname}" \
    --memory 1024 \
    --acpi on \
    --boot1 net \
    --nic1 bridged \
    --bridgeadapter1 $INTERFACE \
    --nicpromisc1 allow-all 
VBoxManage startvm "${vmname}"
