import inspect

import invoke

import scripts

ns = invoke.Collection()


for _, task in inspect.getmembers(scripts):
    if not isinstance(task, invoke.tasks.Task):
        continue
    ns.add_task(task)


ns.configure(scripts.get_configuration(__file__))


@invoke.task
def start(c):
    c.run(f"docker run --rm -it {c['TAG']}")


ns.add_task(start)
