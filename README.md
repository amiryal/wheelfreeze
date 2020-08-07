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
├── sys_executable_hint
└── wheels/
    ├── somedependency-1.3-py2.py3-none-any.whl
    └── somepackage-0.1.dev1234-py3-none-any.whl
```

Running `wheelfreeze/install path/to/venv` will install the wheels in the
virtualenv at `path/to/venv`.

A best-effort attempt is made to detect the Python executable that was used in
creating the wheels, and its path is written to
`wheelfreeze/sys_executable_hint`.

## Requirements

A POSIX environment with `realpath` from GNU Coreutils and `pip` from Python.

## Installation

Varies by OS and setup, but generally for a normal user:

```
make install PREFIX=~/.local
```

Or system wide:

```
sudo make install
```
