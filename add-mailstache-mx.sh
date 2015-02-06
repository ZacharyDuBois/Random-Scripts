#!/bin/bash

###
# DigitalOcean Mailstache MX Adder.
##
#
# Use this to quickly add the Mailstache MX records to any domain on DigitalOcean.
#
# TO RUN:
# - Download it.
# - Edit 'auth' to the correct DigitalOcean APIv2 key with write access.
# - Change the permissions 'chmod +x add-mailstache-mx.sh'.
# - Run with './add-mailstache-mx.sh'.
###
auth="YOURAPIV2KEYHERE"


echo -n "Domain name: "
read domain
curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $auth" -d '{"type":"MX","data":"mx.mailstache.io.","priority":1}' "https://api.digitalocean.com/v2/domains/$domain/records" > /dev/null
curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $auth" -d '{"type":"MX","data":"mx2.mailstache.io.","priority":5}' "https://api.digitalocean.com/v2/domains/$domain/records" > /dev/null
curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $auth" -d '{"type":"MX","data":"mx3.mailstache.io.","priority":5}' "https://api.digitalocean.com/v2/domains/$domain/records" > /dev/null
curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $auth" -d '{"type":"MX","data":"mx4.mailstache.io.","priority":10}' "https://api.digitalocean.com/v2/domains/$domain/records" > /dev/null
curl -s -X POST -H 'Content-Type: application/json' -H "Authorization: Bearer $auth" -d '{"type":"MX","data":"mx5.mailstache.io.","priority":10}' "https://api.digitalocean.com/v2/domains/$domain/records" > /dev/null
echo "Added Mailstache to $domain"
exit 0
