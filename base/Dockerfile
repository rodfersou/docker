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
    && locale-gen en_US.UTF-8 \
    #
    # sudo
    #
    && sed -e '/^\%sudo/ s/\ ALL$/\ NOPASSWD:ALL/' -i /etc/sudoers \
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
    #
    # Cleanup
    #
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER user
WORKDIR /home/user

RUN cd /home/user \
    #
    # ZSH
    #
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && echo "prompt_context() {}" >> .zshrc \
    #
    # VIM
    #
    && git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime \
    && sh .vim_runtime/install_awesome_vimrc.sh \
    #
    # Dotfiles
    #
    && sudo mv /.dotfiles . \
    && sudo chown -R user:user .dotfiles \
    && ln -sf .dotfiles/rcrc .rcrc \
    && rcup \
    #
    # NIX
    #
    && sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
    && . /home/user/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -iA              \
               nixpkgs.python38 \
               nixpkgs.node     \
    #
    # VIM Plugins
    #
    && cd .vim_runtime/my_plugins \
    # && git clone --depth=1 https://github.com/ervandew/supertab.git \
    && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git \
    && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git \
    && git clone --depth=1 https://github.com/neoclide/coc.nvim.git \
    # && git clone --depth=1 https://github.com/aklt/plantuml-syntax.git \
    #
    # Pipx
    #
    && pipx ensurepath \
    && echo 'eval "$(register-python-argcomplete pipx)"' >> .zshrc \
    && pipx install --include-deps                             \
            git+git://github.com/muhasturk/gitim.git#egg=gitim \
    && pipx install ipython \
    #
    # Cleanup
    #
    && nix-collect-garbage -d


VOLUME /nix
VOLUME /srv

CMD ["/usr/bin/screen", "-RRaADU"]
