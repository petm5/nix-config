#!/bin/sh

nix run github:petm5/nix-config#homeConfigurations."vscode".activationPackage

cat <<EOF >> ~/.bashrc
if [ -d "$HOME/.nix-profile" ]; then
    . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
fi
export COLORTERM=truecolor
exec nu
EOF
