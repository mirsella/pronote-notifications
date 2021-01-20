#!/bin/zsh
cd /home/mirsella/pronote-notifications
messages=$(node index.js)
[ ! -f last.json ] && echo '{ "discussions": 0, "others": 0, "informations": 0, "last": 0 }' > last.json
last=$(cat last.json)
lasttime=$(jq '.last' <<< $last)
((lasttime++))

nMessages=$(jq -j '.informations, .discussions, .others' <<< $messages)
nLast=$(jq -j '.informations, .discussions, .others' <<< $last)

if ! grep -q '000' <<< $nMessages; then 
  if [ $lasttime -gt 36 ]; then
    notif "Still Got Notifications ! $nMessages"
  elif grep -q '000' <<< $nLast; then 
    notif "New Notifications ! $nLast"
  fi
else 
  lasttime=0
fi

jq ". + {last: $lasttime}" <<< $messages > last.json
