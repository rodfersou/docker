trap 'echo got SIGINT' SIGINT

source $HOME/.nix-profile/etc/profile.d/nix.sh

clear

if [[ "$WINDOW" == '1' ]]; then
    nix-env -i -f $HOME/.dotfiles/packages.nix
else
    sleep 1
fi
while [ $(ps -ef | grep nix-env | wc -l) = "2" ]; do
    sleep 1
done
clear

trap SIGINT
