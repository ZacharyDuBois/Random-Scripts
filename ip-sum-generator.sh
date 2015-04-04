#!/usr/bin/env bash

###
# IP Sum Generator
##
#
# This script is being used for one of my upcoming projects. It essentially generates
# a file containing a list of IP sums.
# Thanks to @rascul for the IP generation script.
#
# TO RUN:
# - Download/Host somewhere.
# - Edit the saveLocation line with where you want to save to and edit sumCommands
#   with the commands you want it to generate the sum with.
# - Run (It will take awhile).
###
saveLocation="/home/user/Desktop/ipsum.txt"
sumCommands=({sha512sum,sha384sum,sha256sum,sha224sum,sha1sum,md5sum})


echo "Creating file..."
touch $saveLocation
echo "IP ${sumCommands[@]}" > $saveLocation


for first in {0..255}
do
  for second in {0..255}
  do
    for third in {0..255}
    do
      for fourth in {0..255}
      do
        ip="${first}.${second}.${third}.${fourth}"
        echo "Currently running: $ip"
        sums=()
        for command in ${sumCommands[@]}
        do
          sums+=($(echo "$ip" | ${command} | cut -d ' ' -f 1))
        done
        echo "$ip ${sums[@]}" >> $saveLocation
      done
    done
  done
done

echo "Done."

exit 0
