#!/bin/bash

###
# Salt Minion Installer.
##
#
# This script is used to install the salt-minion and then tell it where the master is. It currently works with Ubuntu.
#
# TO RUN:
# - Download/Host somewhere.
# - Edit the MASTERIP line with the IP of your salt master.
# - Run.
###

apt-get update
apt-get install -y python-software-properties
add-apt-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion
sed -i 's/#master: salt/master: 10.132.253.109/g' /etc/salt/minion
service salt-minion restart

exit 0
