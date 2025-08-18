#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Uso: $0 <notebooks/transformer.ipynb>"
  exit 1
fi

NB="$1"
OUTDIR="outputs"
mkdir -p "${OUTDIR}"
export CUDA_VISIBLE_DEVICES=""

echo "[run_notebook_cpu] Executando notebook em CPU: ${NB}"
jupyter nbconvert --to notebook --execute "${NB}" \
  --ExecutePreprocessor.timeout=-1 \
  --output "${OUTDIR}/$(basename "${NB%.ipynb}")__cpu_executed.ipynb"
echo "[run_notebook_cpu] Saída: ${OUTDIR}/$(basename "${NB%.ipynb}")__cpu_executed.ipynb"
