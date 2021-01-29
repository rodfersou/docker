# trap 'echo got SIGINT' SIGINT

if [[ "$WINDOW" == '1' ]]; then
    if [ ! -d /nix/var ]; then
        BOOTSTRAP_NIX=1
        cp -R /.nix/var /nix/var
        mkdir /nix/store
        ln -sf /.nix/store/* /nix/store/
    fi

    source $HOME/.nix-profile/etc/profile.d/nix.sh

    if [ $BOOTSTRAP_NIX ]; then
        nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
        nix-channel --update
        nix-env -i -f $(dirname $0)/000_-_nix.nix
        read
    fi
fi

# trap SIGINT
