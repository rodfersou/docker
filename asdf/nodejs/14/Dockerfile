# syntax=docker/dockerfile:1
FROM rodfersou/asdf-builder AS asdf-nodejs
RUN <<PRE bash                                        \
 && <<NPM xargs -n 1 sh -c "npm i -g \"\$0\" || true"
    asdf plugin-add nodejs
    asdf install nodejs latest:14
    asdf global  nodejs latest:14
    asdf reshim
PRE
    @angular/cli
    @vue/cli
    asar
    castnow
    create-react-app
    create-volto-app
    csscomb
    internal-ip-cli
    serverless
    tiddlywiki
    yarn
    git+ssh://git@github.com:boughtbymany/nebula-cli.git#v0.1.5
NPM


FROM rodfersou/asdf-base
COPY --from=asdf-nodejs /asdf/plugins/nodejs  /asdf/plugins/nodejs
COPY --from=asdf-nodejs /asdf/installs/nodejs /asdf/installs/nodejs
COPY --from=asdf-nodejs /root/.tool-versions  /root/.tool-versions
RUN asdf reshim


CMD ["asdf"]
