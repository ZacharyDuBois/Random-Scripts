#!/usr/bin/env bash

###
# ANL Mirror to PNL Mirror updater.
##
#
# This script is used to quickly change your Ubuntu mirrors to the PNL mirrors due to the ANL Mirrors shutting down Feb 1st, 2015.
#
# TO RUN:
# - Download and run as a normal script.
###

sudo sed -i 's/http:\/\/mirror.anl.gov\/pub\/ubuntu\//http:\/\/mirror.pnl.gov\/ubuntu\//g' /etc/apt/sources.list

sudo apt-get update

exit 0
