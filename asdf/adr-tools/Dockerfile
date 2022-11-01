FROM rodfersou/asdf-builder AS asdf-adr-tools
RUN asdf plugin-add adr-tools     \
 && asdf install adr-tools latest \
 && asdf global  adr-tools latest


FROM rodfersou/asdf-base
COPY --from=asdf-adr-tools /asdf/plugins/adr-tools  /asdf/plugins/adr-tools
COPY --from=asdf-adr-tools /asdf/installs/adr-tools /asdf/installs/adr-tools
COPY --from=asdf-adr-tools /root/.tool-versions     /root/.tool-versions


CMD ["asdf"]
