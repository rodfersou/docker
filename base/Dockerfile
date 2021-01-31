FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ENV USER=docker
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
    # ADD docker user
    #
    && adduser --quiet                 \
               --disabled-password     \
               --shell /usr/bin/zsh    \
               --home /home/docker     \
               --gecos "User"          \
               docker                  \
    && echo "docker:docker" | chpasswd \
    && usermod -aG sudo docker         \
    && chown -R docker:docker /srv     \
    #
    # Cleanup
    #
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER docker
WORKDIR /srv

RUN cd /home/docker \
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
    && sudo chown -R docker:docker .dotfiles \
    && ln -sf .dotfiles/rcrc .rcrc \
    && rcup \
    #
    # NIX
    #
    && sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
    && . /home/docker/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -iA                        \
               nixpkgs.nodejs             \
               nixpkgs.python38           \
               nixpkgs.python38.pkgs.pipx \
               nixpkgs.yarn               \
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
    && pipx install --include-deps                     \
            git+https://github.com/rodfersou/gitim.git \
    && pipx install ipython \
    #
    # Cleanup
    #
    && nix-collect-garbage -d

CMD ["/usr/bin/screen", "-RRaADU"]
