# wheelfreeze

Freeze Python `requirements.txt` dependencies in a ready-to-install wheel cache.

## Background

Following is an illustrative `requirements.txt` file:

```
hg+https://example.com/someone/somepackage/#egg=somepackage
```

It requires a package version that is not available on PyPI, but installs
cleanly in a virtualenv, which yields the following `pip freeze` output:

```
somedependency==1.3
somepackage==0.1.dev1234
```

## The problem

We would like to reproduce this virtualenv on a different host. However, this
output is not useful as input to `pip install -r`, because is has lost the
`hg+https` reference. One option would be to package everything as wheels on the
source host, and re-use them on the destination.

## How it works

Running `wheelfreeze requirements.txt` will create the following tree:

```
wheelfreeze/
├── install*
└── wheels/
    ├── somedependency-1.3-py2.py3-none-any.whl
    └── somepackage-0.1.dev1234-py3-none-any.whl
```

Running the generated `wheelfreeze/install` script will populate a standard
virtualenv in `wheelfreeze/venv`, and add a convenience script,
`wheelfreeze/venv/bin/run`, for running other programs inside the virtualenv
without activating interactively.

## Requirements

For creating the archive: `pip`.

For installing from the archive: `python3`, `pip`.
