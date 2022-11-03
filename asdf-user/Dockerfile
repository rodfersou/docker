# syntax=docker/dockerfile:1
FROM rodfersou/docker-user

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

COPY --from=rodfersou/asdf --chown=docker:docker /asdf                              /asdf
COPY --from=rodfersou/asdf --chown=docker:docker /root/.tool-versions               /home/docker/.tool-versions
COPY --from=rodfersou/asdf --chown=docker:docker /root/.config/pypoetry/config.toml /home/docker/.config/pypoetry/config.toml
COPY --from=rodfersou/asdf --chown=docker:docker /root/.pdbrc.py                    /home/docker/.pdbrc.py
COPY --from=rodfersou/asdf --chown=docker:docker /pipx                              /pipx

CMD ["asdf", "list"]
