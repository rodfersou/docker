# syntax=docker/dockerfile:1
FROM rodfersou/asdf-base

ENV PIPX_HOME "/pipx"
ENV PIPX_BIN_DIR $PIPX_HOME/bin
ENV PATH $PIPX_BIN_DIR:$PATH

RUN <<BASH bash                                              \
 && <<POETRY_CONFIG cat > /root/.config/pypoetry/config.toml \
 && <<PDBPP_CONFIG cat > /root/.pdbrc.py
    mkdir -p /root/.config/pypoetry
    asdf plugin-add python
BASH
[virtualenvs]
in-project = true
POETRY_CONFIG
import pdb


class Config(pdb.DefaultConfig):
    sticky_by_default = True
PDBPP_CONFIG

CMD ["asdf"]
