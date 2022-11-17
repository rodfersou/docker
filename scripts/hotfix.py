# https://github.com/pyinvoke/invoke/issues/357#issuecomment-1250744013
import inspect
import types

import six
from invoke.tasks import NO_DEFAULT, Task

if six.PY3:
    from itertools import zip_longest
else:
    from itertools import izip_longest as zip_longest


def patched_argspec(self, body):
    """
    Returns two-tuple:
    * First item is list of arg names, in order defined.
        * I.e. we *cannot* simply use a dict's ``keys()`` method here.
    * Second item is dict mapping arg names to default values or
      `.NO_DEFAULT` (an 'empty' value distinct from None, since None
      is a valid value on its own).
    """
    # Handle callable-but-not-function objects
    # TODO: __call__ exhibits the 'self' arg; do we manually nix 1st result
    # in argspec, or is there a way to get the "really callable" spec?
    func = body if isinstance(body, types.FunctionType) else body.__call__
    if six.PY3:
        sig = inspect.signature(func)
        arg_names = [k for k, v in sig.parameters.items()]
        spec_dict = {}
        for k, v in sig.parameters.items():
            value = v.default if not v.default == sig.empty else NO_DEFAULT
            spec_dict.update({k: value})
    else:
        spec = inspect.getargspec(func)
        arg_names = spec.args[:]
        matched_args = [reversed(x) for x in [spec.args, spec.defaults or []]]
        spec_dict = dict(zip_longest(*matched_args, fillvalue=NO_DEFAULT))
    # Pop context argument
    try:
        context_arg = arg_names.pop(0)
    except IndexError:
        # TODO: see TODO under __call__, this should be same type
        raise TypeError("Tasks must have an initial Context argument!")
    del spec_dict[context_arg]
    return arg_names, spec_dict


Task.argspec = types.MethodType(patched_argspec, Task)
