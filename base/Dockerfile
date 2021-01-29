FROM nixos/nix:2.3.6
# ENV USER=user

COPY dotfiles .dotfiles
RUN apk add sudo \
            zsh \
    ##
    ## sudo
    ##
    && addgroup sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/sudo \
    # && echo "Set disable_coredump false" >> /etc/sudo.conf \
    #
    # ADD user
    #
    && adduser -D              \
               -s /bin/zsh     \
               -h /home/user   \
               -g "User"       \
               user            \
    && echo "user:user" | chpasswd \
    && addgroup user sudo \
    && chown -R user:user /srv \
    && cd /home/user \
    #
    # Nix
    #
    && nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs \
    && nix-channel --update \
    && sudo -u user --                 \
            nix-env -i curl            \
                       direnv          \
                       encfs           \
                       git             \
                       neovim          \
                       nss-cacert      \
                       openssh         \
                       rcm             \
                       screen          \
                       silver-searcher \
    #
    # ZSH
    #
    && { \
       echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'; \
       echo 'sed -e "/^plugins/ s/git/git wd globalias/" -i .zshrc'; \
    } | su user \
    ##
    ## VIM
    ##
    #&& { \
    #    echo 'git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime'; \
    #    echo 'sh .vim_runtime/install_awesome_vimrc.sh'; \
    #} | su user \
    #&& cd .vim_runtime/my_plugins \
    #&& { \
    #    echo 'git clone --depth=1 https://github.com/ervandew/supertab.git'; \
    #    echo 'git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git'; \
    #    echo 'git clone --depth=1 https://github.com/junegunn/vim-easy-align.git'; \
    #    #echo 'git clone --depth=1 https://github.com/neoclide/coc.nvim.git'; \
    #    #echo 'git clone --depth=1 https://github.com/aklt/plantuml-syntax.git'; \
    #} | su user \
    #&& cd /home/user \
    #
    # Dotfiles
    #
    && mv /.dotfiles . \
    && chown -R user:user .dotfiles \
    && sudo -u user -- ln -sf .dotfiles/rcrc .rcrc \
    && sudo -u user -- rcup

VOLUME /nix
USER user
WORKDIR /home/user
CMD ["screen", "-RRaADU"]
