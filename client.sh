#!/bin/bash
#################################################
#  Simple script that creates LTSP clients      #
#  These clients can only boot from network     #
#  LTSP server is running before running script	#
#################################################

INTERFACE=$(ip route | grep -m 1 default | cut -d' ' -f5)

vmname=${1:-ltsp-client}

if [ $vmname == "ltsp-client" ]; then
    VBoxManage unregistervm $vmname --delete
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
