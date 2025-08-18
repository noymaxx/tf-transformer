# Transformer PT→EN com TensorFlow — Notebook em 3 Steps

Implementação compacta de um **Transformer** para tradução **Português → Inglês**, inspirada no tutorial oficial do TensorFlow Text. 

---

## 🔧 Requisitos

- Python 3.10+
- TensorFlow 2.16+ (ou versão estável do Colab)
- (Opcional) GPU com drivers NVIDIA + CUDA/cuDNN compatíveis
- Pacotes:
  ```
  tensorflow==2.16.1
  tensorflow-text==2.16.1
  tensorflow-datasets
  numpy
  matplotlib
  sacrebleu
  jupyter
  ```

---

## 🗂 Estrutura Sugerida do Repositório

```
.
├─ notebooks/
│  └─ transformer.ipynb
├─ scripts/
│  ├─ run_cpu.sh
│  ├─ run_gpu.sh
│  ├─ run_notebook_cpu.sh
│  ├─ run_notebook_gpu.sh
│  └─ export_savedmodel.sh
├─ requirements.txt
├─ README.md
└─ .gitignore
```

> Observação: toda a solução funciona apenas com o **notebook**. Os `scripts/` são utilitários para rodar localmente e comparar CPU vs GPU.

---

## ▶️ Como Executar
1. **Setup & Data**
   - Checa GPU, baixa `ted_hrlr_translate/pt_to_en` via TFDS, aplica `TextVectorization` com `[START]`/`[END]`, cria `tf.data`.
2. **Model & Train**
   - Implementa Transformer Encoder–Decoder (Keras), compila (Adam + CE), treina por poucas épocas e **mede tempo total**.
3. **Evaluate & Timing**
   - Decodificação *greedy* (PT→EN), exemplos qualitativos, BLEU (opcional, subset) e **resumo de timing** (CPU vs GPU).

---

## 💻 Execução Rápida (Local)

```bash
# 1) Ambiente
python -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate

# 2) Dependências
pip install -r requirements.txt

# 3) Executar notebook manualmente (Jupyter/VSCode) e rodar STEP 1→2→3
```

**Automático (executa notebook pelo shell e salva cópia executada):**
```bash
# CPU
EPOCHS=3 bash scripts/run_notebook_cpu.sh notebooks/transformer_translation_3steps.ipynb

# GPU
EPOCHS=3 bash scripts/run_notebook_gpu.sh notebooks/transformer_translation_3steps.ipynb
```

> Alternativa (se você tiver um `src/train.py`):  
> `bash scripts/run_cpu.sh --epochs 3 --batch-size 64`  
> `bash scripts/run_gpu.sh --epochs 3 --batch-size 64`

---

## Avaliação & Exemplos

- **Inferência**: decodificação *greedy* no imprime pares PT / PRED EN / REF EN.
- **BLEU (opcional)**: usa `sacrebleu` em subset (100–1000 sentenças) para ter uma noção de qualidade.

---

## Pontos Positivos 

- Integração **TFDS** simplifica download/preparo do dataset.
- `TextVectorization` resolve tokenização básica de forma rápida e reproduzível.
- Modelo Transformer em Keras é legível e modular; fácil de ajustar camadas/heads.
- **GPU** traz ganho significativo de tempo em batches médios/grandes.
- Organização em **3 passos** deixa o fluxo pedagógico e fácil de depurar.

## Pontos Negativos 

- Compatibilidade entre **tensorflow** e **tensorflow-text** é sensível a versões (cuidado no `requirements.txt`).
- Setup local de **CUDA/cuDNN** pode ser demorado; Colab reduz atrito, mas a performance varia conforme o runtime.
- Máscaras/atenção podem gerar mensagens de erro pouco claras para iniciantes.
- BLEU confiável demanda padronização de tokenização e mais dados/épocas.
- Treinos curtos servem mais para **comparação de tempo** do que para avaliar qualidade final.


