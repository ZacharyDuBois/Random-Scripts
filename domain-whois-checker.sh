#!/usr/bin/env bash

################################################################################
# Domain WHOIS Checker                                                         #
################################################################################
#                                                                              #
# This script lets you run other scripts or commands when a domain's WHOIS     #
# information is updated/changed.                                              #
#                                                                              #
################################################################################
# TO RUN:                                                                      #
# - Download and change the settings to the right values. They are             #
#   self-explanatory.                                                          #
# - Add to a cronjob or something that will run it automatically at an         #
#   interval                                                                   #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
################################################################################

DOMAIN="zacharydubois.me"
LAST="last.txt"
CURRENT="current.txt"

whois $DOMAIN > $CURRENT

if [[ $(diff $LAST $CURRENT) == '' ]]
then
  echo "No change."
else
  echo "Change. Logged change."
  mv $LAST $LAST.$(date '+%Y-%m-%d-%H%M%S')
  # Any other commands when changes happen
fi

mv $CURRENT $LAST

exit 0
