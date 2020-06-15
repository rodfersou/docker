# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: build

build:
	docker build -t rodfersou:base .

start:
	docker run                           \
		--name rodfersou_base            \
		--detach-keys="ctrl-d,d"         \
		--rm                             \
		-e DISPLAY                       \
		-it                              \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		rodfersou:base                   \
	|| docker attach                     \
		--detach-keys="ctrl-d,d"         \
		rodfersou_base

stop:
	-docker container stop rodfersou_base
	-docker container rm rodfersou_base

stop-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)

clean:
	-docker container stop rodfersou_base
	-docker container rm rodfersou_base
	-docker image rm rodfersou:base

clean-all:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	-docker rmi $$(docker images -q)


.PHONY: all clean
