#!/bin/bash
cd /home/mirsella/pronote-notifications
messages=$(node index.js)
if [ ! "$(jq -j '. | length' last.json)" == "4" ]; then
  echo '{ "discussions": 0, "others": 0, "informations": 0, "last": 0 }' > last.json; 
fi
last=$(cat last.json)
count=$(jq '.last' <<< $last)
((count++))

nMessages=$(jq -j '.informations, .discussions, .others' <<< $messages)
nLast=$(jq -j '.informations, .discussions, .others' <<< $last)

echo "$nMessages $messages
$nLast $last" > log.txt


if ! grep -q '000' <<< $nMessages; then 
  if grep -q '000' <<< $nLast; then 
    notif "New Notifications ! $nMessages"
  elif bc -l <<< "$count/10" | grep -q '^[0-9]*\.*00000000000000000000$'; then
    notif "Still Got Notifications ! $nMessages"
  elif [ $nMessages -gt $nLast ]; then 
    notif "Even More Notifications ! $nMessages"
  else
    echo 'got notif, waiting to send a new push notif'
  fi
else 
  count=0
fi

jq ". + {last: $count}" <<< $messages > last.json
