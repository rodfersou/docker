FROM rodfersou/asdf-builder AS asdf-nodejs
COPY default-npm-packages /root/.default-npm-packages
RUN asdf plugin-add nodejs        \
 && asdf install nodejs latest:14 \
 && asdf global  nodejs $(asdf latest nodejs 14)


FROM rodfersou/asdf-base
COPY --from=asdf-nodejs /asdf/plugins/nodejs  /asdf/plugins/nodejs
COPY --from=asdf-nodejs /asdf/installs/nodejs /asdf/installs/nodejs
COPY --from=asdf-nodejs /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
