# syntax=docker/dockerfile:1
FROM rodfersou/docker-base

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

ENV USER docker
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PIPX_BIN_DIR:$PATH

COPY --from=rodfersou/docker-user / /
COPY --from=rodfersou/asdf-user   / /
COPY --from=rodfersou/docker-vim  / /

COPY --chown=docker:docker dotfiles .dotfiles

USER docker
WORKDIR /home/docker

RUN cd \
    #
    # ZSH
    #
    && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && sed -e "/^plugins/ s/git/aws git globalias wd/" -i .zshrc                                \
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
