#!/bin/bash

set -e

[ -d /nix ] || sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon

. "$HOME/.nix-profile/etc/profile.d/nix.sh"

nix run github:petm5/nix-config#homeConfigurations."vscode".activationPackage

cat <<EOF >> ~/.bashrc
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
. "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
export COLORTERM=truecolor
exec nu
EOF
