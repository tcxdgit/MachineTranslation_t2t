#!/usr/bin/env bash

#Download the dataset and put the dataset in ../raw_data file

# 解决docker编码问题
export LANG=C.UTF-8

DATA_DIR=./t2t_data
#TMP_DIR=../raw_data
TMP_DIR=../processed_data
mkdir -p ${DATA_DIR}
#
awk -F '\t' '{print $3}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_trainingset_20190228.txt > ${TMP_DIR}/train.en
awk -F '\t' '{print $4}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_trainingset_20190228.txt > ${TMP_DIR}/train.zh

awk -F '\t' '{print $3}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.en
awk -F '\t' '{print $4}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.zh

#unwrap xml for valid data and test data
python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_zh.sgm >${DATA_DIR}/valid.zh
python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_en.sgm >${DATA_DIR}/valid.en

#Prepare Data

##Chinese words segmentation
#python prepare_data/jieba_cws.py ${TMP_DIR}/train.zh > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang1
#python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang1
python prepare_data/jieba_cws.py ${TMP_DIR}/train.zh > ${DATA_DIR}/train_wc.zh
python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/valid_wc.zh
python prepare_data/jieba_cws.py ${DATA_DIR}/test.zh > ${DATA_DIR}/test_wc.zh

## Tokenize and Lowercase English training data
#cat ${TMP_DIR}/train.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang2
#cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang2

cat ${TMP_DIR}/train.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/train_wc.en
cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/valid_wc.en
cat ${DATA_DIR}/test.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/test_wc.en
