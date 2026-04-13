#!/bin/bash

set -e

TARGET_USER="nix-profile"
TARGET_HOME="/home/$TARGET_USER"
LOCKFILE="$HOME/.nix-setup-in-progress"

touch "$LOCKFILE"

# Add command to enter the Nix-managed profile
cat <<EOF >> "$HOME/.bashrc"
enter-nix() {
  if [ -e $LOCKFILE ]; then
    echo "Waiting for Home Manager setup to finish (Ctrl+C to abort)..."
    while [ -e $LOCKFILE ]; do
      sleep 1 || return 1
    done
  fi
  sudo su nix-profile -- $TARGET_HOME/.activate-nix
}
EOF

# Create a fresh login name with the same UID
sudo useradd -p "!" -o -u "$UID" -m -d "$TARGET_HOME" "$TARGET_USER"

# Switch to the new login name
export USER=$TARGET_USER
export HOME=$TARGET_HOME

# Install Nix
if [ ! -d /nix ]; then
  sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Install Home Manager config
nix run github:petm5/nix-config#homeConfigurations."vscode".activationPackage --extra-experimental-features "nix-command flakes" --accept-flake-config

# Activate shell on login
cat <<EOF >> "$HOME/.activate-nix"
#!/bin/sh
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
export COLORTERM=truecolor
exec nu
EOF
chmod +x "$HOME/.activate-nix"

rm "$LOCKFILE"
