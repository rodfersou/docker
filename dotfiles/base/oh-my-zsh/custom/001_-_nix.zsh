source $HOME/.nix-profile/etc/profile.d/nix.sh

if [[ "$WINDOW" == '1' ]]; then
    nix-env -i -f $HOME/.dotfiles/packages.nix &> /dev/null
fi
