trap 'echo got SIGINT' SIGINT

if [ ! -d $HOME/.dotfiles/crypt ]; then
    mkdir $HOME/.dotfiles/crypt
fi
sudo chmod 666 /dev/fuse

clear
while [ -z "$(ls -A $HOME/.dotfiles/crypt)" ]; do
    if [[ "$WINDOW" == '1' ]]; then
        encfs -s $HOME/.dotfiles/.crypt $HOME/.dotfiles/crypt
        clear
    else
        sleep 1
    fi
done
clear

for file in $(dirname $0)/001_-_encfs.d/*; do
    source "$file";
done
trap SIGINT
