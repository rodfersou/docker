# syntax=docker/dockerfile:1
FROM rodfersou/asdf-base

ENV PIPX_HOME "/pipx"
ENV PIPX_BIN_DIR $PIPX_HOME/bin
ENV PATH $PIPX_BIN_DIR:$PATH

RUN <<BASH bash                                              \
 && <<-POETRY_CONFIG cat > /root/.config/pypoetry/config.toml
    mkdir -p /root/.config/pypoetry
    asdf plugin-add python
BASH
    [virtualenvs]
    in-project = true
POETRY_CONFIG

CMD ["asdf"]
