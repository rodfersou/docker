import pathlib

for module in pathlib.Path(__file__).parent.glob("*.py"):
    name = module.name[:-3]
    if name.startswith("__"):
        continue
    globals()[name] = getattr(getattr(__import__(f"scripts.{name}"), name), name)
