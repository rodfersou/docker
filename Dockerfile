FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
# ARG PYCHARM_VERSION="pycharm-community-2021.2.1"
ARG NEBULA_VERSION="v0.1.6"

ENV ASDF_DIR "/asdf"
ENV ASDF_DATA_DIR $ASDF_DIR
ENV PIPX_HOME "/pipx"
ENV PIPX_BIN_DIR $PIPX_HOME/bin
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PIPX_BIN_DIR:$PATH
ENV LC_CTYPE=C.UTF-8
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NPM_CONFIG_CACHE="/cache/npm"
ENV PIP_CACHE_DIR="/cache/pip"
ENV PIPENV_CACHE_DIR="/cache/pipenv"
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_VERBOSITY=-1
ENV XDG_CACHE_HOME="/cache"
ENV YARN_CACHE_FOLDER="/cache/yarn"
# Fix Pycharm interface
#ENV _JAVA_OPTIONS="-Dsun.java2d.xrender=false"

ENV USER=docker

COPY --chown=docker:docker dotfiles .dotfiles
RUN sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list \
    && apt-get update                                 \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get install -y --no-install-recommends \
               ca-certificates \
               locales         \
    && apt-get install -y --no-install-recommends \
               less         \
               man          \
               ncurses-term \
               psmisc       \
               rcm          \
               ssh          \
               sudo         \
               tree         \
               xclip        \
               xsel         \
               zsh          \
    && apt-get install -y --no-install-recommends \
               build-essential \
    && apt-get install -y --no-install-recommends \
               entr              \
               git               \
               httpie            \
               jp                \
               jq                \
               kdiff3            \
               screen            \
               silversearcher-ag \
               tmux              \
               zathura           \
    && apt-get install -y --no-install-recommends \
               curl       \
               p7zip-full \
               unzip      \
               wget       \
               xz-utils   \
    && apt-get install -y --no-install-recommends \
               aptitude  \
               emacs-nox \
               encfs     \
               finch     \
               htop      \
               irssi     \
               neovim    \
               ranger    \
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
    && mkdir -p /cache/pip             \
    && mkdir -p /cache/pipenv          \
    && mkdir -p /cache/yarn            \
    && chown -R docker:docker /cache   \
    #
    # Pycharm
    #
    # && apt-get install -y --no-install-recommends \
    #            dbus                               \
    #            libgl1-mesa-glx                    \
    #            mesa-utils                         \
    #
    # BBM TOOLS
    #
    # AWS CLI V2
    && cd /cache                                                                          \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip" \
    && 7z x awscliv2.zip                                                                  \
    && ./aws/install                                                                      \
    #
    # NEBULA
    # && cd /cache                                                                          \
    # && wget https://github.com/boughtbymany/nebula-cli/releases/download/${NEBULA_VERSION}/nebula-${NEBULA_VERSION}-linux-arm.tar.gz \
    # && tar -zxvf nebula-${NEBULA_VERSION}-linux-arm.tar.gz                                                                           \
    # && mv nebula-${NEBULA_VERSION}-linux-arm /usr/local/                                                                             \
    # && ln -s /usr/local/nebula-${NEBULA_VERSION}-linux-arm/bin/nebula /usr/local/bin/nebula                                          \
    #
    # Cleanup
    #
    && apt-get clean               \
    && apt-get autoremove -y       \
    && rm -rf /var/lib/apt/lists/*

USER docker
WORKDIR /home/docker
COPY --from=rodfersou/asdf --chown=docker:docker /asdf                              /asdf
COPY --from=rodfersou/asdf --chown=docker:docker /root/.tool-versions               /home/docker/.tool-versions
COPY --from=rodfersou/asdf --chown=docker:docker /root/.config/pypoetry/config.toml /home/docker/.config/pypoetry/config.toml
COPY --from=rodfersou/asdf --chown=docker:docker /pipx                              /pipx

RUN cd \
    #
    # ZSH
    #
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -e "/^plugins/ s/git/git wd globalias/" -i .zshrc                                \
    #
    # VIM
    #
    && git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime \
    && sh ~/.vim_runtime/install_awesome_vimrc.sh                         \
    #
    # Dotfiles
    #
    && sudo mv /.dotfiles .                  \
    && ln -sf .dotfiles/rcrc .rcrc           \
    && rcup                                  \
    #
    # NIX
    #
    && sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
    && sed "/nix-profile/d" -i .zshrc                      \
    && . /home/docker/.nix-profile/etc/profile.d/nix.sh    \
    #
    # VIM Plugins
    #
    && cd ~/.vim_runtime/my_plugins                                                            \
    # && git clone --depth=1 https://github.com/ervandew/supertab.git                          \
    && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git                       \
    && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git                      \
    && git clone --depth=1 https://github.com/neoclide/coc.nvim.git                            \
    && git clone --depth=1 https://github.com/aklt/plantuml-syntax.git                         \
    && git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git \
    && git clone --depth=1 https://github.com/LnL7/vim-nix.git                                 \
    && cd ~/.vim_runtime/my_plugins/coc.nvim                                                   \
    && npm i                                                                                    \
    && cd ~/.vim_runtime/my_plugins/LanguageClient-neovim                                      \
    && bash install.sh                                                                         \
    && cd                                                                                      \
    #
    # Pycharm
    #
    # && cd /cache                                                            \
    # && wget https://download.jetbrains.com/python/${PYCHARM_VERSION}.tar.gz \
    # && tar -zxvf ${PYCHARM_VERSION}.tar.gz                                  \
    # && rm -rf ${PYCHARM_VERSION}.tar.gz                                     \
    # && ln -sf ${PYCHARM_VERSION} pycharm                                    \
    # && cd                                                                   \
    #
    # Cleanup
    #
    && nix-collect-garbage -d

CMD ["/usr/bin/screen", "-RRaADU"]
