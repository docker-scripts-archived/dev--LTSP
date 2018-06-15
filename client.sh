#!/bin/bash
#################################################
#  Simple script that creates LTSP clients      #
#  These clients can only boot from network     #
#  LTSP server is running before running script	#
#################################################

source settings.sh

if [ $TYPE == 'bridge' ]; then    
    INTERFACE=$(ip route | grep -m 1 default | cut -d' ' -f5)
    nic='bridged'
    adapter='bridgeadapter1'
else
    INTERFACE=$(VBoxManage list hostonlyifs | grep -B 3 $NETWORK \
        | grep Name | cut -d':' -f2)
    nic='hostonly'
    adapter='hostonlyadapter1'
fi    
    
vmname=${1:-ltsp-client}

VBoxManage unregistervm $vmname --delete 2>/dev/null
VBoxManage createvm --name "${vmname}" --register
VBoxManage modifyvm "${vmname}" \
    --memory 1024 \
    --acpi on \
    --boot1 net \
    --nic1 $nic \
    --$adapter $INTERFACE \
    --nicpromisc1 allow-all 
VBoxManage startvm "${vmname}"
