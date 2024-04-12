#!/bin/sh

bat=/sys/class/power_supply/BAT1/
bat_status="$(cat "$bat/status")"
per="$(cat "$bat/capacity")"

icon() {
  if [ "$per" -gt "95" ]; then
    icon=$( [[ $bat_status == "Charging" ]] || [[ $bat_status == "Full" ]] && echo "" || echo "" )
  elif [ "$per" -gt "75" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  elif [ "$per" -gt "60" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  elif [ "$per" -gt "45" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  elif [ "$per" -gt "30" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  elif [ "$per" -gt "15" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  elif [ "$per" -gt "5" ]; then
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  else
    icon=$( [[ $bat_status == "Charging" ]] && echo "" || echo "" )
  fi
    echo "$icon"
}

percent() {
  echo "$per"
}

echo "{ \"icon\": \"$(icon)\", \"level\": \"$(percent)\" }"

exit
