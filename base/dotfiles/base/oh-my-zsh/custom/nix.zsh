if [ ! -d /nix/var ]; then
    cp -R /.nix/var /nix/var
fi

if [ ! -d /nix/store ]; then
    mkdir /nix/store
    ln -sf /.nix/store/* /nix/store/
fi

source /home/devuser/.nix-profile/etc/profile.d/nix.sh
