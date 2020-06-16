# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

TAG='rodfersou/ubuntu:20.04'
NAME='base'

all: build

build:
	docker build -t $(TAG) .

start:
	docker run                           \
		--name $(NAME)                   \
		--detach-keys="ctrl-d,d"         \
		--rm                             \
		-e DISPLAY                       \
		-it                              \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		$(TAG)                           \
	|| docker attach                     \
		--detach-keys="ctrl-d,d"         \
		$(NAME)

stop:
	-docker container stop $(NAME)
	-docker container rm $(NAME)

stop-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)

clean:
	-docker container stop $(NAME)
	-docker container rm $(NAME)
	-docker image rm $(TAG)

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)


.PHONY: all clean
