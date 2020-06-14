# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: build

build:
	docker build -t rodfersou:base .

start:
	# docker run --rm -it rodfersou:base
	if [ ! "$(docker ps | grep rodfersou_base)" ]; then           \
		docker run --name rodfersou_base --rm -it rodfersou:base; \
	else                                                          \
		docker attach rodfersou_base;                             \
	fi

stop:
	-docker stop $$(docker ps -aq)
	# -docker rm $$(docker ps -aq)
	# -docker rmi $$(docker images -q)

stop-and-clean:
	-docker stop $$(docker ps -aq)
	-docker rm $$(docker ps -aq)
	# -docker rmi $$(docker images -q)

clean:
	-docker container stop rodfersou_base
	-docker container rm rodfersou_base
	-docker image rm rodfersou:base

.PHONY: all clean
