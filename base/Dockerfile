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
               build-essential \
               ca-certificates \
               curl            \
               git             \
               httpie          \
               jq              \
               locales         \
               mc              \
               ncurses-term    \
               rcm             \
               screen          \
               sudo            \
               tmux            \
               vim             \
               wget            \
               zsh             \
    && rm -rf /var/lib/apt/lists/* \
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
    && mv /.dotfiles /home/devuser \
    && chown -R devuser:devuser /home/devuser/.dotfiles \
    #
    # ZSH
    #
    && sudo -u devuser -- sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sudo -u devuser -- sed -e '/^ZSH_THEME/ s/robbyrussell/agnoster/' -i /home/devuser/.zshrc \
    && sudo -u devuser -- sed -e '/^# DISABLE_AUTO_TITLE/ s/^# //' -i /home/devuser/.zshrc \
    #
    # VIM
    #
    && sudo -u devuser -- git clone --depth=1 https://github.com/amix/vimrc.git /home/devuser/.vim_runtime \
    && sudo -u devuser -- sh /home/devuser/.vim_runtime/install_awesome_vimrc.sh \
    && sudo -u devuser -- cd /home/devuser/.vim_runtime/my_plugins && git clone --depth=1 https://github.com/ervandew/supertab.git \
    && sudo -u devuser -- cd /home/devuser/.vim_runtime/my_plugins && git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git \
    && sudo -u devuser -- cd /home/devuser/.vim_runtime/my_plugins && git clone --depth=1 https://github.com/junegunn/vim-easy-align.git \
    # && sudo -u devuser -- cd /home/devuser/.vim_runtime/my_plugins && git clone --depth=1 https://github.com/neoclide/coc.nvim.git \
    # && sudo -u devuser -- cd /home/devuser/.vim_runtime/my_plugins && git clone --depth=1 https://github.com/aklt/plantuml-syntax.git \
    #
    # Dotfiles
    #
    && sudo -u devuser -- rcup
USER devuser
WORKDIR /home/devuser
CMD ["/usr/bin/screen", "-RRaADU"]
