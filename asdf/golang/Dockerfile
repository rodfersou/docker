FROM rodfersou/asdf-builder AS asdf-golang
COPY default-golang-pkgs /root/.default-golang-pkgs
RUN asdf plugin-add golang     \
 && asdf install golang latest \
 && asdf global  golang latest


FROM rodfersou/asdf-base
COPY --from=asdf-golang /asdf/plugins/golang  /asdf/plugins/golang
COPY --from=asdf-golang /asdf/installs/golang /asdf/installs/golang
COPY --from=asdf-golang /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
