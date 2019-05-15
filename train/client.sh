#!/usr/bin/env bash
HOME=`pwd`
DATA_DIR=$HOME/t2t_data
PROBLEM_DIR=$HOME/self_script

#t2t-query-server \
# --server=3.2.1.10:8500 \
# --servable_name=transformer \
# --t2t_usr_dir=$PROBLEM_DIR \
# --problem=translate_zhen_ai \
# --data_dir=${DATA_DIR}

python self_query.py \
    --server=100.0.1.205:8500 \
    --servable_name=transformer \
    --t2t_usr_dir=$PROBLEM_DIR \
    --problem=translate_zhen_ai \
    --data_dir=${DATA_DIR}
