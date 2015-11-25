#!/usr/bin/env bash

###
# Domain whois checker
##
#
# This script lets you run other scripts or commands when a domain's whois
#   information is updated/changed.
#
# TO RUN:
# - Download and change the settings to the right values. They are
#     self-explanitory.
# - Add to a cronjob or something.
###

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
