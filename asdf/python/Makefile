SHELL := /bin/bash

CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS), Linux)
	CURRENT_OS := $(shell lsb_release -si)
endif

ifeq ($(CURRENT_OS), Darwin)
	PATH  := /opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin
	SHELL := env PATH=$(PATH) /bin/bash
endif

TAG='rodfersou/asdf-python'
NAME='rodfersou_asdf_python'

all: start

build:
	make clean
	docker buildx build -t $(TAG) . --progress plain

build-all:
	(cd base    && make build)
	(cd builder && make build)
	# (cd 3.6   && make build)
	(cd 3.8     && make build)
	(cd 3.9     && make build)
	(cd 3.10    && make build)
	(cd 3.11    && make build)
	make build

start:
	docker run --rm -it $(TAG) bash

restart:
	make stop
	make start

stop:
	-docker container stop $(NAME)

stop-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)

export:
	-rm $(NAME)_$(CURRENT_OS).tar.gz
	docker save $(TAG) | gzip > $(NAME)_$(CURRENT_OS).tar.gz
	du -sh $(NAME)_$(CURRENT_OS).tar.gz

import:
	make clean
	docker load < $(NAME)_$(CURRENT_OS).tar.gz

clean:
	make stop
	-docker image rm $(TAG)

clean-cache-nix:
	-docker volume rm cache nix

clean-srv:
	-docker volume rm srv

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)
	# -docker volume rm $$(docker volume ls -q)

rebuild:
	make clean-all
	make build
	make export


.PHONY: all clean
