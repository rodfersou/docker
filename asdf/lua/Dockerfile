# syntax=docker/dockerfile:1
FROM rodfersou/asdf-builder AS deps
RUN <<APT bash
    apt update
    apt install -y \
        unzip
APT

FROM deps AS plugin
ARG ASDF_LUA_LINUX_READLINE=1
RUN <<PLUGIN bash
    asdf plugin-add lua https://github.com/Stratus3D/asdf-lua.git
    asdf install lua latest
    asdf global  lua latest
    asdf reshim
PLUGIN


FROM rodfersou/asdf-base
COPY --from=plugin /asdf/plugins/lua    /asdf/plugins/lua
COPY --from=plugin /asdf/installs/lua   /asdf/installs/lua
COPY --from=plugin /root/.tool-versions /root/.tool-versions
RUN asdf reshim


CMD ["asdf", "list"]
