#!/bin/sh

set -e

TARGET_USER="nix-profile"
TARGET_HOME="/home/$TARGET_USER"
LOCKFILE="$HOME/.nix-setup-in-progress"
UID=$(id -u)
GID=$(id -g)

[ "$UID" = 0 ] && echo "This script does not support running as root." && exit 1

touch "$LOCKFILE"

# Add command to enter the Nix-managed profile
cat <<EOF | sudo tee /bin/enter-nix >/dev/null
#!/bin/sh
if [ -e $LOCKFILE ]; then
  echo "Waiting for Home Manager setup to finish (Ctrl+C to abort)..."
  while [ -e $LOCKFILE ]; do
    sleep 1 || return 1
  done
fi
sudo su nix-profile -- $TARGET_HOME/.activate-nix
EOF
sudo chmod +x /bin/enter-nix

# Create a fresh login name with the same UID
if ! id -u "$TARGET_USER" 2>/dev/null; then
  sudo useradd -p "!" -o -u "$UID" -g "$GID" -m -d "$TARGET_HOME" "$TARGET_USER"
fi

# Switch to the new login name
export USER=$TARGET_USER
export HOME=$TARGET_HOME

# Install Nix
if [ ! -d /nix ]; then
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh --no-daemon
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Install Home Manager config
nix run github:petm5/nix-config#homeConfigurations."vscode".activationPackage --extra-experimental-features "nix-command flakes" --accept-flake-config

# Activate shell on login
cat <<EOF > "$HOME/.activate-nix"
#!/bin/sh
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then . $HOME/.nix-profile/etc/profile.d/nix.sh; fi
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
export COLORTERM=truecolor
exec nu
EOF
chmod +x "$HOME/.activate-nix"

rm "$LOCKFILE"
