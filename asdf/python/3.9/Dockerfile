# syntax=docker/dockerfile:1
FROM rodfersou/asdf-python-builder AS asdf-python
RUN <<BASH bash                                                                             \
 && <<PIP   xargs -n 1 sh -c "pip install -U \$0 || true"                                   \
 && <<PIPX  xargs -n 1 sh -c "pipx install --include-deps \$0 || true"                      \
 && <<PIPXI xargs -n 2 sh -c "pipx inject --include-apps --include-deps -f \$0 \$1 || true"
    asdf install python latest:3.9
    asdf global  python latest:3.9
    pip install -U pip
    pip install -U pipx
    asdf reshim
BASH
    beautifulsoup4
    cssselect
    lxml
    pdbpp
    psutils
    pygments
    requests
    unidecode
PIP
    black
    cookiecutter
    flake8
    git+https://github.com/rodfersou/gitim.git
    git+https://github.com/rodfersou/swagger_to_uml.git
    invoke
    ipython
    isort
    mario
    mercurial
    mypy
    pipenv
    plonecli
    poetry
    py-spy
    pylint
    python-language-server
    virtualenv==16.7.9
    yamllint
    youtube-dl
    yq
PIPX
    flake8 flake8-respect-noqa
    mario mario-addons
    python-language-server pyls-black
    python-language-server pyls-flake8
    python-language-server pyls-isort==0.2.0
    python-language-server pyls-mypy
PIPXI


FROM rodfersou/asdf-python-base
COPY --from=asdf-python /asdf/plugins/python  /asdf/plugins/python
COPY --from=asdf-python /asdf/installs/python /asdf/installs/python
COPY --from=asdf-python /pipx                 /pipx
COPY --from=asdf-python /root/.tool-versions  /root/.tool-versions
RUN asdf reshim


CMD ["asdf", "list"]
