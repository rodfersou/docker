# convenience makefile to boostrap & run buildout
SHELL := /bin/bash

TAG='rodfersou/ubuntu:20.04'
NAME='rodfersou_ubuntu_20.04'

DOCKER_RUN=docker run
ifeq ($(shell uname -s),Darwin)
	DOCKER_RUN=DISPLAY="docker.for.mac.host.internal:0" docker run
endif

all: start

build:
	make clean
	docker build -t $(TAG) .

start:
ifeq ($(shell uname -s),Darwin)
ifeq (, $(shell command -v socat))
	$(error "No socat in $(PATH)")
endif
	socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$$DISPLAY\" && sleep 1 &
endif
	$(DOCKER_RUN)                                                        \
		--name $(NAME)                                                   \
		--detach-keys="ctrl-d,d"                                         \
		--rm                                                             \
		--network host                                                   \
		--privileged                                                     \
		--mount source=nix,target=/nix                                   \
		-e DISPLAY                                                       \
		-it                                                              \
		-v $$(ls /Users &> /dev/null && echo /Users || echo /home):/host \
		-v $$PWD/srv:/srv                                                \
		-v $$PWD/dotfiles:/home/user/.dotfiles                           \
		$(TAG)                                                           \
	|| docker attach                                                     \
		--detach-keys="ctrl-d,d"                                         \
		$(NAME)

restart:
	make stop
	make start

stop:
	-docker container stop $(NAME)
ifeq ($(CURRENT_OS),Darwin)
	-killall -9 socat
	-killall -9 Xquartz
endif

stop-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)

export:
	-rm $(NAME).tar.gz
	docker save $(TAG) | gzip > $(NAME).tar.gz
	du -sh $(NAME).tar.gz

import:
	make clean
	docker load < $(NAME).tar.gz

clean:
	make stop
	-docker image rm $(TAG)
	-docker volume rm nix

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)
	-docker volume rm $$(docker volume ls -q)


.PHONY: all clean
