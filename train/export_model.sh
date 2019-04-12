#!/usr/bin/env bash

HOME=`pwd`

PROBLEM=translate_zhen_ai
DATA_DIR=$HOME/t2t_data
MODEL=transformer
HPARAMS=transformer_base
PROBLEM_DIR=$HOME/self_script
TRAIN_DIR=$HOME/t2t_train/${PROBLEM}/${MODEL}-${HPARAMS}


t2t-exporter \
    --t2t_usr_dir=${PROBLEM_DIR} \
    --problem=${PROBLEM} \
    --data_dir=${DATA_DIR} \
    --model=${MODEL} \
    --hparams_set=${HPARAMS} \
    --output_dir=${TRAIN_DIR}

