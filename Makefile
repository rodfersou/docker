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
	-socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$$DISPLAY\" && sleep 1 &
ifeq (, $(shell command -v /opt/X11/bin/Xquartz))
	$(error "No Xquartz installed")
endif
	# -defaults write org.macosforge.xquartz.X11 app_to_run /usr/bin/true
ifeq (, $(shell pgrep Xquartz))
	-open -a XQuartz
	-(sleep 10 && killall -9 xterm) &
endif
endif
	$(DOCKER_RUN)                                    \
		--name $(NAME)                               \
		--rm                                         \
		--network host                               \
		--privileged                                 \
		--mount source=cache,target=/cache           \
		--mount source=srv,target=/srv               \
		--mount source=nix,target=/nix               \
		-e DISPLAY                                   \
		-it                                          \
		-v /tmp/.X11-unix:/tmp/.X11-unix             \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $$HOME:/home/$$USER                       \
		-v $$PWD/dotfiles:/home/docker/.dotfiles     \
		$(TAG)                                       \
	|| docker attach                                 \
		$(NAME)

restart:
	make stop
	make start

stop:
	-docker container stop $(NAME)
ifeq ($(CURRENT_OS),Darwin)
	-killall -9 socat
	-osascript -e 'quit app "XQuartz"'
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
	-docker volume rm cache nix

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)
	# -docker volume rm $$(docker volume ls -q)
	-docker volume rm cache nix

rebuild:
	make clean-all
	make build
	make export


.PHONY: all clean
