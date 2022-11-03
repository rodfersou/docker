# syntax=docker/dockerfile:1
FROM rodfersou/docker-base
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG     C.UTF-8
ENV LC_ALL   C.UTF-8
ENV LC_CTYPE C.UTF-8
RUN <<SH sh
    locale-gen en_US.UTF-8

    # ADD docker user
    adduser --quiet              \
            --disabled-password  \
            --shell /usr/bin/zsh \
            --home /home/docker  \
            --gecos "User"       \
            docker
    echo "docker:docker" | chpasswd
    usermod -aG sudo docker
    chown -R docker:docker /srv
    chown -R docker:docker /cache
SH

USER docker
WORKDIR /home/docker

CMD ["whoami"]
