trap 'echo got SIGINT' SIGINT

clear
# not inside screen
if [[ -z "$STY" ]]; then
    while [ -z "$(ls -A $HOME/.dotfiles/crypt)" ]; do
        if [ ! -d $HOME/.dotfiles/crypt ]; then
            mkdir $HOME/.dotfiles/crypt
        fi
        sudo chmod 666 /dev/fuse
        clear

        encfs -s $HOME/.dotfiles/.crypt $HOME/.dotfiles/crypt
        clear

        rcdn
        rcup
        (cd $HOME/.ssh/ids && chmod 600 *)
        clear
    done
fi
clear

trap SIGINT
