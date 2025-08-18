#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Uso: $0 <notebooks/transformer.ipynb>"
  exit 1
fi

NB="$1"
OUTDIR="outputs"
mkdir -p "${OUTDIR}"

echo "[run_notebook_gpu] Executando notebook em GPU: ${NB}"
jupyter nbconvert --to notebook --execute "${NB}" \
  --ExecutePreprocessor.timeout=-1 \
  --output "${OUTDIR}/$(basename "${NB%.ipynb}")__gpu_executed.ipynb" 
echo "[run_notebook_gpu] Saída: ${OUTDIR}/$(basename "${NB%.ipynb}")__gpu_executed.ipynb"
