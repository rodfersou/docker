# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV ASDF_DIR      /asdf
ENV ASDF_DATA_DIR $ASDF_DIR

ENV _JAVA_OPTIONS -Dsun.java2d.xrender=false

ENV PIPENV_IGNORE_VIRTUALENVS 1
ENV PIPENV_VENV_IN_PROJECT    1
ENV PIPENV_VERBOSITY          -1
ENV PIPX_HOME                 /pipx
ENV PIPX_BIN_DIR              $PIPX_HOME/bin
ENV PYTHONWARNINGS            ignore
ENV USE_EMOJI                 -1

ENV NPM_CONFIG_CACHE  /cache/npm
ENV YARN_CACHE_FOLDER /cache/yarn
ENV PIP_CACHE_DIR     /cache/pip
ENV PIPENV_CACHE_DIR  /cache/pipenv

ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PIPX_BIN_DIR:$PATH


COPY --from=rodfersou/asdf-base      /asdf                              /asdf
COPY --from=rodfersou/asdf-python    /asdf/plugins/python               /asdf/plugins/python
COPY --from=rodfersou/asdf-python    /asdf/installs/python              /asdf/installs/python
COPY --from=rodfersou/asdf-python    /root/.config/pypoetry/config.toml /root/.config/pypoetry/config.toml
COPY --from=rodfersou/asdf-python    /root/.pdbrc.py                    /root/.pdbrc.py
COPY --from=rodfersou/asdf-python    /root/.tool-versions               /root/.tool-versions-python
COPY --from=rodfersou/asdf-python    /pipx                              /pipx
COPY --from=rodfersou/asdf-nodejs    /asdf/plugins/nodejs               /asdf/plugins/nodejs
COPY --from=rodfersou/asdf-nodejs    /asdf/installs/nodejs              /asdf/installs/nodejs
COPY --from=rodfersou/asdf-nodejs    /root/.tool-versions               /root/.tool-versions-nodejs
COPY --from=rodfersou/asdf-golang    /asdf/plugins/golang               /asdf/plugins/golang
COPY --from=rodfersou/asdf-golang    /asdf/installs/golang              /asdf/installs/golang
COPY --from=rodfersou/asdf-golang    /root/.tool-versions               /root/.tool-versions-golang
COPY --from=rodfersou/asdf-ruby      /asdf/plugins/ruby                 /asdf/plugins/ruby
COPY --from=rodfersou/asdf-ruby      /asdf/installs/ruby                /asdf/installs/ruby
COPY --from=rodfersou/asdf-ruby      /root/.tool-versions               /root/.tool-versions-ruby
COPY --from=rodfersou/asdf-rust      /asdf/plugins/rust                 /asdf/plugins/rust
COPY --from=rodfersou/asdf-rust      /asdf/installs/rust                /asdf/installs/rust
COPY --from=rodfersou/asdf-rust      /root/.tool-versions               /root/.tool-versions-rust
COPY --from=rodfersou/asdf-java      /asdf/plugins/java                 /asdf/plugins/java
COPY --from=rodfersou/asdf-java      /asdf/installs/java                /asdf/installs/java
# COPY --from=rodfersou/asdf-java    /asdf/plugins/ant                  /asdf/plugins/ant
# COPY --from=rodfersou/asdf-java    /asdf/installs/ant                 /asdf/installs/ant
COPY --from=rodfersou/asdf-java      /root/.tool-versions               /root/.tool-versions-java
COPY --from=rodfersou/asdf-direnv    /asdf/plugins/direnv               /asdf/plugins/direnv
COPY --from=rodfersou/asdf-direnv    /asdf/installs/direnv              /asdf/installs/direnv
COPY --from=rodfersou/asdf-direnv    /root/.tool-versions               /root/.tool-versions-direnv
COPY --from=rodfersou/asdf-adr-tools /asdf/plugins/adr-tools            /asdf/plugins/adr-tools
COPY --from=rodfersou/asdf-adr-tools /asdf/installs/adr-tools           /asdf/installs/adr-tools
COPY --from=rodfersou/asdf-adr-tools /root/.tool-versions               /root/.tool-versions-adr-tools

RUN <<BASH bash
    cat /root/.tool-versions-* > /root/.tool-versions
    rm -f /root/.tool-versions-*
    asdf reshim
BASH

CMD ["asdf", "list"]
