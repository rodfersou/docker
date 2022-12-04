import invoke


@invoke.task
def stop(c, all=None):
    if all:
        c.run(f"docker stop $(docker ps -aq)", echo=True)
        c.run(f"docker rm $(docker ps -aq)", echo=True)
    else:
        c.run(f"docker container stop {c['NAME']}", echo=True)
