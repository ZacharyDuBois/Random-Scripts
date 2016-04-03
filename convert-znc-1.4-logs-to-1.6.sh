#!/usr/bin/env bash

################################################################################
# Converter for ZNC logs 1.4 to 1.6                                            #
################################################################################
#                                                                              #
# This is a quick script to edit all your ZNC logs to the new ZNC log path and #
# naming style in 1.6. Make sure to take a backup oh your logs when running.   #
# *** ZNC should not be running when you run this script ***                   #
#                                                                              #
################################################################################
# Caveats:                                                                     #
# This currently only works if the logs module was enabled by the user. If you #
# have it enabled as a global mod or network mod, this script *will not work*  #
# without some changes. Also, if you are using a custom logging format in ZNC, #
# this will not work.                                                          #
################################################################################
# TO RUN:                                                                      #
# - Download and run in the log directory.                                     #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
# https://github.com/ZacharyDuBois/Random-Scripts/blob/master/LICENSE.md       #
################################################################################
echo "Please make sure you have a backup of all your ZNC files before running this script!"
read -p "Do you have a backup? (Y/n): " -n 1 -r confirm
echo
if [[ ! $confirm =~ ^[Y]$ ]]
then
  echo "Please make a backup before running this script."
  exit 1
else
  echo "Moving on."
fi

if [[ "$(pgrep znc)" != "" ]]
then
  echo "I see ZNC may be running. Please make sure ZNC is not running when you run this script."
  read -p "Is ZNC running? (Y/n): " -n 1 -r confirm
  echo
  if [[ $confirm =~ ^[Y]$ ]]
  then
    echo "Please stop ZNC before running this script. It could cause ZNC to crash. To stop ZNC, run /znc shutdown in IRC."
    exit 1
  elif [[ $confirm =~ ^[n]$ ]]
  then
    echo "Moving on."
  else
    echo "Invalid response."
    exit 1
  fi
else
  echo "Please make sure ZNC is not running. This script will start moving files in 5 seconds."
  sleep 5
fi

startTime=$(date +%s)
i=0
for log in *.log
do
  echo "Processing $log..."
  logNetwork=$(echo "${log%%_*}" | tr '[:upper:]' '[:lower:]')

  logChannel=${log%_*}
  logChannel="$(echo "${logChannel#*_}" | tr '[:upper:]' '[:lower:]')"

  logDate=${log%.*}
  logDate=${logDate##*_}
  logNewDate="${logDate::4}-${logDate:4:2}-${logDate:6:2}"

  if [[ ! -d "$logNetwork" ]]
  then
    echo "Directory for network $logNetwork does not exist. Creating it for you."
    mkdir "$logNetwork"
  fi

  if [[ ! -d "$logNetwork/$logChannel" ]]
  then
    echo "Directory for channel $logChannel does not exist. Creating it for you."
    mkdir "$logNetwork/$logChannel"
  fi

  if [[ ! -f "$logNetwork/$logChannel/$logNewDate.log" ]]
  then
    mv "$log" "$logNetwork/$logChannel/$logNewDate.log"
  else
    echo "Log conflict for $log. Merging files."
    mv "$logNetwork/$logChannel/$logNewDate.log" "$logNetwork/$logChannel/$logNewDate.log.conflict"
    cat "$log" "$logNetwork/$logChannel/$logNewDate.log.conflict" > "$logNetwork/$logChannel/$logNewDate.log"
    rm "$log" "$logNetwork/$logChannel/$logNewDate.log.conflict"
  fi

  i=$(($i+1))
done
endTime=$(date +%s)

echo "Processed $i logs in $(($endTime - $startTime)) seconds."
echo "Your ZNC logs are now in ZNC 1.6 format. Enjoy!"
