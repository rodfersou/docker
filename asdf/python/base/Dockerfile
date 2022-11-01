# syntax=docker/dockerfile:1
FROM rodfersou/asdf-base

RUN <<COMMANDS bash                                           \
 && <<POETRY_CONFIG cat > /root/.config/pypoetry/config.toml
    mkdir -p /root/.config/pypoetry
    asdf plugin-add python
COMMANDS
[virtualenvs]
in-project = true
POETRY_CONFIG

CMD ["asdf"]
