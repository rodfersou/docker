import invoke
import pathlib


@invoke.task
def hello(c, fix=False):
    print("world!")
    breakpoint()
    tag = globals().get('TAG', None)
    if tag:
        print(f"tag: {tag}")
