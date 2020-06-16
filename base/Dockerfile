FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

COPY dotfiles .dotfiles
RUN sed -e '/^# deb-src/ s/# //' -i /etc/apt/sources.list \
    && apt-get update \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get install -y --no-install-recommends \
               # build-essential   \
               ca-certificates   \
               curl              \
               entr              \
               git               \
               htop              \
               httpie            \
               jq                \
               locales           \
               ncurses-term      \
               neovim            \
               ranger            \
               rcm               \
               rsync             \
               screen            \
               silversearcher-ag \
               sudo              \
               tidy              \
               tmux              \
               tree              \
               zsh               \
    && locale-gen en_US.UTF-8  \
    #
    # sudo
    #
    && sed -e '/^\%sudo/ s/\ ALL$/\ NOPASSWD:ALL/' -i /etc/sudoers \
    && echo "Set disable_coredump false" >> /etc/sudo.conf \
    #
    # ADD devuser
    #
    && adduser --quiet              \
               --disabled-password  \
               --shell /usr/bin/zsh \
               --home /home/devuser \
               --gecos "User"       \
               devuser              \
    && echo "devuser:devuser" | chpasswd \
    && usermod -aG sudo devuser \
    && chown -R devuser:devuser /srv \
    && cd /home/devuser \
    && mv /.dotfiles . \
    && chown -R devuser:devuser .dotfiles \
    #
    # ZSH
    #
    && { \
        echo 'sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'; \
        echo 'sed -e "/^plugins/ s/git/git wd globalias asdf/" -i .zshrc'; \
    } | su devuser \
    #
    # VIM
    #
    && { \
        echo 'git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime'; \
        echo 'sh .vim_runtime/install_awesome_vimrc.sh'; \
    } | su devuser \
    && cd .vim_runtime/my_plugins \
    && { \
        echo 'git clone --depth=1 https://github.com/ervandew/supertab.git'; \
        echo 'git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git'; \
        echo 'git clone --depth=1 https://github.com/junegunn/vim-easy-align.git'; \
        #echo 'git clone --depth=1 https://github.com/neoclide/coc.nvim.git'; \
        #echo 'git clone --depth=1 https://github.com/aklt/plantuml-syntax.git'; \
    } | su devuser \
    && cd /home/devuser \
    #
    # ASDF
    #
    && sudo -u devuser -- git clone --branch v0.7.8 https://github.com/asdf-vm/asdf.git .asdf \
    #
    # Dotfiles
    #
    && sudo -u devuser -- rcup \
    #
    # Cleanup
    #
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER devuser
WORKDIR /home/devuser
CMD ["/usr/bin/screen", "-RRaADU"]
