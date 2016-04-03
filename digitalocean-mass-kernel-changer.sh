#!/usr/bin/env bash

################################################################################
# DigitalOcean Kernel Changer                                                  #
################################################################################
#                                                                              #
# This is a quick mass kernel changer for older OS' on DigitalOcean's          #
# infrastructure.                                                              #
#                                                                              #
################################################################################
# Dependancies:                                                                #
# - DOCTL v1 or higher. (You must be authenticated)                            #
################################################################################
# TO RUN:                                                                      #
# - Download and run as a normal script.                                       #
# - If you want to to force power down the droplet, change the value of        #
#   'forcePowerOff' to true. It is recommended you power down your droplets    #
#   from the command line/console.                                             #
################################################################################
# Made by Zachary DuBois. Licensed under MIT.                                  #
# https://zacharydubois.me                                                     #
################################################################################
forcePowerOff=false
disableASCIIArt=false
# Done editing :)


# Messages
fail="[$(tput setaf 1) FAIL $(tput sgr0)]"
ok="[$(tput setaf 2)  OK  $(tput sgr0)]"
running="[$(tput setaf 3)  **  $(tput sgr0)]"
notice="[$(tput setaf 3)NOTICE$(tput sgr0)]"
warn="[$(tput setaf 3) WARN $(tput sgr0)]"
info="[$(tput setaf 6) INFO $(tput sgr0)]"
finish="[$(tput setaf 4) DONE $(tput sgr0)]"

# echo ascii art
if [[ $disableASCIIArt == false ]]
then
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
fi
# Get list of droplets
echo "$running Getting droplet list..."
doctl compute droplet list --format ID,Image,Name,Region

droplets=()
add='yes'
while [[ $add == 'yes' ]]; do
  read -p "$running Droplet ID: " -r id
  droplets+=($id)
  check=false
  while [[ $check == false ]]; do
    read -p "$running Add another? [Y/n]: " -r confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
      add='yes'
      check=true
    elif [[ $confirm =~ ^[Nn]$ ]]; then
      add='no'
      check=true
      echo "$ok Droplets set."
    else
      check=false
      echo "$fail Unknwon option."
    fi
  done
done

# List kernels.
echo "$running Listing avalable kernels and their IDs for the first droplet."
doctl compute droplet kernels "${droplets[0]}" --format ID,Name,Version
read -p "$running Kernel ID: " -r kernelID
echo "$ok Selected kernel $kernelID."

# Check $forcePowerOff
if [[ $forcePowerOff == true ]]; then
  # Confirm the power off.
  echo "$warn You have selected to have this script power off your droplets. This is not recomened."
  check=false
  while [[ $check == false ]]; do
    read -p "$running Are you sure you want to continue? [Y/n]: " -r confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
      check=true
      echo "$ok Confirmed."
    elif [[ $confirm =~ ^[Nn]$ ]]; then
      echo "$fail You did not confirm. Please edit forcePowerOff to false if you do not want this."
      exit 1
    else
      check=false
      echo "$fail Unknown option."
    fi
  done

  # Power off the droplets.
  echo "$running Powering off droplets..."
  for droplet in "${droplets[@]}"; do
    # Only apply header to first droplet
    if [[ $droplet == "${droplet[${#droplets[@]}-1]}" ]]; then
      echo "$notice We will wait for the last droplet to power off."
      doctl compute droplet-action power-off "$droplet" --no-header --wait
    elif [[ $droplet == "${droplets[0]}" ]]; then
      doctl compute droplet-action power-off "$droplet" --format Status,Type,StartedAt,CompletedAt
    else
      doctl compute droplet-action power-off "$droplet" --no-header
    fi
  done

  echo "$ok Droplets powered off."
fi

# Confirm droplet
echo "$notice Please make sure all the droplets you listed are ready and off before confirming."
check=false
while [[ $check == false ]]; do
  read -p "$running Are they ready and off? [Y/n]: " -r confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    check=true
    echo "$ok Confirmed."
  elif [[ $confirm =~ ^[Nn]$ ]]; then
    check=false
    echo "$info Please encure they are off and ready. Confirm when they are."
  else
    check=false
    echo "$fail Unknown option."
  fi
done

# Change the kernels.
echo "$notice Begining kernel change."
for droplet in "${droplets[@]}"; do
  # Only apply header to first droplet
  if [[ $droplet == "${droplet[${#droplets[@]}-1]}" ]]; then
    echo "$notice We will wait for the last droplet to change."
    # tmp fix
    doctl compute droplet-action change-kernel "$droplet" --kernel-id "$kernelID" --wait
    #doctl compute droplet-action change-kernel $droplet --kernel-id $kernelID --no-header --wait
  elif [[ $droplet == "${droplets[0]}" ]]; then
    # tmp fix
    doctl compute droplet-action change-kernel "$droplet" --kernel-id "$kernelID"
    # DOCTL has a bug where change-kernel doesnt have header flags
    #doctl compute droplet-action change-kernel $droplet --kernel-id $kernelID --format Status,Type,StartedAt,CompletedAt
  else
    # tmp fix
    doctl compute droplet-action change-kernel "$droplet" --kernel-id "$kernelID"
    #doctl compute droplet-action change-kernel $droplet --kernel-id $kernelID --no-header
  fi
done

echo "$ok Kernels changed."

# Power them back on?
echo "$notice Would you like this script to power back on your droplets?"
check=false
while [[ $check == false ]]; do
  read -p "$notice Power them on? [Y/n]: " -r confirm
  if [[ $confirm =~ ^[Yy]$ ]]; then
    check=true
    echo "$running Powering on now."
    for droplet in "${droplets[@]}"; do
      # Only apply header to first droplet
      if [[ $droplet == "${droplet[${#droplets[@]}-1]}" ]]; then
        echo "$notice We will wait for the last droplet to power on."
        doctl compute droplet-action power-on "$droplet" --no-header --wait
      elif [[ $droplet == "${droplets[0]}" ]]; then
        doctl compute droplet-action power-on "$droplet" --format Status,Type,StartedAt,CompletedAt
      else
        doctl compute droplet-action power-on "$droplet" --no-header
      fi
    done
    echo "$ok Droplets started."
  elif [[ $confirm =~ ^[Nn]$ ]]; then
    check=true
    echo "$info We will not power back on your droplets."
  else
    check=false
    echo "$fail Unknown option."
  fi
done

# Done
echo
echo "$finish Enjoy the new kernel on your droplets."
exit 0
