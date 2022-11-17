# syntax=docker/dockerfile:1
FROM rodfersou/asdf-python-builder AS asdf-python
RUN <<PRE bash                                                                                      \
 && <<PIP   xargs -n 1 sh -c "pip install -U \"\$0\" || true"                                       \
 && <<PIPX  xargs -n 1 sh -c "pipx install --include-deps \"\$0\" || true"                          \
 && <<PIPXI xargs -n 2 sh -c "pipx inject --include-apps --include-deps -f \"\$0\" \"\$1\" || true"
    asdf install python latest:3.9
    asdf global  python latest:3.9
    pip install -U pip
    pip install -U pipx
    asdf reshim
PRE
    beautifulsoup4
    cssselect
    git+https://github.com/rodfersou/gitim.git
    jedi
    lxml
    neovim
    pdbpp
    pygments
    requests
    setuptools
    unidecode
PIP
    black
    cookiecutter
    flake8
    git+https://github.com/rodfersou/swagger_to_uml.git
    invoke
    ipython
    isort
    mario
    mercurial
    mypy
    pipenv==2022.10.25
    plonecli
    poetry
    py-spy
    pylint
    python-lsp-server
    virtualenv==16.7.9
    yamllint
    youtube-dl
    yq
PIPX
    flake8            flake8-respect-noqa
    mario             mario-addons
    python-lsp-server pyls-isort
    python-lsp-server pylsp-mypy
    python-lsp-server pylsp-rope
    python-lsp-server python-lsp-black
PIPXI


FROM rodfersou/asdf-python-base
COPY --from=asdf-python /asdf/installs/python /asdf/installs/python
COPY --from=asdf-python /asdf/plugins/python  /asdf/plugins/python
COPY --from=asdf-python /pipx                 /pipx
COPY --from=asdf-python /root/.tool-versions  /root/.tool-versions
COPY --from=asdf-python /usr/lib/*/lib*.so.1.1 /usr/lib
RUN asdf reshim


CMD ["asdf", "list"]
