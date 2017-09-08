#!/bin/sh
set -e

mkdir -p wheelfreeze

if [ -f wheelfreeze/requirements.freeze ]; then
    mv wheelfreeze/requirements.freeze wheelfreeze/requirements.freeze.old
fi
rm -rf wheelfreeze/wheels
pip wheel --wheel-dir=wheelfreeze/wheels -r requirements.txt
for whl in wheelfreeze/wheels/*.whl; do
    unzip -p "$whl" '*.dist-info/metadata.json' | jq -r '.name + "==" + .version' >> wheelfreeze/requirements.freeze
done

cat > wheelfreeze/install <<'INSTALL'
#!/bin/sh
set -e
WHEELFREEZE_BASE="$(readlink -f "$(dirname "$0")")"
rm -rf "$WHEELFREEZE_BASE"/venv
python3 -m venv "$WHEELFREEZE_BASE"/venv
. "$WHEELFREEZE_BASE"/venv/bin/activate
pip install --use-wheel --no-index --find-links="$WHEELFREEZE_BASE"/wheels -r "$WHEELFREEZE_BASE"/requirements.freeze

cat > "$WHEELFREEZE_BASE"/venv/bin/run <<END
#!/bin/sh
. "$WHEELFREEZE_BASE"/venv/bin/activate
exec "\$@"
END
chmod +x "$WHEELFREEZE_BASE"/venv/bin/run
INSTALL
chmod +x wheelfreeze/install
