FROM rodfersou/asdf-builder AS asdf-direnv
RUN asdf plugin-add direnv        \
 && asdf install    direnv latest \
 && asdf global     direnv latest


FROM rodfersou/asdf-base
COPY --from=asdf-direnv /asdf/plugins/direnv  /asdf/plugins/direnv
COPY --from=asdf-direnv /asdf/installs/direnv /asdf/installs/direnv
COPY --from=asdf-direnv /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
