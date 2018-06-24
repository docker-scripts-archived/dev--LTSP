#!/bin/bash

apt --yes update
apt --yes install build-essential fakeroot devscripts equivs

cd /vagrant/deps/source_package
echo y | mk-build-deps -i debian/control
dpkg-buildpackage -us -uc
dpkg -i ../debian-edu-preschool_15.12.5_amd64.deb
dpkg -i ../debian-edu-primary_15.12.5_amd64.deb
dpkg -i ../debian-edu-secondary_15.12.5_amd64.deb
dpkg -i ../debian-edu-tertiary_15.12.5_amd64.deb
apt --yes install -f
