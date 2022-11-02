# syntax=docker/dockerfile:1
FROM rodfersou/asdf-python-builder AS asdf-python
RUN <<BASH bash
    asdf install python latest:3.11
    asdf global  python latest:3.11
    pip install -U pip
BASH


FROM rodfersou/asdf-python-base
COPY --from=asdf-python /asdf/plugins/python  /asdf/plugins/python
COPY --from=asdf-python /asdf/installs/python /asdf/installs/python
COPY --from=asdf-python /root/.tool-versions  /root/.tool-versions
RUN asdf reshim


CMD ["asdf", "list"]
