#!/bin/sh
set -e

requirements_txt=$1

if [ $"requirements_txt" = - ]; then
    requirements_txt=/dev/stdin
fi

if ! [ -r "$requirements_txt" ]; then
    echo >&2 "Usage: $0 path/to/requirements.txt"
    exit 1
fi

mkdir -p wheelfreeze

rm -rf wheelfreeze/wheels
pip wheel --wheel-dir=wheelfreeze/wheels -r "$requirements_txt"

cat > wheelfreeze/install <<'INSTALL'
#!/bin/sh
set -e
wheelfreeze_base="$(readlink -f "$(dirname "$0")")"
rm -rf "$wheelfreeze_base"/venv
python3 -m venv "$wheelfreeze_base"/venv
. "$wheelfreeze_base"/venv/bin/activate
pip install --no-deps "$wheelfreeze_base"/wheels/*.whl

cat > "$wheelfreeze_base"/venv/bin/run <<END
#!/bin/sh
. "$wheelfreeze_base"/venv/bin/activate
exec "\$@"
END
chmod +x "$wheelfreeze_base"/venv/bin/run
INSTALL
chmod +x wheelfreeze/install
