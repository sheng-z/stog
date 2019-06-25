#!/bin/bash

set -e

pred=$1
gold=$2

cp $pred $gold tools/amr-evaluation-tool-enhanced
cd tools/amr-evaluation-tool-enhanced && ./evaluation.sh test.pred.txt test.txt
