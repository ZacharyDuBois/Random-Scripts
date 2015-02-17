#!/bin/bash

###
# DigitalOcean Kernel Changer.
##
#
# Use this to quickly change your Droplet's kernel on DigitalOcean.
# The IDs needed for the configuration can be found using the API.
# https://developers.digitalocean.com/
#
# TO RUN:
# - Download it.
# - Edit 'kernelID' to the correct DigitalOcean kernel ID that you want to change.
# - Edit 'dropletIDs' to an array of droplet IDs you want to update (Save it for later. Once you
#     make a list once, you won't need to again :P ).
# - Edit 'apiKey' with a DigitalOcean APIv2 key with write access.
# - Edit 'forcePowerOff' to true if you want this script to also poweroff your droplets. Note that
#     this is not recommned because this will force a poweroff. If you have SaltStack, run
#     `salt '*' system.poweroff` and it will willingly shutdown all your droplets that are connected.
# - Make sure your droplets are off unless you are having this script do that, then run.
###
kernelID=""
dropletIDs=({000000,111111,222222})
apiKey=""
forcePowerOff=false

# Done editing :)


# Messages
fail="[$(tput setaf 1) FAIL $(tput sgr0)]"
ok="[$(tput setaf 2)  OK  $(tput sgr0)]"
running="[$(tput setaf 3)  **  $(tput sgr0)]"
notice="[$(tput setaf 3)NOTICE$(tput sgr0)]"
warn="[$(tput setaf 3) WARN $(tput sgr0)]"
info="[$(tput setaf 6) INFO $(tput sgr0)]"
finish="[$(tput setaf 4) DONE $(tput sgr0)]"


# Check settings
if [[ $apiKey == "" ]] || [[ $kernelID == "" ]]
then
  echo "$fail Please correct the settings."
  exit 1
else
  echo "$info Settings are set. Moving on."
fi

# Check $forcePowerOff
if [[ $forcePowerOff == true ]]
then
  # Confirm the power off.
  echo "$warn You have selected to have this script shutdown your Droplets. This is not recomened."
  read -p "$warn Are you sure? (Y/n): " -n 1 -r confirm
  echo
  if [[ ! $confirm =~ ^[Y]$ ]]
  then
    echo "$fail You did not confirm. Please edit forcePowerOff to false."
    exit 1
  else
    echo "$ok Confirmed. Powering them off now."
  fi

  # Power off the droplets.
  for droplet in ${dropletIDs[@]}
  do
    echo "$running Powering off Droplet $droplet now."
    curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $apiKey" -d '{"type":"shutdown"}' "https://api.digitalocean.com/v2/droplets/$droplet/actions" > /dev/null
  done

  echo "$ok Sent poweroff requests to Droplets."
  echo "$info Giving 60 seconds for Droplets to shutdown."
  sleep 60
fi

echo "$ok Changing kernels."

# Confirm droplet
echo "$notice Please make sure all the Droplets you listed are ready and off before confirming."
read -p "$notice Are they ready and off? (Y/n): " -n 1 -r confirm
echo
if [[ ! $confirm =~ ^[Y]$ ]]
then
  echo "$fail Exiting. Run again when you are ready."
  exit 1
else
  echo "$ok Confirmed. Moving on."
fi

# Confirm kernel ID.
echo "$warn Please make sure that $kernelID is the kernel you wanted."
read -p "$warn Is $kernelID correct? (Y/n): " -n 1 -r confirm
echo
if [[ ! $confirm =~ ^[Y]$ ]]
then
  echo "$fail Exiting. Please check the kernel you provided."
  exit 1
else
  echo "$ok Confirmed. Changing kernels now."
fi

