# AMR Parsing as Sequence-to-Graph Transduction

Code for the AMR Parser 
in our ACL 2019 paper "[AMR Parsing as Sequence-to-Graph Transduction](https://arxiv.org/pdf/1905.08704.pdf)".   

If you find our code is useful, please cite:
```
@inproceedings{zhang-etal-2018-stog,
    title = "{AMR Parsing as Sequence-to-Graph Transduction}",
    author = "Zhang, Sheng and
      Ma, Xutai and
      Duh, Kevin and
      Van Durme, Benjamin",
    booktitle = "Proceedings of the 57th Annual Meeting of the Association for Computational Linguistics (Volume 1: Long Papers)",
    month = jul,
    year = "2019",
    address = "Florence, Italy",
    publisher = "Association for Computational Linguistics",
}
```

## 1. Environment Setup


The code has been tested on **Python 3.6** and **PyTorch 0.4.1**. 
All other dependencies are listed in [requirements.txt](requirements.txt).

Via conda:
```bash
conda create -n stog python=3.6
source activate stog
pip install -r requirements.txt
```

## 2. Data Preparation

Download Artifacts:
```bash
./scripts/download_artifacts.sh
```

Assuming that you're working on AMR 2.0 ([LDC2017T10](https://catalog.ldc.upenn.edu/LDC2017T10)),
unzip the corpus to `data/AMR/LDC2017T10`, and make sure it has the following structure:
```bash
(stog)$ tree data/AMR/LDC2017T10 -L 2
data/AMR/LDC2017T10
├── data
│   ├── alignments
│   ├── amrs
│   └── frames
├── docs
│   ├── AMR-alignment-format.txt
│   ├── amr-guidelines-v1.2.pdf
│   ├── file.tbl
│   ├── frameset.dtd
│   ├── PropBank-unification-notes.txt
│   └── README.txt
└── index.html
```

Prepare training/dev/test data:
```bash
./scripts/prepare_data.sh -v 2 -p data/AMR/LDC2017T10
```

## 3. Feature Annotation

We use [Stanford CoreNLP](https://stanfordnlp.github.io/CoreNLP/index.html) (version **3.9.2**) for lemmatizing, POS tagging, etc.

First, start a CoreNLP server following the [API documentation](https://stanfordnlp.github.io/CoreNLP/corenlp-server.html#api-documentation).


Then, annotate AMR sentences:
```bash
./scripts/annotate_features.sh data/AMR/amr_2.0
```

## 4. Data Preprocessing

```bash
./scripts/preprocess_2.0.sh
```

## 5. Training

Make sure that you have at least two GeForce GTX TITAN X GPUs to train the full model.

```bash
python -u -m stog.commands.train params/stog_amr_2.0.yaml
```

## 6. Prediction

```bash
python -u -m stog.commands.predict \
    --archive-file ckpt-amr-2.0 \
    --weights-file ckpt-amr-2.0/best.th \
    --input-file data/AMR/amr_2.0/test.txt.features.preproc \
    --batch-size 32 \
    --use-dataset-reader \
    --cuda-device 0 \
    --output-file test.pred.txt \
    --silent \
    --beam-size 5 \
    --predictor STOG
```

## 7. Data Postprocessing    
```bash
./script/postprocess_2.0.sh test.pred.txt
```

## 8. Evaluation

```bash
./scripts/compute_smatch.sh test.pred.txt data/AMR/amr_2.0/test.txt
```

## Acknowledgements

We adopted some modules or code snippets from [AllenNLP](https://github.com/allenai/allennlp), 
[OpenNMT-py](https://github.com/OpenNMT/OpenNMT-py)
 and [NeuroNLP2](https://github.com/XuezheMax/NeuroNLP2).
Thanks to these open-source projects!

## License
[MIT](LICENSE)
