trap 'echo got SIGINT' SIGINT

export NIXPKGS_ALLOW_UNFREE=1
source $HOME/.nix-profile/etc/profile.d/nix.sh

clear

# not inside screen
if [[ -z "$STY" ]]; then
    nix-env -if $HOME/.dotfiles/packages.nix
    while [ $(ps -ef | grep nix-env | wc -l) = "2" ]; do
        sleep 1
    done
fi
clear

trap SIGINT
