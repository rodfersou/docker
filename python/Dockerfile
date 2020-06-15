FROM rodfersou:base
USER root

COPY dotfiles .dotfiles
RUN apt-get update \
    #
    # BASE
    #
    && apt-get build-dep -y --no-install-recommends \
               python2.7 \
               python3.8 \
    && rm -rf /var/lib/apt/lists/* \
    && cd /home/devuser \
    && mkdir -p /srv/cache/pip \
    #
    # Dotfiles
    #
    && rsync -a /.dotfiles/ .dotfiles \
    && rm -rf /.dotfiles \
    && chown -R devuser:devuser .dotfiles \
    && sudo -u devuser -- rcdn \
    && sudo -u devuser -- rcup \
    #
    # ASDF
    #
    && asdf plugin-add python \
    && asdf install python 2.7.17 \
    && asdf install python 3.7.7 \
    && asdf install python 3.8.2 \
    && asdf global python 3.7.7 2.7.17 \
    && asdf install python anaconda3-2020.02 \
    && cd .asdf/installs/python/anaconda3-2020.02/bin \
    && http https://raw.githubusercontent.com/pyenv/pyenv/master/pyenv.d/rehash/conda.d/default.list | grep -v "\#" | xargs rm \
    && cd /home/devuser \
    && asdf reshim python

USER devuser
WORKDIR /home/devuser
CMD ["/usr/bin/screen", "-RRaADU"]
