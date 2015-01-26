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
MASTERIP='127.0.0.1'

apt-get update
apt-get install -y python-software-properties
add-apt-repository -y ppa:saltstack/salt
apt-get update
apt-get install -y salt-minion
sed -i 's/#master: salt/master: '$MASTERIP'/g' /etc/salt/minion
service salt-minion restart

exit 0