# Change the kernels.
for droplet in ${dropletIDs[@]}
do
  echo "$running changing kernel of Droplet $droplet to $kernelID now."
  curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $apiKey" -d "{\"type\":\"change_kernel\",\"kernel\":$kernelID}" "https://api.digitalocean.com/v2/droplets/$droplet/actions" > /dev/null
done

# Let them change
echo "$info Giving 10 seconds for kernels to change."
sleep 10

# Power them back on?
echo "$notice Would you like this script to power back on your Droplets?"
read -p "$notice Power them on? (Y/n): " -n 1 -r confirm
echo
if [[ $confirm =~ ^[Y]$ ]]
then
  echo "$ok Powering them on now."
  for droplet in ${dropletIDs[@]}
  do
    echo "$running Powering on Droplet $droplet now."
    curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $apiKey" -d '{"type":"power_on"}' "https://api.digitalocean.com/v2/droplets/$droplet/actions" > /dev/null
  done
  echo "$ok Droplets were queued to start."
fi
echo
echo
echo

sleep 1

echo '                                 `-:/+osssoo+/:.                                                    '
echo '                              `-+oosssssssssssyys+-                                                 '
echo '                            `:+oooooo//:::/+osyyyyyo-    .......`                                   '
echo '                           ./++oo+/:---.`    `-/syyyy+`  ://////-                                   '
echo '                          ./++++oo+/::-----.    `:++++:  ://////-                                   '
echo '                         `//++++:`                -::::: ://////-                                   '
echo '                      `` :++++/`                  -/////`.------.....`   `....                      '
echo '                  .:/+++`/++++`                   -/////`        :///.   -sss+                      '
echo '                -+oooooo./ooo:                    ``````         -:::`   -ooo+                      '
echo '              `+ssso+/-.``-:/-                                            ````/ooooooo              '
echo '             `ossso-`                                      `````    ....      +sssssss              '
echo '             :ssso```                                      oooo:   `////      +sssssss              '
echo '             +sss/ /.                                      osss/   `::::````` /ooooooo              '
echo '             :sss+ o:                                      `````    ````/ooo+ ````````              '
echo '             `syys:+s-      `.--:::/:::-..`                             +ssso         `             '
echo '              .oyysoss:`.-/osssyyyyyyyyyysoo+:-``                       `....       `-              '
echo '               `/oys+/+ossoo+/::::::/+oossyyyyyso+/-.`  `..```          ``..      `-:               '
echo '                 `:/++/--..----------....-:/oosyyyyysso/-....--------:::--`   `.://.                '
echo '                 `-...--:::-----------:::::-----:/+ossyyyyso+/:------......:/+++:`                  '
echo '                  `````                   ```.....```..-:/++oossooo+++++++/:-.`                     '
echo '                                                  ```         `````````                             '
echo '                                                                                                    '
echo '               ``           ``                 ``       ``                                          '
echo ' /+++++++/-`  :oo.         :oo. `-`           `oo-  `:/+oo++:.                                      '
echo ' +ss....:+so- ./:`         ./:` +s-           `ss- :os+:---/os+`                                    '
echo ' +ss      /ss.-// `:/++/:::-//./ss+// .:/++/. `ss-:ss:      `oso `-/++/:``:/++/:` `:/++/:` :/::/+/:`'
echo ' +ss      .ss/:ss os/..oso./so`-ss/-. ::-.-ss-`ss-oso        /ss:os+..-:-os/../so`./-..+s+ +so-.-os/'
echo ' +ss      -ss::ss os:..+s: /so `ss-   `-://ss/`ss-+ss.       +ss+so     /ss++++oo.`-://+ss +s+   +s+'
echo ' +ss    `-os+ :ss -so//:.  /so `ss-  -ss-.`os/`ss-`oso-`   ./ss::ss.    :ss.   ` `os/../ss +s+   +s+'
echo ' +ss+++oos+-  :ss /soo+++:`:so  oso//:ss//oos/`ss- `:ossoooss/.  /ss+/+o-:os+/+o+.os+/+oss +s+   +s+'
echo ' ........`    `..-so```.os/`..   .-.` `--. `.` ..`    `.--..       .--.    .--.`  `.--` .. `..   `.`'
echo '                 .+so++oo/`                                                                         '
echo
echo
echo "$finish Enjoy the new kernel on your Droplets :)"
exit 0
