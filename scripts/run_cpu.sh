
---

# scripts/run_cpu.sh

```bash
#!/usr/bin/env bash
set -euo pipefail

# Defaults
EPOCHS=3
BATCH=64
LOGDIR="logs"
LOGFILE="${LOGDIR}/cpu_$(date +%Y%m%d_%H%M%S).txt"

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --epochs|-e) EPOCHS="$2"; shift 2 ;;
    --batch-size|-b) BATCH="$2"; shift 2 ;;
    --logfile) LOGFILE="$2"; shift 2 ;;
    *) echo "Arg desconhecido: $1"; exit 1 ;;
  esac
done

mkdir -p "${LOGDIR}"

# Força CPU
export CUDA_VISIBLE_DEVICES=""

echo "[run_cpu] Iniciando treino em CPU: epochs=${EPOCHS}, batch=${BATCH}"
if python - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec("src.train") else 1)
PY
then
  /usr/bin/time -f "\n[run_cpu] Tempo total: %E (user %U sys %S)" \
    python -m src.train --epochs "${EPOCHS}" --batch-size "${BATCH}" 2>&1 | tee "${LOGFILE}"
else
  echo "[run_cpu] src.train não encontrado. Use o notebook:" | tee "${LOGFILE}"
  echo "  jupyter notebook notebooks/transformer.ipynb" | tee -a "${LOGFILE}"
  exit 1
fi

echo "[run_cpu] Logs salvos em: ${LOGFILE}"
