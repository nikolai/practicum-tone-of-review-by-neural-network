#!/usr/bin/env bash
echo 'Installing kernel deps in venv...'
[ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ] || eval 'env START_SH_FROM_FISH=1 bash (status filename) $argv; and source (dirname (status filename))/.venv/bin/activate.fish; or return 1; return 0'
eval '
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

python3 -c "import sys; sys.exit(sys.version_info < (3, 9))" \
  || { echo "нужен python 3.9+"; exit 1; }

[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -qU pip
.venv/bin/pip install -q -r requirements_kernel.txt
.venv/bin/python -m ipykernel install --user --name=sprint28-neural-networks-pytorch --display-name "sprint28-neural-networks-pytorch"

if [ -z "${START_SH_FROM_FISH:-}" ] && [ "$0" != "${BASH_SOURCE[0]}" ]; then
  source .venv/bin/activate
elif [ -z "${START_SH_FROM_FISH:-}" ]; then
  parent=$(ps -p "$PPID" -o comm= 2>/dev/null || true)
  case "$parent" in
    *fish*) echo "fish: source ${BASH_SOURCE[0]}" ;;
  esac
fi
'
