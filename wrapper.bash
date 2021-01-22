#!/bin/bash
cd /home/mirsella/pronote-notifications
messages=$(node index.js || notif 'error pronote-notifications')
# if ! grep -q '^.*$' last.json; then
if [ ! "$(jq -j '. | length' last.json)" == "4" ]; then
  echo '{ "discussions": 0, "others": 0, "informations": 0, "last": 0 }' > last.json; 
fi
last=$(cat last.json)
count=$(jq '.last' <<< $last)
((count++))

nMessages=$(jq -j '.informations, .discussions, .others' <<< $messages)
nLast=$(jq -j '.informations, .discussions, .others' <<< $last)

if ! grep -q '000' <<< $nMessages; then 
  if bc -l <<< "$count/16" | grep -q '^[0-9]*\.*00000000000000000000$'; then
    notif "Still Got Notifications ! $nMessages"
  elif grep -q '000' <<< $nLast; then 
    notif "New Notifications ! $nMessages"
  elif [ $nMessages -gt $nLast ]; then 
    notif "Even More Notifications ! $nMessages"
  fi
else 
  count=0
fi

jq ". + {last: $count}" <<< $messages > last.json
