# 中译英

Neural Machine Translation (Chinese-to-English) based on [tensor2tensor](https://github.com/tensorflow/tensor2tensor)

## Requirements

- python 3.6
- TensorFlow 1.12.0
- tensor2tensor 1.10.0
- jieba 0.39
- tensorflow-hub 0.4.0
- tensorflow_serving_api 

`pip install -r requirements.txt`

## Prepare Data(数据已经处理好，可跳过)
1. Download the dataset and put the dataset in ***data*** direction
2. Run the data preparation script
    `cd train`
    
    `./self_prepare.sh`
    
3. 数据保存在 train/t2t_data目录下:
    ![image](https://github.com/tcxdgit/MachineTranslation_t2t/tree/master/images/t2t_data.PNG)
    
    文件内容:
    ![image](https://github.com/tcxdgit/MachineTranslation_t2t/tree/master/images/corpus_zhen.png)
    
## Train Model
Run the training script

`./self_run.sh` 


## Inference（离线推理，用作评估模型效果）
Run the inference script

`./self_infer.sh` 

## 导出模型,导出成 tensorflow serving 可以调用的格式, 用来进行在线推理
`./export_model.sh`

## 启动服务端
需要安装tensorflow serving，[安装方式](https://github.com/tensorflow/serving/blob/master/tensorflow_serving/g3doc/setup.md)

`./server.sh`

## 启动客户端，实现翻译功能
`./client.sh`

## References

Attention Is All You Need

Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Lukasz Kaiser, Illia Polosukhin

Full text available at: https://arxiv.org/abs/1706.03762

Code availabel at: https://github.com/tensorflow/tensor2tensor
