#!/usr/bin/env bash
#bin=../tensor2tensor/bin
#python $bin/t2t-trainer --registry_help

PROBLEM=translate_enzh_wmt32k_rev
MODEL=transformer
#HPARAMS=transformer_base_single_gpu
HPARAMS=transformer_base
HOME=`pwd`
DATA_DIR=$HOME/t2t_data
TMP_DIR=$DATA_DIR
TRAIN_DIR=$HOME/t2t_train/${PROBLEM}/$MODEL-$HPARAMS
echo ${TRAIN_DIR}

# Decode

DECODE_FILE=$DATA_DIR/valid.en-zh.zh
DECODE_RESULT_DIR=$HOME/decode_result

mkdir -p ${DECODE_RESULT_DIR}

DECODE_RESULT_FILE=${DECODE_RESULT_DIR}/translation.en

BEAM_SIZE=4
ALPHA=0.6

t2t-decoder \
  --data_dir=$DATA_DIR \
  --problem=$PROBLEM \
  --model=$MODEL \
  --hparams_set=$HPARAMS \
  --output_dir=$TRAIN_DIR \
  --decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA" \
  --hparams='batch_size=1024,shared_embedding_and_softmax_weights=0' \
  --decode_from_file=$DECODE_FILE \
  --decode_to_file=${DECODE_RESULT_FILE}

# See the translations
cat ${DECODE_RESULT_FILE}
