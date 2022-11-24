import invoke


@invoke.task
def build(c):
    c.run(f"docker buildx build -t {c['TAG']} . --progress plain")
