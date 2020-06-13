# convenience makefile to boostrap & run buildout
SHELL := /bin/bash
CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all: build

build:
	docker build -t rodfersou:base .

start:
	# docker run --rm -it rodfersou::base
	docker run --name rodfersou_base --rm -it rodfersou:base

clean-all:
	docker stop $$(docker ps -aq)
	docker rm $$(docker ps -aq)
	docker rmi $$(docker images -q)

clean:
	# docker container stop rodfersou_base
	# docker container rm rodfersou_base
	docker stop $$(docker ps -aq)
	docker rm $$(docker ps -aq)
	docker image rm rodfersou:base

.PHONY: all clean
