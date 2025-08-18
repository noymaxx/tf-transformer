#!/usr/bin/env bash
set -euo pipefail

OUTDIR="artifacts/savedmodel"
mkdir -p "${OUTDIR}"

if python - <<'PY'
import importlib.util, sys
sys.exit(0 if importlib.util.find_spec("src.evaluate") else 1)
PY
then
  echo "[export] Exportando via src.evaluate ..."
  python -m src.evaluate --export-savedmodel "${OUTDIR}"
  echo "[export] SavedModel em: ${OUTDIR}"
else
  echo "[export] src.evaluate não encontrado."
  echo "Se estiver no notebook, exporte manualmente (tf.saved_model.save) para: ${OUTDIR}"
fi
