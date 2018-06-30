#!/bin/bash

# Installing required packages
apt --yes install devscripts equivs

# Building debian-edu packages
cd /vagrant/deps/edudebian-meta-1.0
echo y | mk-build-deps -i debian/control
dpkg-buildpackage -us -uc

# Installing debian-edu packages with dependencies
dpkg -i ../debian-edu-*.deb
apt --yes install -f
