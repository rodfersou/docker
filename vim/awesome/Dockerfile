# syntax=docker/dockerfile:1
FROM ubuntu:22.04 AS base
ARG DEBIAN_FRONTEND=noninteractive
RUN <<VIM bash
    apt-get update
    apt-get install -y --no-install-recommends \
            neovim
VIM

FROM ubuntu:22.04 AS configs
RUN <<PRE     bash                                  \
 && <<CONFIGS bash                                  \
 && <<NVIM_CONFIG cat > /root/.config/nvim/init.vim
    mkdir -p /root/.config/nvim
    apt-get update
    apt-get install -y --no-install-recommends \
            git
PRE
    # github: server certificate verification failed
    git config --global http.sslverify false

    # VIM
    cd ~
    git clone --depth=1 https://github.com/amix/vimrc.git .vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh

    # VIM Plugins
    cd ~/.vim_runtime/my_plugins
    git clone --depth=1 https://github.com/ervandew/supertab.git
    git clone --depth=1 https://github.com/ryanoasis/vim-devicons.git
    git clone --depth=1 https://github.com/junegunn/vim-easy-align.git
    # git clone --depth=1 https://github.com/neoclide/coc.nvim.git
    git clone --depth=1 https://github.com/aklt/plantuml-syntax.git
    git clone --depth=1 --branch next https://github.com/autozimu/LanguageClient-neovim.git
    git clone --depth=1 https://github.com/LnL7/vim-nix.git
CONFIGS
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
source ~/.vimrc
NVIM_CONFIG


FROM rodfersou/asdf as post-configs
COPY --from=configs /root/.vim_runtime /root/.vim_runtime
RUN <<PRE  bash \
 && <<POST bash
    mkdir -p /root/.config/nvim
    apt-get update
    apt-get install -y --no-install-recommends \
            build-essential                    \
            ca-certificates
PRE
    # cd ~/.vim_runtime/my_plugins/coc.nvim
    # npm i
    cd ~/.vim_runtime/my_plugins/LanguageClient-neovim
    sh install.sh
POST


FROM base
COPY --from=configs      /root/.config/nvim/init.vim       /root/.config/nvim/init.vim
COPY --from=configs      /root/.vimrc                      /root/.vimrc
COPY --from=post-configs /root/.vim_runtime                /root/.vim_runtime
COPY                     dotfiles/my_configs.vim           /root/.vim_runtime/my_configs.vim

CMD ["vi"]
