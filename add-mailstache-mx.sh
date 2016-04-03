#!/usr/bin/env bash

################################################################################
# DigitalOcean Mailstache MX Adder.                                            #
################################################################################
#                                                                              #
# Use this to quickly add the Mailstache MX records to any domain on           #
# DigitalOcean.                                                                #
#                                                                              #
################################################################################
# Dependancices:                                                               #
# - DOCTL v1 or higher (You must be authenticated)                             #
################################################################################
# TO RUN:                                                                      #
# - Download it.                                                               #
# - Change the permissions 'chmod +x add-mailstache-mx.sh'.                    #
# - Run with './add-mailstache-mx.sh'.                                         #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
# https://github.com/ZacharyDuBois/Random-Scripts/blob/master/LICENSE.md       #
################################################################################

add=true
while [[ $add == true ]]
do
  doctl compute domain list --format 'Domain'
  read -p "Domain name: " -r domain
  doctl compute domain records create $domain --record-type 'MX' --record-data 'mx.mailstache.io.' --record-priority 1
  doctl compute domain records create $domain --record-type 'MX' --record-data 'mx2.mailstache.io.' --record-priority 5 --no-header
  doctl compute domain records create $domain --record-type 'MX' --record-data 'mx3.mailstache.io.' --record-priority 5 --no-header
  doctl compute domain records create $domain --record-type 'MX' --record-data 'mx4.mailstache.io.' --record-priority 10 --no-header
  doctl compute domain records create $domain --record-type 'MX' --record-data 'mx5.mailstache.io.' --record-priority 10 --no-header
  echo "Added Mailstache to $domain"
  read -p "Add another? [Y/n]: " -n 1 -r confirm
  echo
  if [[ ! $confirm =~ ^[Yy]$ ]]
  then
    add=false
  fi
done

exit 0
