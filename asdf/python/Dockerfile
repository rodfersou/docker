# syntax=docker/dockerfile:1
FROM ubuntu:22.04

ENV ASDF_DIR "/asdf"
ENV ASDF_DATA_DIR $ASDF_DIR
ENV PATH $ASDF_DIR/shims:$ASDF_DIR/bin:$PATH

COPY --from=rodfersou/asdf-base         /asdf                 /asdf
COPY --from=rodfersou/asdf-python-base  /asdf/plugins/python  /asdf/plugins/python
COPY --from=rodfersou/asdf-python-3-8   /asdf/installs/python /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-9   /asdf/installs/python /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-10  /asdf/installs/python /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-11  /asdf/installs/python /asdf/installs/python
COPY --from=rodfersou/asdf-python-3-9   /root/.tool-versions  /root/.tool-versions

RUN asdf reshim

CMD ["asdf", "list"]
