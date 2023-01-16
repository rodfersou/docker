import inspect
import os
import sys

import invoke

sys.path.append("..")

import scripts

ns = invoke.Collection()


for _, task in inspect.getmembers(scripts):
    if not isinstance(task, invoke.tasks.Task):
        continue
    ns.add_task(task)


@invoke.task
def start(c):
    os.system(
        f"""
        docker run                                       \
            --detach-keys="ctrl-s,d"                     \
            --mount source=cache,target=/cache           \
            --mount source=docker,target=/var/lib/docker \
            --mount source=nix,target=/nix               \
            --mount source=srv,target=/srv               \
            --name {c['NAME']}                           \
            --privileged                                 \
            --rm                                         \
            -e DISPLAY=host.docker.internal:0            \
            -e TZ=Europe/London                          \
            -it                                          \
            -p 5000-5100:5000-5100                       \
            -p 8888:8888                                 \
            -v $HOME:/home/$USER                         \
            -v $PWD/dotfiles:/home/docker/.dotfiles      \
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw          \
            -w /home/$USER                               \
            {c['TAG']}                                   \
            /usr/bin/zsh                                 \
        || docker attach                                 \
            {c['NAME']}
        """
    )

    # -p 8000:8000                                 \


ns.add_task(start)


ns.configure(scripts.get_configuration(__file__))
