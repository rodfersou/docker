# syntax=docker/dockerfile:1
FROM rodfersou/asdf-builder
ARG DEBIAN_FRONTEND=noninteractive

ENV PIPX_HOME "/pipx"
ENV PIPX_BIN_DIR $PIPX_HOME/bin
ENV PATH $PIPX_BIN_DIR:$PATH

COPY --from=rodfersou/asdf-python-base /asdf/plugins/python /asdf/plugins/python
RUN <<BASH bash
    sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list
    apt-get update
    apt build-dep -o APT::Get::Build-Dep-Automatic=true -y --no-install-recommends \
        python3
    apt-get clean
    apt-get autoremove -y
    rm -rf /var/lib/apt/lists/*
    mkdir /pipx
BASH

CMD ["asdf"]
