import pathlib

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
