#!/usr/bin/env bash

DATA_DIR=./t2t_data
#TMP_DIR=../raw_data
TMP_DIR=/MT/tcxia/nmt_data/Cisco
mkdir -p ${DATA_DIR}

# 去重
awk -F '\t' '{if (!S[$1]++) {print $1"\t"$2}}' ${TMP_DIR}/Cisco-General-parallel > ${TMP_DIR}/Cisco_deduplicate


awk '{if(NR%1000 ==1) print $0}' ${TMP_DIR}/Cisco_deduplicate > ${TMP_DIR}/Cisco_dev
awk '{if(NR%1000 !=1) print $0}' ${TMP_DIR}/Cisco_deduplicate > ${TMP_DIR}/Cisco_train


awk -F '\t' '{print $1}' ${TMP_DIR}/Cisco_train > ${DATA_DIR}/train.zh
awk -F '\t' '{print $2}' ${TMP_DIR}/Cisco_train > ${DATA_DIR}/train.en

awk -F '\t' '{print $1}' ${TMP_DIR}/Cisco_dev > ${DATA_DIR}/valid.zh
awk -F '\t' '{print $2}' ${TMP_DIR}/Cisco_dev > ${DATA_DIR}/valid.en

#awk -F '\t' '{print $3}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.en
#awk -F '\t' '{print $4}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.zh

#unwrap xml for valid data and test data
#python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_zh.sgm >${DATA_DIR}/valid.zh
#python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_en.sgm >${DATA_DIR}/valid.en

#Prepare Data

##Chinese words segmentation
#python prepare_data/jieba_cws.py ${TMP_DIR}/train.zh > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang1
#python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang1
python prepare_data/jieba_cws.py ${DATA_DIR}/train.zh > ${DATA_DIR}/train_wc.zh
python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/valid_wc.zh
#python prepare_data/jieba_cws.py ${DATA_DIR}/test.zh > ${DATA_DIR}/test_wc.zh

## Tokenize and Lowercase English training data
#cat ${TMP_DIR}/train.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang2
#cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang2

cat ${DATA_DIR}/train.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/train_wc.en
cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/valid_wc.en
#cat ${DATA_DIR}/test.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/test_wc.en
