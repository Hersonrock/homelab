#!/usr/bin/env bash

while true; do
  TIMESTAMP=$(date '+%H:%M:%S')
  RESPONSE=$(curl -s --max-time 2 http://ubu-pc.lab/)
  if [ $? -eq 0 ]; then
	FRAGMENT=$(echo "$RESPONSE" |
    	sed -n '/<body>/,/<\/body>/p' |
    	sed 's/<[^>]*>//g' |
    	tr '\n' ' ')
    echo "$TIMESTAMP — OK — $FRAGMENT"
  else
    echo "$TIMESTAMP — FAILED"
  fi
  sleep 1
done
