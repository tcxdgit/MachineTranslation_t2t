#!/usr/bin/env bash

#!/usr/bin/env bash

#Download the dataset and put the dataset in ../raw_data file

# 解决docker编码问题
export LANG=C.UTF-8
HOME=`pwd`

DATA_DIR=$HOME/t2t_data


# 1. AI Challenger

##TMP_DIR=../raw_data
#TMP_DIR=../processed_data
#mkdir -p ${DATA_DIR}
##
#awk -F '\t' '{print $3}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_trainingset_20190228.txt > ${TMP_DIR}/train.en
#awk -F '\t' '{print $4}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_trainingset_20190228.txt > ${TMP_DIR}/train.zh
#
#awk -F '\t' '{print $3}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.en
#awk -F '\t' '{print $4}' ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_testset_20190228.txt > ${DATA_DIR}/test.zh
#
##unwrap xml for valid data and test data
#python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_zh.sgm >${DATA_DIR}/valid.zh
#python prepare_data/unwrap_xml.py ${TMP_DIR}/ai_challenger_MTEnglishtoChinese_validationset_20180823_en.sgm >${DATA_DIR}/valid.en
#
##Prepare Data
#
###Chinese words segmentation
##python prepare_data/jieba_cws.py ${TMP_DIR}/train.zh > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang1
##python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang1
#python prepare_data/jieba_cws.py ${TMP_DIR}/train.zh > ${DATA_DIR}/train_wc.zh
#python prepare_data/jieba_cws.py ${DATA_DIR}/valid.zh > ${DATA_DIR}/valid_wc.zh
#python prepare_data/jieba_cws.py ${DATA_DIR}/test.zh > ${DATA_DIR}/test_wc.zh
#
### Tokenize and Lowercase English training data
##cat ${TMP_DIR}/train.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_train.lang2
##cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en | tr A-Z a-z > ${DATA_DIR}/ai_zhen_32768k_tok_dev.lang2
#
#cat ${TMP_DIR}/train.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/train_wc.en
#cat ${DATA_DIR}/valid.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/valid_wc.en
#cat ${DATA_DIR}/test.en | prepare_data/tokenizer.perl -l en > ${DATA_DIR}/test_wc.en


# 2. NJU cwmt

TMP_DIR=/tcxia/nmt_data/cwmt
rm -f ${DATA_DIR}/train_tmp.zh
rm -f ${DATA_DIR}/train_tmp.en
#rm -f ${DATA_DIR}/dev_cwmt.zh
#rm -f ${DATA_DIR}/dev_cwmt.en

# parallel
parallel=$TMP_DIR/parallel

