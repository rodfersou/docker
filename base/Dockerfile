FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ENV USER=user

COPY dotfiles .dotfiles
RUN sed -e '/^# deb-src/ s/# //' -i /etc/apt/sources.list \
    && apt-get update \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get install -y --no-install-recommends \
               build-essential   \
               ca-certificates   \
               curl              \
               direnv            \
               encfs             \
               git               \
               locales           \
               ncurses-term      \
               neovim            \
               rcm               \
               screen            \
               silversearcher-ag \
               ssh               \
               sudo              \
               tmux              \
               xz-utils          \
               zsh               \
    && locale-gen en_US.UTF-8  \
    #
    # sudo
    #
    && sed -e '/^\%sudo/ s/\ ALL$/\ NOPASSWD:ALL/' -i /etc/sudoers \
    # && echo "Set disable_coredump false" >> /etc/sudo.conf \
    #
    # ADD user
    #
    && adduser --quiet              \
               --disabled-password  \
               --shell /usr/bin/zsh \
               --home /home/user \
               --gecos "User"       \
               user              \
    && echo "user:user" | chpasswd \
    && usermod -aG sudo user \
    && chown -R user:user /srv \
    && cd /home/user \
    #
    # ZSH
    #
    && { \
        echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'; \
        # echo 'sed -e "/^plugins/ s/git/git wd globalias/" -i .zshrc'; \
    } | su user \
    #
    # VIM
    #
    && { \
        echo 'git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime'; \
        echo 'sh .vim_runtime/install_awesome_vimrc.sh'; \
    } | su user \
    && cd .vim_runtime/my_plugins \
    && { \
        echo 'git clone --depth=1 https://github.com/ervandew/supertab.git'; \
        echo 'git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git'; \
        echo 'git clone --depth=1 https://github.com/junegunn/vim-easy-align.git'; \
        #echo 'git clone --depth=1 https://github.com/neoclide/coc.nvim.git'; \
        #echo 'git clone --depth=1 https://github.com/aklt/plantuml-syntax.git'; \
    } | su user \
    && cd /home/user \
    #
    # NIX
    #
    && sudo -u user -- sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
    && sudo -u user --                         \
            nix-env -i python3-3.8.5           \
                       python3.8-pipx-0.15.5.1 \
                       nodejs                  \
                       yarn
    #
    # Dotfiles
    #
    && mv /.dotfiles . \
    && chown -R user:user .dotfiles \
    && sudo -u user -- ln -sf .dotfiles/rcrc .rcrc \
    && sudo -u user -- rcup \
    #
    # Cleanup
    #
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*
    # && sudo -u user -- nix-collect-garbage -d

VOLUME /nix
USER user
WORKDIR /home/user
CMD ["/usr/bin/screen", "-RRaADU"]
