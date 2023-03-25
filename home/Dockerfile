# syntax=docker/dockerfile:1
FROM rodfersou/base

ARG DEBIAN_FRONTEND=noninteractive
ARG NEBULA_VERSION=v0.1.6
# ARG PYCHARM_VERSION="pycharm-community-2021.2.1"

ENV LANG     C.UTF-8
ENV LC_ALL   C.UTF-8
ENV LC_CTYPE C.UTF-8

ENV ASDF_DIR      /asdf
ENV ASDF_DATA_DIR $ASDF_DIR

ENV _JAVA_OPTIONS -Dsun.java2d.xrender=false

ENV NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM 1

ENV AWS_CLI_AUTO_PROMPT       on
ENV PIPENV_IGNORE_VIRTUALENVS 1
ENV PIPENV_VENV_IN_PROJECT    1
ENV PIPENV_VERBOSITY          -1
ENV PIPX_HOME                 /pipx
ENV PIPX_BIN_DIR              $PIPX_HOME/bin
ENV PYTHONWARNINGS            ignore
ENV USE_EMOJI                 -1

ENV NPM_CONFIG_CACHE  /cache/npm
ENV XDG_CACHE_HOME    /cache
ENV YARN_CACHE_FOLDER /cache/yarn
ENV PIP_CACHE_DIR     /cache/pip
ENV PIPENV_CACHE_DIR  /cache/pipenv

COPY --from=rodfersou/user --chown=docker:docker /etc /etc
COPY --from=rodfersou/user --chown=docker:docker /home/docker /home/docker

ENV USER docker
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PIPX_BIN_DIR:$PATH

COPY --from=rodfersou/asdf --chown=docker:docker /asdf                              /asdf
COPY --from=rodfersou/asdf --chown=docker:docker /root/.tool-versions               /home/docker/.tool-versions
COPY --from=rodfersou/asdf --chown=docker:docker /root/.config/pypoetry/config.toml /home/docker/.config/pypoetry/config.toml
COPY --from=rodfersou/asdf --chown=docker:docker /root/.pdbrc.py                    /home/docker/.pdbrc.py
COPY --from=rodfersou/asdf --chown=docker:docker /pipx                              /pipx
COPY --from=rodfersou/asdf                       /usr/lib/lib*.so.1.1               /usr/lib

COPY --chown=docker:docker --from=rodfersou/vim-awesome /root/.config/nvim/init.vim /home/docker/.config/nvim/init.vim
COPY --chown=docker:docker --from=rodfersou/vim-awesome /root/.vimrc                /home/docker/.vimrc
COPY --chown=docker:docker --from=rodfersou/vim-awesome /root/.vim_runtime          /home/docker/.vim_runtime
COPY --chown=docker:docker                              dotfiles                    .dotfiles

USER docker
WORKDIR /home/docker

RUN cd \
 && sudo chown -R docker:docker /cache \
 && sudo chown -R docker:docker /srv \
    # ZSH
 && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
 && sed -e "/^plugins/ s/git/aws git globalias invoke wd/" -i .zshrc \
    # Dotfiles
 && sudo mv /.dotfiles . \
 && ln -sf .dotfiles/rcrc .rcrc \
 && rcup \
    # NIX
 && sh -c "$(curl -fsSL https://nixos.org/nix/install)" \
 && sed "/nix-profile/d" -i .zshrc \
 && . /home/docker/.nix-profile/etc/profile.d/nix.sh \
    # Pycharm
#&& cd /cache \
#&& wget https://download.jetbrains.com/python/${PYCHARM_VERSION}.tar.gz \
#&& tar -zxvf ${PYCHARM_VERSION}.tar.gz \
#&& rm -rf ${PYCHARM_VERSION}.tar.gz \
#&& ln -sf ${PYCHARM_VERSION} pycharm \
#&& cd \
    # Cleanup
 && nix-collect-garbage -d


# CMD ["/usr/bin/screen", "-RRaADU"]
CMD ["/usr/bin/zsh"]
