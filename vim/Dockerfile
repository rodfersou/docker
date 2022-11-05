# syntax=docker/dockerfile:1
FROM rodfersou/docker-user AS base
ARG DEBIAN_FRONTEND=noninteractive
USER root
WORKDIR /root
RUN <<APT bash
    sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list
    apt-get update
    apt-get install -y --no-install-recommends \
            neovim
APT

FROM rodfersou/asdf-base AS builder
ENV ASDF_DIR      /asdf
ENV ASDF_DATA_DIR $ASDF_DIR
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PATH
RUN <<GIT bash
    sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list
    apt-get update
    apt-get install -y --no-install-recommends \
            neovim

    # VIM
    cd ~
    git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    # VIM Plugins
    cd ~/.vim_runtime/my_plugins
    # git clone --depth=1 https://github.com/ervandew/supertab.git
    git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git
    git clone --depth=1 https://github.com/junegunn/vim-easy-align.git
    git clone --depth=1 https://github.com/neoclide/coc.nvim.git
    git clone --depth=1 https://github.com/aklt/plantuml-syntax.git
    git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git
    git clone --depth=1 https://github.com/LnL7/vim-nix.git

    cd ~/.vim_runtime/my_plugins/coc.nvim
    npm i

    cd ~/.vim_runtime/my_plugins/LanguageClient-neovim
    sh install.sh
GIT

FROM base
USER docker
WORKDIR /home/docker
COPY --chown=docker:docker dotfiles/init.vim /home/docker/.config/nvim/init.vim
COPY --chown=docker:docker dotfiles/my_configs.vim /home/docker/.vim_runtime/my_configs.vim
COPY --chown=docker:docker --from=builder /root/.vimrc /home/docker/.vimrc
COPY --chown=docker:docker --from=builder /root/.vim_runtime /home/docker/.vim_runtime

CMD ["vi"]
