#!/usr/bin/env bash

# 选择GPU
export CUDA_VISIBLE_DEVICES="7"
PROBLEM=translate_zhen_ai
MODEL=transformer
#HPARAMS=transformer_base_single_gpu
HPARAMS=transformer_base
#HPARAMS=transformer_big
HOME=`pwd`
DATA_DIR=$HOME/t2t_data
TMP_DIR=${DATA_DIR}
PROBLEM_DIR=$HOME/self_script

mkdir -p ${DATA_DIR} ${TMP_DIR}

# Generate data
t2t-datagen \
  --t2t_usr_dir=${PROBLEM_DIR}\
  --data_dir=${DATA_DIR} \
  --tmp_dir=${TMP_DIR} \
  --problem=${PROBLEM}

# Train
# *  If you run out of memory, add --hparams='batch_size=2048' or even 1024.
#PROBLEM=${PROBLEM}_rev
#echo "PROBLEM:" $PROBLEM "DATA_DIR:" $DATA_DIR "MODEL:" $MODEL "HPARAMS:" $HPARAMS "TRAIN_DIR:" $TRAIN_DIR

TRAIN_DIR=$HOME/t2t_train/${PROBLEM}/${MODEL}-${HPARAMS}
mkdir -p ${TRAIN_DIR}

t2t-trainer \
  --t2t_usr_dir=${PROBLEM_DIR}\
  --data_dir=${DATA_DIR} \
  --problem=${PROBLEM} \
  --model=${MODEL} \
  --hparams_set=${HPARAMS} \
  --train_steps=500000 \
  --output_dir=${TRAIN_DIR}


# --hparams=batch_size=1024