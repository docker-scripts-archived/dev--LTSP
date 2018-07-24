#!/bin/bash -x

# Credits:
#  - http://vstone.eu/reducing-vagrant-box-size/
#  - https://github.com/mitchellh/vagrant/issues/343
#  - https://github.com/chef/bento/blob/82752ec/packer/scripts/ubuntu/cleanup.sh

DU_BEFORE=$(df -h)

# delete all linux headers
dpkg --list | awk '{ print $2 }' | grep linux-headers | xargs apt-get -y purge

# removes old kernel packages
dpkg --list | awk '{ print $2 }' | grep 'linux-image-3.*-generic' | grep -v `uname -r` | xargs apt-get -y purge

# delete linux source
dpkg --list | awk '{ print $2 }' | grep linux-source | xargs apt-get -y purge

# delete development packages
dpkg --list | awk '{ print $2 }' | grep -- '-dev$' | xargs apt-get -y purge

# delete compilers and other development tools
apt-get -y purge cpp gcc g++

# delete obsolete networking, oddities
apt-get -y purge ppp pppconfig pppoeconf popularity-contest

# removing packages, libs, apt cache 
dpkg -l | grep -- '-dev' | xargs apt-get purge -y
apt-get -y autoremove --purge
apt-get -y clean
apt-get -y autoclean
apt-get purge -y locate

# removing index list. Note apt update will be required
rm -rf /var/lib/apt/lists/*

# whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
(( count-- ))
dd if=/dev/zero of=/tmp/whitespace bs=1024 count="${count}"
rm /tmp/whitespace

# whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
(( count-- ))
dd if=/dev/zero of=/boot/whitespace bs=1024 count="${count}"
rm /boot/whitespace

echo '==> Clear out swap and disable until reboot'
set +e
swapuuid=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
    2|0) ;;
    *) exit 1 ;;
esac
set -e
if [ "x${swapuuid}" != "x" ]; then
    # whiteout the swap partition to reduce box size
    swappart=$(readlink -f "/dev/disk/by-uuid/${swapuuid}")
    /sbin/swapoff "${swappart}"
    dd if=/dev/zero of="${swappart}" bs=1M || echo "dd exit code $? is suppressed"
    /sbin/mkswap -U "${swapuuid}" "${swappart}"
fi

# remove bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/vagrant/.bash_history

# removing logs
find /var/log -type f | while read f; do echo -ne '' > $f; done;

# zero out the free space to save space in the final image
# compressing effectively. fixing fragmentation issue
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

sync

echo '### Disk usage before cleanup ###'
echo "${DU_BEFORE}"

echo '### Disk usage after cleanup ###'
df -h

history -c
