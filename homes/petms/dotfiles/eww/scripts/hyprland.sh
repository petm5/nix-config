#!/usr/bin/env bash

print_json() {
  echo "{\"workspaces\": $(hyprctl workspaces -j | jq -c 'sort_by(.id)'), \"active\": $(hyprctl monitors -j | jq '.[] | select(.focused) | .activeWorkspace.id')}"
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do print_json "$line"; done
