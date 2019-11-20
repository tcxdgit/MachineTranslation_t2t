#!/usr/bin/env bash
#bin=../tensor2tensor/bin
#python $bin/t2t-trainer --registry_help

PROBLEM=translate_zhen_ai
MODEL=transformer
HPARAMS=transformer_base
#HPARAMS=transformer_big
HOME=`pwd`
DATA_DIR=$HOME/t2t_data
#TMP_DIR=${DATA_DIR}
TRAIN_DIR=$HOME/t2t_train/${PROBLEM}/${MODEL}-${HPARAMS}
PROBLEM_DIR=$HOME/self_script

# Decode

BEAM_SIZE=4
ALPHA=0.6
#DECODE_FILE=${DATA_DIR}/valid.en-zh.zh
DECODE_FILE=${DATA_DIR}/valid_wc.zh


#DECODE_FILE=$DATA_DIR/decode_this.txt
#echo "我快饿死了，你呢？" >> $DECODE_FILE
#echo "我来自浙江杭州" >> $DECODE_FILE

DECODE_RESULT_DIR=$HOME/decode_result

mkdir -p ${DECODE_RESULT_DIR}

DECODE_RESULT_FILE=${DECODE_RESULT_DIR}/translation.en

t2t-decoder \
  --t2t_usr_dir=$PROBLEM_DIR\
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
#cat ${DECODE_RESULT_FILE}


# Evaluate the BLEU score
# Note: Report this BLEU score in papers, not the internal approx_bleu metric.
t2t-bleu --translation=${DECODE_RESULT_FILE} --reference=${DATA_DIR}/valid_wc.en
