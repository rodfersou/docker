# syntax=docker/dockerfile:1
FROM rodfersou/asdf-builder
ARG DEBIAN_FRONTEND=noninteractive

COPY --from=rodfersou/asdf-python-base /asdf/plugins/python /asdf/plugins/python
RUN <<COMMANDS bash                                         \
 && <<DEFAULT_PACKAGES cat > /root/.default-python-packages
    sed -e '/^# deb/ s/# //' -i /etc/apt/sources.list
    apt-get update
    apt build-dep -o APT::Get::Build-Dep-Automatic=true -y --no-install-recommends \
        python3
    apt-get clean
    apt-get autoremove -y
    rm -rf /var/lib/apt/lists/*
COMMANDS
beautifulsoup4
black
cookiecutter
cssselect
debug
flake8
flake8-respect-noqa
git+https://github.com/rodfersou/gitim.git
git+https://github.com/rodfersou/swagger_to_uml.git
invoke
ipython
isort
lxml
mario
mario-addons
mercurial
mypy
pipenv
pipx
plonecli
poetry
py-spy
pygments
pylint
python-language-server
pyls-black
pyls-flake8
pyls-isort==0.2.0
pyls-mypy
requests
unidecode
virtualenv
yamllint
youtube-dl
yq
DEFAULT_PACKAGES

CMD ["asdf"]
