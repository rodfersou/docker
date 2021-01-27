# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

TAG='rodfersou/ubuntu:20.04'
NAME='rodfersou_ubuntu_20.04'

all: build

build:
	make clean
	docker build -t $(TAG) .

start:
	-mkdir nix
	docker run                                    \
		--name $(NAME)                            \
		--detach-keys="ctrl-d,d"                  \
		--rm                                      \
		--network host                            \
		--privileged                              \
		-e DISPLAY                                \
		-it                                       \
		-v $$PWD/nix:/nix                         \
		-v $$PWD/dotfiles:/home/devuser/.dotfiles \
		$(TAG)                                    \
	|| docker attach                              \
		--detach-keys="ctrl-d,d"                  \
		$(NAME)

restart:
	make stop
	-sudo rm -rf nix/*
	make start

stop:
	-docker container stop $(NAME)

stop-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)

export:
	-rm $(NAME).tar.gz
	docker save $(TAG) | gzip > $(NAME).tar.gz

import:
	docker load < $(NAME).tar.gz

clean:
	-docker container stop $(NAME)
	-docker image rm $(TAG)

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)


.PHONY: all clean
