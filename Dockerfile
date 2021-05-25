FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

ENV ASDF_DATA_DIR="/cache/asdf"
ENV ASDF_DIR="/cache/asdf"
ENV LC_CTYPE=C.UTF-8
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NPM_CONFIG_CACHE="/cache/npm"
ENV PIP_CACHE_DIR="/cache/pip"
ENV PIPENV_CACHE_DIR="/cache/pipenv"
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_VERBOSITY=-1
ENV PIPX_HOME="/cache/pipx"
ENV USER=docker
ENV XDG_CACHE_HOME="/cache"
ENV YARN_CACHE_FOLDER="/cache/yarn"

COPY dotfiles .dotfiles
RUN sed -e '/^# deb-src/ s/# //' -i /etc/apt/sources.list \
    && apt-get update \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get install -y --no-install-recommends \
               adb               \
               aptitude          \
               ca-certificates   \
               curl              \
               deluge            \
               encfs             \
               fontconfig        \
               git               \
               htop              \
               httpie            \
               jq                \
               less              \
               locales           \
               ncurses-term      \
               neovim            \
               p7zip-full        \
               psmisc            \
               ranger            \
               rcm               \
               rxvt-unicode      \
               screen            \
               silversearcher-ag \
               smplayer          \
               ssh               \
               sudo              \
               tmux              \
               unzip             \
               wget              \
               xclip             \
               xsel              \
               zsh               \
    && apt-get build-dep -o APT::Get::Build-Dep-Automatic=true -y --no-install-recommends \
               python2 \
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
               libxtst6        \
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
    && sh .vim_runtime/install_awesome_vimrc.sh                           \
    #
    # Dotfiles
    #
    && sudo mv /.dotfiles .                  \
    && sudo chown -R docker:docker .dotfiles \
    && ln -sf .dotfiles/rcrc .rcrc           \
    && rcup                                  \
    #
    # NIX
    #
    && sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
    && sed "/nix-profile/d" -i .zshrc \
    && . /home/docker/.nix-profile/etc/profile.d/nix.sh \
    #
    # ASDF
    #
    && git clone https://github.com/asdf-vm/asdf.git /cache/asdf \
    && cd /cache/asdf \
    && git checkout "$(git describe --abbrev=0 --tags)" \
    && export PATH="/cache/asdf/shims:/cache/asdf/bin:$PATH" \
    # Python
    && asdf plugin-add python                                              \
    && asdf install python latest:2                                        \
    && asdf install python latest:3.6                                      \
    && asdf install python latest:3.8                                      \
    && asdf install python latest                                          \
    && for pydir in /cache/asdf/installs/python/*; do                      \
        for libdir in $pydir/lib/python*/; do                              \
            ln -sf $libdir/_sysconfigdata_m_linux_$(uname -m)-linux-gnu.py \
                   $libdir/_sysconfigdata__linux_$(uname -m)-linux-gnu.py; \
        done;                                                              \
    done                                                                   \
    && asdf global python $(asdf latest python)                            \
    # Java
    && asdf plugin-add java https://github.com/halcyon/asdf-java.git \
    && asdf install java adoptopenjdk-11.0.11+9                      \
    && asdf global java adoptopenjdk-11.0.11+9                       \
    # Direnv
    && asdf plugin-add direnv     \
    && asdf install direnv 2.27.0 \
    && asdf global direnv 2.27.0  \
    # ADR tools
    && asdf plugin-add adr-tools    \
    && asdf install adr-tools 3.0.0 \
    && asdf global adr-tools 3.0.0  \
    # ASDF - END
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
    # Nerd fonts
    #
    && mkdir .fonts \
    && cd .fonts \
    && wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf?raw=true \
    && cd \
    && fc-cache -vf \
    #
    # Cleanup
    #
    && nix-collect-garbage -d

CMD ["/usr/bin/screen", "-RRaADU"]
