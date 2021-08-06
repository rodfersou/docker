FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ARG PYCHARM_VERSION="pycharm-community-2021.1.3"

ENV ASDF_DATA_DIR="/cache/asdf"
ENV ASDF_DIR="/cache/asdf"
ENV JGO_CACHE_DIR="/cache/jgo"
ENV LC_CTYPE=C.UTF-8
ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1
ENV NPM_CONFIG_CACHE="/cache/npm"
ENV PIP_CACHE_DIR="/cache/pip"
ENV PIPENV_CACHE_DIR="/cache/pipenv"
ENV PIPENV_IGNORE_VIRTUALENVS=1
ENV PIPENV_VENV_IN_PROJECT=1
ENV PIPENV_VERBOSITY=-1
ENV PIPX_HOME="/cache/pipx"
ENV XDG_CACHE_HOME="/cache"
ENV YARN_CACHE_FOLDER="/cache/yarn"
# Fix Pycharm interface
ENV _JAVA_OPTIONS="-Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
ENV JAVA_FONTS=/home/docker/.fonts
ENV LIBGL_ALWAYS_INDIRECT=1

ENV USER=docker

COPY dotfiles .dotfiles
RUN sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list \
    && apt-get update \
    #
    # BASE
    #
    && apt-get install -y                                                                                           \
               apt-utils 2>&1 | grep -v "debconf: delaying package configuration, since apt-utils is not installed" \
    && apt-get build-dep -o APT::Get::Build-Dep-Automatic=true -y --no-install-recommends \
    #           python2 \
               python3 \
    && apt-get install -y --no-install-recommends \
               build-essential \
               ca-certificates \
               coreutils       \
               dirmngr         \
               fontconfig      \
               gpg             \
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
               locales         \
               ncurses-term    \
               psmisc          \
               tk-dev          \
               xz-utils        \
               zlib1g-dev      \
    && apt-get install -y --no-install-recommends \
               adb               \
               curl              \
               entr              \
               ghostscript       \
               git               \
               httpie            \
               jq                \
               kdiff3            \
               man               \
               rxvt-unicode      \
               screen            \
               silversearcher-ag \
               tmux              \
               wget              \
               xclip             \
               xsel              \
               zsh               \
    && apt-get install -y --no-install-recommends \
               aptitude          \
               calibre           \
               deluge            \
               emacs-nox         \
               encfs             \
               ffmpeg            \
               htop              \
               imagemagick       \
               less              \
               neovim            \
               p7zip-full        \
               pdftk             \
               ranger            \
               rcm               \
               ssh               \
               sudo              \
               tree              \
               unzip             \
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
    && mkdir -p /cache/jgo             \
    && mkdir -p /cache/mongo/db        \
    && mkdir -p /cache/npm             \
    && mkdir -p /cache/pip             \
    && mkdir -p /cache/pipenv          \
    && mkdir -p /cache/pipx            \
    && mkdir -p /cache/yarn            \
    && chown -R docker:docker /cache   \
    #
    # Fix curl
    #
    && sed -i '/^oid_section.*/a \\n# System default\nopenssl_conf = default_conf' /etc/ssl/openssl.cnf \
    && sed -i '$s/$/\n\n\[default_conf\]\nssl_conf = ssl_sect\n\n\[ssl_sect\]\nsystem_default = system_default_sect\n\n\[system_default_sect\]\nCipherString = DEFAULT\@SECLEVEL=1/' /etc/ssl/openssl.cnf \
    #
    # Fix imagemagick
    #
    && sed -i '/^<\/policymap>/i \\ \ <policy domain="coder" rights="read | write" pattern="PDF" />' /etc/ImageMagick-6/policy.xml \
    #
    # Pycharm
    #
    && apt-get install -y --no-install-recommends                                                              \
               dbus                                                                                            \
               libgl1-mesa-glx                                                                                 \
               mesa-utils                                                                                      \
    && echo -e "#\!/bin/bash\n/cache/${PYCHARM_VERSION}/bin/pycharm.sh $@ 2> /dev/null &\n" > /usr/bin/pycharm \
    && chmod +x /usr/bin/pycharm                                                                               \
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
    && sed -e "/^plugins/ s/git/git wd globalias/" -i .zshrc                                \
    && echo "prompt_context() {}" >> .zshrc                                                 \
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
    && sed "/nix-profile/d" -i .zshrc                      \
    && . /home/docker/.nix-profile/etc/profile.d/nix.sh    \
    #
    # ASDF
    #
    && git clone https://github.com/asdf-vm/asdf.git /cache/asdf \
    && cd /cache/asdf                                            \
    && git checkout "$(git describe --abbrev=0 --tags)"          \
    && export PATH="/cache/asdf/shims:/cache/asdf/bin:$PATH"     \
    # Python
    && asdf plugin-add python                                                   \
    && asdf install python latest                                               \
    && asdf global python latest                                                \
    && rm /home/docker/default-python-packages                                  \
    && asdf install python latest:3.8                                           \
    && asdf install python latest:3.6                                           \
    #&& asdf install python latest:2                                            \
    #&& for pydir in /cache/asdf/installs/python/*; do                          \
    #    for libdir in $pydir/lib/python*/; do                                  \
    #        ln -sf /usr/lib/python3.8/_sysconfigdata__$(uname -m)-linux-gnu.py \
    #               ${libdir}_sysconfigdata__linux_$(uname -m)-linux-gnu.py;    \
    #    done;                                                                  \
    #done                                                                       \
    && rcup                                                                     \
    # NodeJS
    && asdf plugin-add nodejs                          \
    && asdf install    nodejs latest:14                \
    && asdf global     nodejs $(asdf latest nodejs 14) \
    # Go
    && asdf plugin-add golang        \
    && asdf install    golang latest \
    && asdf global     golang latest \
    # Ruby
    && asdf plugin-add ruby        \
    && asdf install    ruby latest \
    && asdf global     ruby latest \
    # Java
    && asdf plugin-add java                                     \
    && asdf install    java latest:adoptopenjdk-11              \
    && asdf global     java $(asdf latest java adoptopenjdk-11) \
    && asdf plugin-add gradle                        \
    #&& asdf install    gradle latest                \
    #&& asdf global     gradle $(asdf latest gradle) \
    # Direnv
    && asdf plugin-add direnv        \
    && asdf install    direnv latest \
    && asdf global     direnv latest \
    # ADR tools
    && asdf plugin-add adr-tools        \
    && asdf install    adr-tools latest \
    && asdf global     adr-tools latest \
    # ASDF - END
    && cd \
    #
    # VIM Plugins
    #
    && cd .vim_runtime/my_plugins                                                              \
    # && git clone --depth=1 https://github.com/ervandew/supertab.git                          \
    && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git                       \
    && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git                      \
    && git clone --depth=1 https://github.com/neoclide/coc.nvim.git                            \
    && git clone --depth=1 https://github.com/aklt/plantuml-syntax.git                         \
    && git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git \
    && git clone --depth=1 https://github.com/LnL7/vim-nix.git                                 \
    && cd LanguageClient-neovim                                                                \
    && bash install.sh                                                                         \
    && cd                                                                                      \
    #
    # Pycharm
    #
    && cd /cache                                                                    \
    && wget https://download.jetbrains.com/python/${PYCHARM_VERSION}.tar.gz \
    && tar -zxvf ${PYCHARM_VERSION}.tar.gz                                  \
    && rm -rf ${PYCHARM_VERSION}.tar.gz                                     \
    && cd                                                                           \
    #
    # Nerd fonts
    #
    && mkdir .fonts                                                                                                                                                          \
    && cd .fonts                                                                                                                                                             \
    && wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/SourceCodePro/Regular/complete/Sauce%20Code%20Pro%20Nerd%20Font%20Complete%20Mono.ttf?raw=true -O Sauce_Code_Pro_Nerd_Font_Complete_Mono.ttf \
    && cd                                                                                                                                                                    \
    && fc-cache -vf                                                                                                                                                          \
    #
    # Cleanup
    #
    && nix-collect-garbage -d

CMD ["/usr/bin/screen", "-RRaADU"]
