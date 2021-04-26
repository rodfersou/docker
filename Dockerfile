FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ENV USER=docker
ENV XDG_CACHE_HOME="/cache"
ENV ASDF_DIR="/cache/asdf"
ENV ASDF_DATA_DIR="/cache/asdf"
ENV NPM_CONFIG_CACHE="/cache/npm"
ENV YARN_CACHE_FOLDER="/cache/yarn"
ENV PIP_CACHE_DIR="/cache/pip"
ENV PIPENV_CACHE_DIR="/cache/pipenv"
ENV PIPX_HOME="/cache/pipx"
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_VERBOSITY=-1

COPY dotfiles .dotfiles
RUN sed -e '/^# deb-src/ s/# //' -i /etc/apt/sources.list \
    && apt-get update \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get install -y --no-install-recommends \
               aptitude          \
               ca-certificates   \
               curl              \
               encfs             \
               git               \
               locales           \
               ncurses-term      \
               neovim            \
               psmisc            \
               rcm               \
               screen            \
               silversearcher-ag \
               ssh               \
               sudo              \
               tmux              \
               wget              \
               zsh               \
    && apt-get build-dep -o APT::Get::Build-Dep-Automatic=true -y --no-install-recommends \
               # python2 \
               python3 \
    && apt-get install -y --no-install-recommends \
               build-essential \
               libbz2-dev      \
               libffi-dev      \
               liblzma-dev     \
               libncurses5-dev \
               libreadline-dev \
               libsqlite3-dev  \
               libssl-dev      \
               libxml2-dev     \
               libxmlsec1-dev  \
               llvm            \
               tk-dev          \
               xz-utils        \
               zlib1g-dev      \
    && locale-gen en_US.UTF-8 \
    && yes | unminimize \
    && touch /etc/services \
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
    && mkdir -p /cache/mongo/db        \
    && mkdir -p /cache/npm             \
    && mkdir -p /cache/yarn            \
    && mkdir -p /cache/pip             \
    && mkdir -p /cache/pipenv          \
    && mkdir -p /cache/pipx            \
    && chown -R docker:docker /cache   \
    #
    # Cleanup
    #
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

USER docker
WORKDIR /home/docker

RUN cd \
    #
    # ZSH
    #
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -e "/^plugins/ s/git/git wd globalias/" -i .zshrc \
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
    && sed "/nix-profile/d" -i .zshrc \
    && . /home/docker/.nix-profile/etc/profile.d/nix.sh \
    # && nix-env -iA                        \
    #            nixpkgs.nodejs             \
    #            nixpkgs.python38           \
    #            nixpkgs.python38.pkgs.pipx \
    #            nixpkgs.yarn               \
    #
    # Pipx
    #
    # && pipx ensurepath \
    # && pipx install --include-deps                     \
    #         git+https://github.com/rodfersou/gitim.git \
    # && pipx install ipython \
    #
    # ASDF
    #
    && git clone https://github.com/asdf-vm/asdf.git /cache/asdf \
    && cd /cache/asdf \
    && git checkout "$(git describe --abbrev=0 --tags)" \
    && export PATH="/cache/asdf/shims:/cache/asdf/bin:$PATH" \
    && asdf plugin-add python \
    && asdf install python 3.6.12 \
    && ln -sf /cache/asdf/installs/python/3.6.12/lib/python3.6/_sysconfigdata_m_linux_x86_64-linux-gnu.py \
              /cache/asdf/installs/python/3.6.12/lib/python3.6/_sysconfigdata__linux_x86_64-linux-gnu.py  \
    && asdf plugin-add direnv \
    && asdf install direnv 2.27.0 \
    && asdf plugin-add adr-tools \
    && asdf install adr-tools 3.0.0 \
    && cd \
    #
    # VIM Plugins
    #
    && cd .vim_runtime/my_plugins \
    # && git clone --depth=1 https://github.com/ervandew/supertab.git \
    && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git \
    && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git \
    && git clone --depth=1 https://github.com/neoclide/coc.nvim.git \
    && git clone --depth=1 https://github.com/aklt/plantuml-syntax.git \
    && git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git \
    && cd LanguageClient-neovim \
    && bash install.sh \
    && cd \
    #
    # Cleanup
    #
    && nix-collect-garbage -d

CMD ["/usr/bin/screen", "-RRaADU"]
