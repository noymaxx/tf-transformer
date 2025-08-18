#!/usr/bin/env bash
set -euo pipefail

EPOCHS=3
BATCH=64
LOGDIR="logs"
LOGFILE="${LOGDIR}/gpu_$(date +%Y%m%d_%H%M%S).txt"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --epochs|-e) EPOCHS="$2"; shift 2 ;;
    --batch-size|-b) BATCH="$2"; shift 2 ;;
    --logfile) LOGFILE="$2"; shift 2 ;;
    *) echo "Arg desconhecido: $1"; exit 1 ;;
  esac
done

mkdir -p "${LOGDIR}"

echo "[run_gpu] Iniciando treino em GPU: epochs=${EPOCHS}, batch=${BATCH}"

if python - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec("src.train") else 1)
PY
then
  /usr/bin/time -f "\n[run_gpu] Tempo total: %E (user %U sys %S)" \
    python -m src.train --epochs "${EPOCHS}" --batch-size "${BATCH}" 2>&1 | tee "${LOGFILE}"
else
  echo "[run_gpu] src.train não encontrado. Use o notebook:" | tee "${LOGFILE}"
  echo "  jupyter notebook notebooks/transformer.ipynb" | tee -a "${LOGFILE}"
  exit 1
fi

echo "[run_gpu] Logs salvos em: ${LOGFILE}"
