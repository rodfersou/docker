# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV ASDF_DIR "/asdf"
ENV ASDF_DATA_DIR $ASDF_DIR
ENV PIPX_HOME "/pipx"
ENV PIPX_BIN_DIR $PIPX_HOME/bin
ENV PATH $ASDF_DIR/bin:$ASDF_DIR/shims:$PIPX_BIN_DIR:$PATH

COPY --from=rodfersou/asdf-base         /asdf                              /asdf
COPY --from=rodfersou/asdf-python-base  /asdf/plugins/python               /asdf/plugins/python
COPY --from=rodfersou/asdf-python-3-8   /asdf/installs/python              /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-9   /asdf/installs/python              /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-10  /asdf/installs/python              /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-11  /asdf/installs/python              /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-9   /root/.tool-versions               /root/.tool-versions
COPY --from=rodfersou/asdf-python-3-9   /root/.config/pypoetry/config.toml /root/.config/pypoetry/config.toml
COPY --from=rodfersou/asdf-python-3-9   /pipx                              /pipx

RUN asdf reshim

CMD ["asdf", "list"]
