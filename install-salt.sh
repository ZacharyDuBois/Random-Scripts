#!/usr/bin/env bash

################################################################################
# Salt Minion Installer.                                                       #
################################################################################
#                                                                              #
# This script is used to install the salt-minion and then tell it where the    #
# master is. It currently works with Ubuntu and Debian systems.                #
#                                                                              #
################################################################################
# TO RUN:                                                                      #
# - Download and host it somewhere.                                            #
# - Set the 'MASTERIP' to your SaltStack's master server.                      #
# - Run/Curl it on the system you need to install the minion                   #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
################################################################################MASTERIP='127.0.0.1'

apt-get update
echo 'deb http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest trusty main' > /etc/apt/sources.list.d/saltstack.list
curl https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub | sudo apt-key add -
apt-get update
apt-get install -y salt-minion
sed -i 's/#master: salt/master: '$MASTERIP'/g' /etc/salt/minion
service salt-minion restart

exit 0
