trap 'echo got SIGINT' SIGINT

clear
while [ -z "$(ls -A $HOME/.dotfiles/crypt)" ]; do
    if [[ "$WINDOW" == '1' ]]; then
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
    else
        clear
        sleep 5
    fi
done
clear

trap SIGINT
