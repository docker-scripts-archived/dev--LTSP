#!/bin/bash -x

# Installing required packages
echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
apt --yes update
apt --yes install devscripts equivs
apt -t stretch-backports install debhelper --yes

# Building debian-edu packages
cd /vagrant/edu-packages/edudebian-meta
echo y | mk-build-deps -i debian/control
dpkg-buildpackage -us -uc

# Installing debian-edu packages with dependencies
dpkg -i ../debian-edu-*.deb
apt --yes install -f
