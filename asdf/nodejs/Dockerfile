# syntax=docker/dockerfile:1
FROM rodfersou/asdf-base
COPY --from=rodfersou/asdf-nodejs-14 /asdf/plugins/nodejs  /asdf/plugins/nodejs
COPY --from=rodfersou/asdf-nodejs-14 /asdf/installs/nodejs /asdf/installs/nodejs
COPY --from=rodfersou/asdf-nodejs-14 /root/.tool-versions  /root/.tool-versions
COPY --from=rodfersou/asdf-nodejs-16 /asdf/plugins/nodejs  /asdf/plugins/nodejs
COPY --from=rodfersou/asdf-nodejs-16 /asdf/installs/nodejs /asdf/installs/nodejs

RUN asdf reshim

CMD ["asdf", "list"]
