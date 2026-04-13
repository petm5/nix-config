#!/bin/bash

set -e

TARGET_USER="nix-profile"
TARGET_HOME="/home/$TARGET_USER"
LOCKFILE="$HOME/.nix-setup-in-progress"

touch "$LOCKFILE"

# Add command to enter the Nix-managed profile
cat <<EOF >> "$HOME/.bashrc"
alias "enter-nix=sudo su nix-profile"
EOF

# Create a fresh login name with the same UID
sudo useradd -p "!" -o -u "$UID" -m -d "$TARGET_HOME" "$TARGET_USER"

# Switch to the new login name
export USER=$TARGET_USER
export HOME=$TARGET_HOME

# Show message while setup is running
cat <<EOF >> "$HOME/.bashrc"
if [ -e "$LOCKFILE" ]; then
  echo "Waiting for Home Manager setup to finish..."
  while [ -e "$LOCKFILE" ]; do
    sleep 1
  done
  exec $0
fi
EOF

# Install Nix
if [ ! -d /nix ]; then
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Install Home Manager config
nix run github:petm5/nix-config#homeConfigurations."vscode".activationPackage --extra-experimental-features "nix-command flakes" --accept-flake-config

# Activate shell on login
cat <<EOF >> "$HOME/.bashrc"
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
export COLORTERM=truecolor
exec nu
EOF

rm "$LOCKFILE"
