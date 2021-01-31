if [[ "$WINDOW" == '1' ]]; then
    (source $HOME/.nix-profile/etc/profile.d/nix.sh && nix-env -i -f $HOME/.dotfiles/packages.nix &> /dev/null)
fi
