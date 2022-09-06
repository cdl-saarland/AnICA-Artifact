#!/usr/bin/env bash

# This script samples random basic blocks and evaluates them using several
# throughput predictors to obtain the data similar to the one used for the
# heatmap figure in the paper.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
BASE_DIR="$SCRIPT_DIR/../"

set -ex

$BASE_DIR/anica_ui/lib/anica/scripts/anica_overview.py \
    --seed 23456 \
    --config $BASE_DIR/artifact_configs/abstraction/len4.json \
    --output $BASE_DIR/results/new/overview_data.csv \
    --num-experiments 1000 \
    llvm-mca.13-r+a.hsw llvm-mca.9-r+a.hsw uica.hsw difftune.artifact.hsw \
    osaca.0.4.6.hsw ithemal.bhive.hsw