for d in `ls -d $parallel/*/`
do
    echo ------------${d}-------------
    for file in $d/*
    do
        if [[ $file == *_ch.txt ]] || [[ $file == *_cn.txt ]];then
            cat $file >> ${DATA_DIR}/train_tmp.zh
            echo `wc -l $file`
        elif [[ $file == *_en.txt ]];then
            cat $file >> ${DATA_DIR}/train_tmp.en
            echo `wc -l $file`
        elif [[ $file == *newsdev2017-zhen-src.zh.sgm* ]];then
            python prepare_data/unwrap_xml.py $file >> ${DATA_DIR}/dev_tmp.zh
            echo `wc -l $file`
        elif [[ $file == *newsdev2017-zhen-ref.en.sgm* ]];then
            python prepare_data/unwrap_xml.py $file >> ${DATA_DIR}/dev_tmp.en
            echo `wc -l $file`
        fi
        echo
    done
done


wc -l ${DATA_DIR}/train_tmp.*

# multi-reference
mr=$TMP_DIR/multi-reference
python prepare_data/deduplicate_xml.py $mr
for d in `ls -d $mr/*/`
do
    echo ------------${d}-------------
    if [[ $d == HTRDP* ]];then
        rename _ref_en_zh_dial _en_zh_dial_ref $d/*
        rename _ref_en_zh_essa _en_zh_essa_ref $d/*
        rename _ref_en_zh_writ _en_zh_writ_ref $d/*

        rename _src_en_zh_dial _en_zh_dial_src $d/*
        rename _src_en_zh_essa _en_zh_essa_src $d/*
        rename _src_en_zh_writ _en_zh_writ_src $d/*

        rename _ref_zh_en_dial _zh_en_ref_dial $d/*
        rename _ref_zh_en_essa _zh_en_ref_essa $d/*
        rename _ref_zh_en_writ _zh_en_ref_writ $d/*

        rename _src_zh_en_dial _zh_en_src_dial $d/*
        rename _src_zh_en_essa _zh_en_src_essa $d/*
        rename _src_zh_en_writ _zh_en_src_writ $d/*
        echo $d
    fi

    for file in $d/*

    do
        echo $file
#        if [[ $file == *ce-*-source.txt ]] || [[ $file == *ec-*-ref.txt ]];then
#            cat $file >> ${DATA_DIR}/train_tmp.zh
#            echo `wc -l $file`
#        elif [[ $file == ec-*-source.txt ]] || [[ $file == ce-*-ref.txt ]];then
#            cat $file >> ${DATA_DIR}/train_tmp.en
#            echo `wc -l $file`
        if [[ $file == *ce-*-realsrc.xml ]] || [[ $file == *ec-*-ref.xml ]] || [[ $file == *_zh_en_*_src.xml ]] || [[ $file == *_en_zh_*_ref.xml ]] || [[ $file == *ce-*-source.xml ]] || [[ $file == *ce_test.xml ]] || [[ $file == *ec_ref.xml ]];then
            python prepare_data/unwrap_xml.py $file >> ${DATA_DIR}/train_tmp.zh
            cat $file | grep -o "</seg>" | wc -l
        elif [[ $file == *ce-*-ref.xml ]] || [[ $file == *ec-*-realsrc.xml ]] || [[ $file == *_zh_en_*_ref.xml ]] || [[ $file == *_en_zh_*_src.xml ]] || [[ $file == *ec-*-source.xml ]] || [[ $file == *ce_ref.xml ]] || [[ $file == *ec_test.xml ]];then
            python prepare_data/unwrap_xml.py $file >> ${DATA_DIR}/train_tmp.en
            cat $file | grep -o "</seg>" | wc -l
        fi
        echo
    done
done

wc -l ${DATA_DIR}/train_tmp.*

# dev
dev=$TMP_DIR/dev

python prepare_data/unwrap_xml.py $dev/NJU-newsdev2018-enzh/*ref.xml >> ${DATA_DIR}/train_tmp.zh
python prepare_data/unwrap_xml.py $dev/NJU-newsdev2018-enzh/*src.xml >> ${DATA_DIR}/train_tmp.en


python prepare_data/unwrap_xml.py $dev/NJU-newsdev2018-zhen/*src.xml >> ${DATA_DIR}/train_tmp.zh
python prepare_data/unwrap_xml.py $dev/NJU-newsdev2018-zhen/*ref.xml >> ${DATA_DIR}/train_tmp.en

wc -l ${DATA_DIR}/train_tmp.*

paste ${DATA_DIR}/train_tmp.zh ${DATA_DIR}/train_tmp.en > ${DATA_DIR}/train_tmp

awk -F '\t' '{if (!S[$1]++) {print $1"\t"$2}}' ${DATA_DIR}/train_tmp > ${DATA_DIR}/train_deduplicate
#awk -F '\t' '{if (!S[$1]++) {print $1"\t"$2}}' ${DATA_DIR}/train_tmp.en > test_del.en
wc -l ${DATA_DIR}/train_tmp ${DATA_DIR}/train_deduplicate

awk -F '\t' '{print $1}' ${DATA_DIR}/train_deduplicate > ${DATA_DIR}/train_cwmt.zh
awk -F '\t' '{print $2}' ${DATA_DIR}/train_deduplicate > ${DATA_DIR}/train_cwmt.en


# 3. brightmart/nlp_chinese_corpus

TMP_DIR=/tcxia/nmt_data/translation2019zh
python prepare_data/json_parse.py $TMP_DIR/translation2019zh_train.json > ${DATA_DIR}/train_tmp
python prepare_data/json_parse.py $TMP_DIR/translation2019zh_valid.json >> ${DATA_DIR}/train_tmp

awk -F '\t' '{if (!S[$1]++) {print $1"\t"$2}}' ${DATA_DIR}/train_tmp > ${DATA_DIR}/train_deduplicate
wc -l ${DATA_DIR}/train_tmp ${DATA_DIR}/train_deduplicate

awk -F '\t' '{print $1}' ${DATA_DIR}/train_deduplicate > ${DATA_DIR}/train_trans2019.zh
awk -F '\t' '{print $2}' ${DATA_DIR}/train_deduplicate > ${DATA_DIR}/train_trans2019.en


