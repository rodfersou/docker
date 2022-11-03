# syntax=docker/dockerfile:1
FROM rodfersou/asdf-user
ENV ASDF_DIR      /asdf
ENV ASDF_DATA_DIR $ASDF_DIR
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PATH
USER docker
WORKDIR /home/docker
RUN <<VIM bash
    # VIM
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
    bash install.sh
VIM

CMD ["vi"]
