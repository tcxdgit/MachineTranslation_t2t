#!/usr/bin/env bash

export CUDA_VISIBLE_DEVICES=5

HOME=`pwd`
MODEL_PATH=$HOME/t2t_train/translate_zhen_ai/transformer-transformer_base/export


# 需要安装tensorflow serving
tensorflow_model_server \
 --port=8502 \
 --model_name=transformer \
 --model_base_path=$MODEL_PATH
