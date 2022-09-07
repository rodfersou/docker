SHELL := /bin/bash

CURRENT_OS := $(shell uname -s)
ifeq ($(CURRENT_OS), Linux)
	CURRENT_OS := $(shell lsb_release -si)
endif

ifeq ($(CURRENT_OS), Darwin)
	PATH  := /opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin
	#DISPLAY := :0.0
	#export DISPLAY
	SHELL := env PATH=$(PATH) /bin/bash
endif

TAG='rodfersou/ubuntu:22.04'
NAME='rodfersou_ubuntu_22.04'

all: start

build:
	make clean
	docker build -t $(TAG) .

start:

ifeq ($(CURRENT_OS), Darwin)

ifeq (, $(shell command -v /opt/X11/bin/Xquartz))
	$(error "No Xquartz installed")
endif
ifeq (, $(shell pgrep Xquartz))
	-open -a XQuartz
	-(sleep 10 && killall -9 xterm) &
endif

endif

	#xhost +local:docker
	#xhost +
	docker run                                       \
		--detach-keys="ctrl-s,d"                     \
		--mount source=cache,target=/cache           \
		--mount source=nix,target=/nix               \
		--mount source=srv,target=/srv               \
		--name $(NAME)                               \
		--privileged                                 \
		--rm                                         \
		-e DISPLAY=host.docker.internal:0            \
		-e TZ=Europe/London                          \
		-it                                          \
		-p 5000-5100:5000-5100                       \
		-p 8000:8000                                 \
		-p 8888:8888                                 \
		-v $$HOME:/home/$$USER                       \
		-v $$PWD/dotfiles:/home/docker/.dotfiles     \
		-v /tmp/.X11-unix:/tmp/.X11-unix:rw          \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /home/$$USER                              \
		$(TAG) #                                       \
#	|| docker attach                                 \
#		$(NAME)
#		-e LINES=$$(tput lines)                      \
#		-e COLUMNS=$$(tput cols)                     \


restart:
	make stop
	make start

stop:
	-docker container stop $(NAME)
	#-xhost -local:docker
	#-xhost -

ifeq ($(CURRENT_OS), Darwin)
	-killall -9 socat
	-osascript -e 'quit app "XQuartz"'
endif

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
