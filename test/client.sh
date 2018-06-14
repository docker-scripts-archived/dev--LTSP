#!/bin/bash
#################################################
#  Simple script that creates LTSP clients      #
#  These clients can only boot from network     #
#  LTSP server is running before running script	#
#################################################

source settings.sh
ADAPTER=$(VBoxManage list hostonlyifs | grep -B 3 $NETWORK \
     | grep Name | cut -d':' -f2)

vmname=${1:-ltsp-client}

VBoxManage unregistervm $vmname --delete 2>/dev/null
VBoxManage createvm --name "${vmname}" --register
VBoxManage modifyvm "${vmname}" \
    --memory 1024 \
    --acpi on \
    --boot1 net \
    --nic1 hostonly \
    --hostonlyadapter1 $ADAPTER \
    --nicpromisc1 allow-all 
VBoxManage startvm "${vmname}"
