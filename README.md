# 中译英

Neural Machine Translation (Chinese-to-English) for AI_Challenger dataset.

# Requirenments

- python 3.6
- TensorFlow 1.12.0
- tensor2tensor 1.10.0
- jieba 0.39
- tensorflow-hub 0.4.0
- tensorflow_serving_api 

# Prepare Data
1. Download the dataset and put the dataset in ***raw_data*** file
2. Run the data preparation script

    cd train

    ./self_prepare.sh

# Train Model
Run the training script

./self_run.sh 


# Inference
Run the inference script

./self_infer.sh 

# 导出模型
./export_model.sh

# 启动服务端
(需要安装tensorflow serving，安装方式https://github.com/tensorflow/serving/blob/master/tensorflow_serving/g3doc/setup.md)

./server.sh

# 启动客户端
./client.sh


# References

Attention Is All You Need

Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin

Full text available at: https://arxiv.org/abs/1706.03762

Code availabel at: https://github.com/tensorflow/tensor2tensor
