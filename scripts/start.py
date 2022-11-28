import os

import invoke


@invoke.task
def start(c):
    os.system(f"docker run --rm -it {c['TAG']}")
