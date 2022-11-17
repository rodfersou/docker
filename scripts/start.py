import invoke


@invoke.task
def build(c):
    c.run("docker buildx build -t $(TAG) . --progress plain")
