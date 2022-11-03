# syntax=docker/dockerfile:1
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN <<PRE  bash                                                                                                                  \
 && <<APT  xargs -d '\n' -n 1 bash -c "[[ ! "\$0" =~ (^\b*#|^\b*$) ]] && apt-get install -y --no-install-recommends \$0 || true" \
 && <<POST bash
    sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list
    apt-get update
PRE
    # SYSTEM BASE
    apt-utils
    ca-certificates
    gnupg
    locales
    lsb-release

    # SYSTEM UTILS
    less
    man
    ncurses-term
    psmisc
    rcm
    ssh
    sudo
    tree
    xclip
    xsel
    zsh

    # BASE UTILS
    curl
    p7zip-full
    unzip
    wget
    xz-utils

    # DEV UTILS
    build-essential
    entr
    git
    httpie
    jp
    jq
    kdiff3
    screen
    silversearcher-ag
    tmux

    # GENERAL UTILS
    aptitude
    emacs-nox
    encfs
    finch
    htop
    irssi
    neovim
    ranger
    zathura
APT
    # CONFIGS
    locale-gen en_US.UTF-8
    yes | unminimize
    touch /etc/services

    # SUDO
    sed -e '/^\%sudo/ s/\ ALL$/\ NOPASSWD:ALL/' -i /etc/sudoers

    # CACHE
    mkdir -p /cache/mongo/db
    mkdir -p /cache/npm
    mkdir -p /cache/pip
    mkdir -p /cache/pipenv
    mkdir -p /cache/yarn

    # BBM TOOLS
    ###########

    # AWS CLI V2
    cd /cache
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    7z x awscliv2.zip
    ./aws/install

    # NEBULA
    # && cd /cache                                                                          \
    # && wget https://github.com/boughtbymany/nebula-cli/releases/download/${NEBULA_VERSION}/nebula-${NEBULA_VERSION}-linux-arm.tar.gz \
    # && tar -zxvf nebula-${NEBULA_VERSION}-linux-arm.tar.gz                                                                           \
    # && mv nebula-${NEBULA_VERSION}-linux-arm /usr/local/                                                                             \
    # && ln -s /usr/local/nebula-${NEBULA_VERSION}-linux-arm/bin/nebula /usr/local/bin/nebula                                          \

    # CLEAN
    apt-get clean
    apt-get autoremove -y
    rm -rf /var/lib/apt/lists/*
POST

CMD ["apt", "list", "--installed"]
