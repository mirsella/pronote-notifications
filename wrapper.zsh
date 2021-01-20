#!/bin/zsh
cd /home/mirsella/pronote-notifications
messages=$(node index.js)
last=$(cat last.json)
lasttime=$(jq '.last' <<< $last)
((lasttime++))

nMessages=$(jq -j '.informations, .discussions, .others' <<< $messages)
nLast$(jq -j '.informations, .discussions, .others' <<< $last)

if ! grep -q '000' <<< $nMessages; then 
  if [ $lasttime > 36 ]; then
    notif "Still Got Notifications ! $nMessages"
  elif grep -q '000' <<< nLast; then 
    notif "New Notifications ! $nLast"
  fi
else 
  lasttime=0
fi

jq ". + {last: $lasttime}" <<< $last > last.json

