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

virtual_env=$1
virtual_env=$(realpath -s "$virtual_env" ||:)

if ! [ -f "$virtual_env"/bin/activate ]; then
    echo >&2 "Usage: $0 path/to/venv"
    exit 1
fi

. "$virtual_env"/bin/activate

wheelfreeze_base="$(realpath -s "$(dirname "$0")")"

pip install --no-deps "$wheelfreeze_base"/wheels/*.whl
INSTALL
chmod +x wheelfreeze/install
