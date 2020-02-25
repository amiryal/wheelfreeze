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
WHEELFREEZE_BASE="$(readlink -f "$(dirname "$0")")"
rm -rf "$WHEELFREEZE_BASE"/venv
python3 -m venv "$WHEELFREEZE_BASE"/venv
. "$WHEELFREEZE_BASE"/venv/bin/activate
pip install --no-deps "$WHEELFREEZE_BASE"/wheels/*.whl

cat > "$WHEELFREEZE_BASE"/venv/bin/run <<END
#!/bin/sh
. "$WHEELFREEZE_BASE"/venv/bin/activate
exec "\$@"
END
chmod +x "$WHEELFREEZE_BASE"/venv/bin/run
INSTALL
chmod +x wheelfreeze/install
