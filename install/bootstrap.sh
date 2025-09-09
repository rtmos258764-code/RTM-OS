#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REYN_BIN="$ROOT/bin/reyn"

echo "[bootstrap] setting exec perms…"
chmod +x "$REYN_BIN" \
  "$ROOT/scripts/hooks/pre-commit" \
  "$ROOT/scripts/lib/"*.sh \
  "$ROOT/tools/runner/run.sh" \
  "$ROOT/modules/"*/run.sh

# optional: install local pre-commit hook if repo is git
if [ -d "$ROOT/.git" ]; then
  echo "[bootstrap] wiring pre-commit hook…"
  mkdir -p "$ROOT/.git/hooks"
  ln -sf "../../scripts/hooks/pre-commit" "$ROOT/.git/hooks/pre-commit"
fi

# ensure configs exist
if [ ! -f "$ROOT/configs/.env" ]; then
  echo "[bootstrap] creating configs/.env from .env.example"
  cp "$ROOT/.env.example" "$ROOT/configs/.env"
fi

# add shorthand to PATH via ~/.local/bin
DEST="$HOME/.local/bin"
mkdir -p "$DEST"
ln -sf "$REYN_BIN" "$DEST/reyn"

echo "[bootstrap] testing runner…"
"$REYN_BIN" ping

echo "[bootstrap] done. Make sure ~/.local/bin is on PATH. If not, add:"
echo '  echo "export PATH=$HOME/.local/bin:$PATH" >> ~/.bashrc && source ~/.bashrc'
