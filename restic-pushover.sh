#!/usr/bin/env bash

################################################################################
# Restic Backup Notifier                                                       #
################################################################################
# This script notifies you when restic runs successfully or unsucessfully via  #
# Pushover.                                                                    #
################################################################################
# TO RUN:                                                                      #
# - Download and change the settings to the right values.                      #
# - You will need a Pushover user key and application key.                     #
# - You will need to have the restic repository password set in an enviromental#
#   variable. You can do so in this file via RESTIC_PASSWORD or                #
#   RESTIC_PASSWORD_FILE.                                                      #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
# https://github.com/ZacharyDuBois/Random-Scripts/blob/master/LICENSE.md       #
################################################################################

# !! Only pick one !!
export RESTIC_PASSWORD=""
#export RESTIC_PASSWORD_FILE=""

export RESTIC_REPOSITORY=""

# If you are using a cloud service, export the enviromental variables here as
# well. See:
# https://restic.readthedocs.io/en/stable/040_backup.html#environment-variables

pushoverAppKey=""
pushoverUserKey=""
# Restic backup command.
resticCmd="$(restic backup test-folder 2>&1)"

# Stop editing :)
resticExit=$?


pushoverSend() {
  message=$1

  curl -s --form-string "token=$pushoverAppKey" \
  --form-string "user=$pushoverUserKey"         \
  --form-string "priority=0"                    \
  --form-string "title=Restic Backup"           \
  --form-string "message=$message"              \
  --form-string "monospace=1"                   \
  https://api.pushover.net/1/messages.json > /dev/null

  pushoverStatus=$?
  if [[ "$pushoverStatus" == 0 ]]; then
    echo "Pushover message sent successfully: $message"
  else
    echo "Pushover failed to send message: $message"
  fi
}

if [[ $resticExit == 0 ]]
then
  summary=$(echo "$resticCmd" | sed -n '2,4p;5q')
  snapshot=$(echo "$resticCmd" | sed '7q;d')

  pushoverSend "Restic has backed up sucessfully!
$summary
$snapshot"
else
  pushoverSend "Restic failed to back up. Error:
$resticCmd"
fi
