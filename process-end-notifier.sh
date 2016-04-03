#!/usr/bin/env bash

################################################################################
# Process End Notifier                                                         #
################################################################################
#                                                                              #
# This script checks for when a process ends and then sends a Pushover alert   #
# to let you know.                                                             #
################################################################################
# TO RUN:                                                                      #
# - Download and change the settings to the right values. They are             #
#   self-explanatory.                                                          #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
# https://github.com/ZacharyDuBois/Random-Scripts/blob/master/LICENSE.md       #
################################################################################
processName=""
pushoverAppKey=""
pushoverUserKey=""
pushoverTitle="Process End Notifier"

# Done editing.

pushoverSend() {
  message=$1
  curl -s --form-string "token=$pushoverAppKey" --form-string "user=$pushoverUserKey" --form-string "priority=0" --form-string "title=$pushoverTitle" --form-string "message=$message" https://api.pushover.net/1/messages.json > /dev/null
  pushoverStatus=$?
  if [[ "$pushoverStatus" == 0 ]]; then
    echo "Pushover message sent successfully: $message"
  else
    echo "Pushover failed to send message: $message"
  fi
}

while pgrep "$processName" > /dev/null
do
  sleep 1
done

pushoverSend "The process $processName just finished."

exit 0
