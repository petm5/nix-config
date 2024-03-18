#!/usr/bin/env bash
per=$(brightnessctl | awk '/Current/ {print $4}' | tr -d '()%')

icon() {
  if [ "$per" -gt "65" ]; then
    icon=""
  elif [ "$per" -gt "50" ]; then
    icon=""
  elif [ "$per" -gt "30" ]; then
    icon=""
  elif [ "$per" -gt "18" ]; then
    icon=""
  elif [ "$per" -gt "10" ]; then
    icon=""
  elif [ "$per" -gt "1" ]; then
    icon=""
  else
    icon=""
  fi
  echo "$icon"
}

percent() {
  echo "$per"
}

echo "{ \"icon\": \"$(icon)\", \"level\": \"$(percent)\" }"

exit
