import invoke


@invoke.task
def start(c):
    c.run(f"docker run --rm -it {c['TAG']}")

