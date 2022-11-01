FROM rodfersou/asdf-python-builder as asdf-python-3-6
# 3.6 don't support: mario, py-spy, plonecli
COPY default-python-packages /root/.default-python-packages
RUN asdf install python latest:3.6 \
 && asdf global  python latest:3.6 \
 && pip install -U pip


FROM rodfersou/asdf-python-base
COPY --from=asdf-python-3-6 /asdf/plugins/python  /asdf/plugins/python
COPY --from=asdf-python-3-6 /asdf/installs/python /asdf/installs/python
COPY --from=asdf-python-3-6 /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
