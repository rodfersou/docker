if [ ! -d /nix/var ]; then
    BOOTSTRAP_NIX=1
    cp -R /.nix/* /nix
fi

source $HOME/.nix-profile/etc/profile.d/nix.sh

if [ $BOOTSTRAP_NIX ]; then
    nix-env -i -f $(dirname $0)/000_-_nix.nix
fi
