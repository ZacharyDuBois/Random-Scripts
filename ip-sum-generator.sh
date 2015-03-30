#!/bin/bash

###
# IP Sum Generator
##
#
# This script is being used for one of my upcoming projects. It essentially generates
# a file containing a list of IP sums.
#
# TO RUN:
# - Download/Host somewhere.
# - Edit the saveLocation line with where you want to save to and edit sumCommands
#   with the commands you want it to generate the sum with. ips is the range of
#   addresses that you want to generate.
# - Run (It will take awhile).
###
saveLocation="/home/user/Desktop/ipsum.txt"
sumCommands=({sha512sum,sha384sum,sha256sum,sha224sum,sha1sum,md5sum})
ips=({0..255}.{0..255}.{0..255}.{0..255})


echo "Creating file..."
touch $saveLocation
echo "IP ${sumCommands[@]}" > $saveLocation

for ip in ${ips[@]}
do
  echo "Currently running: $ip"
  sums=()
  for command in ${sumCommands[@]}
  do
    sums+=(echo $("$ip" | $($command) | awk -F' ' '{ print $1 }'))
  done
  echo "$ip ${sums[@]}" >> $saveLocation
done

echo "Done."

exit 0
