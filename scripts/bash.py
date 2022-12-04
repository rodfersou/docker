import os

import invoke


@invoke.task
def bash(c):
    os.system(f"docker run --rm -it {c['TAG']} bash")
