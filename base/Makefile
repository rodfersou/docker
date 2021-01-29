# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

TAG='rodfersou/nix:2.3.6'
NAME='rodfersou_nix_2.3.6'

all: build

build:
	make clean
	docker build -t $(TAG) .

start:
	docker run                                    \
		--name $(NAME)                            \
		--detach-keys="ctrl-d,d"                  \
		--rm                                      \
		--network host                            \
		--privileged                              \
		-e DISPLAY                                \
		-it                                       \
		$(TAG)                                    \
	|| docker attach                              \
		--detach-keys="ctrl-d,d"                  \
		$(NAME)
		# -v $$PWD/nix:/nix                         \
		# -v $$PWD/dotfiles:/home/devuser/.dotfiles \

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
