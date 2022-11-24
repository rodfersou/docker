import inspect
import sys

import invoke

sys.path.append("../..")

import scripts

ns = invoke.Collection()


for _, task in inspect.getmembers(scripts):
    if not isinstance(task, invoke.tasks.Task):
        continue
    ns.add_task(task)


ns.configure(scripts.get_configuration(__file__))


# @invoke.task
# def build(c, fix=False):
#     print("world!")


# ns.add_task(build)
