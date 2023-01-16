import inspect
import pathlib

# https://github.com/your-tools/tsrc/pull/373
if not hasattr(inspect, "getargspec"):
    inspect.getargspec = inspect.getfullargspec

# from scripts import hotfix  # noqa: F401

for module in pathlib.Path(__file__).parent.glob("*.py"):
    name = module.name[:-3]
    try:
        module = getattr(__import__(f"scripts.{name}"), name)
        function = getattr(module, name, None)
        if not function:
            continue
        globals()[name] = function
    except:
        pass


def get_configuration(filename: str) -> dict:
    parts = []
    path = pathlib.Path(filename).resolve()
    for parent in reversed(path.parents):
        if not next(parent.glob("tasks.py"), None):
            continue
        parts.append(parent.name.replace(".", "-"))
    parts = parts[1:]  # skip the first dir

    tag = f"rodfersou/{'-'.join(parts)}"
    name = f"rodfersou_{'_'.join(parts)}"
    return {"TAG": tag, "NAME": name}
