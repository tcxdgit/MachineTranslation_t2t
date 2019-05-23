# coding:utf-8

import re
import jieba
import sys
import os
import unicodedata

sys.path.append("../")

# jieba.load_userdict("prepare_data/userdict.txt")

# words = ['EMAIL_SUBJECT', '\|BE_NAME\|', '|PROGRAM_NAME|', 'EMAIL_BODY', '|PARTNER_NAME|',
#              '|REROUTED_USER|', '|ENROLLMENT_ID|', '|GRACE_DAYS|', '|NEXT_APPROVER|', '|SLA|',
#              '|EXP_DATE|', '|GRACE_DAYS|', '|EXP_DATE|', '|SLA_NEXT|', '|COMMENTS|', 'TRACK_NAME']

# for w in words:
#     # jieba.add_word(w)
#     jieba.suggest_freq(w, True)

jieba.suggest_freq('字段', True)


# 针对  “ 英文 （中文）”
def ch_en_split(string):
    matchObj = re.match(r"([A-Za-z0-9\/\_\\ \-]+) *([\(\（]+.*[\u4e00-\u9fa5]+.*[\)\）]+)", string)
    if matchObj:
        ch = matchObj.group(2)
        return ch.strip("()（）")
    else:
        return string


# parallel_path = "/tcxia/nmt_data/Cisco"
def detect_length(zh, en, threshold=9):
    ratio = float(len(zh.split(" "))) / len(en.split(" "))
    if ratio > threshold or ratio < 1.0/threshold:
        print(zh)
        print(en)
        print("ratio: {}. not normal !!!".format(ratio))

        print("\n")


def is_date(zh):
    # 2009   年   5   月   13   日
    if re.fullmatch("[0-9]+ *年 *[0-9]+ *月 *[0-9]+ *日", zh.strip()):
        return True
    else:
        return False


def process(data_path):
    # 去重
    # os.system("awk -F '\t' '{if (!S[$1]++) {print $1'\t'$2}}' ${TMP_DIR}/Cisco-General-parallel > ${TMP_DIR}/Cisco_deduplicate")
    #
    # os.system("awk '{if(NR%1000 ==1) print $0}' ${TMP_DIR}/Cisco_deduplicate > ${TMP_DIR}/Cisco_dev")
    # os.system("awk '{if(NR%1000 !=1) print $0}' ${TMP_DIR}/Cisco_deduplicate > ${TMP_DIR}/Cisco_train")
    #
    # os.system("awk - F '\t' '{print $1}' ${TMP_DIR} / Cisco_train > ${DATA_DIR} / train.zh")
    # os.system("awk - F '\t' '{print $2}' ${TMP_DIR} / Cisco_train > ${DATA_DIR} / train.en")
    #
    # os.system("awk - F '\t' '{print $1}' ${TMP_DIR} / Cisco_dev > ${DATA_DIR} / valid.zh")
    # os.system("awk - F '\t' '{print $2}' ${TMP_DIR} / Cisco_dev > ${DATA_DIR} / valid.en")

    # os.system("bash prepare_cisco.sh")

    os.system("paste {}/train_wc.zh {}/train_wc.en > {}/train_wc".format(data_path, data_path, data_path))

    with open(os.path.join(data_path, "train_wc"), "r", encoding="utf-8") as f_corpus:
        for line in f_corpus.readlines():
            # print(line)
            zh, en = line.strip().split("\t")

            # 本地化中，一些文本不翻译，会直接保留原文
            # zh中不包含中文字符
            if not re.search(r"[\u4e00-\u9fa5]", zh):
                # print("not chinese: {}".format(zh))
                continue

            # en中有中文字符
            if re.search(r"[\u4e00-\u9fa5]", en):
                # print("chinese in en corpus: {}".format(en))
                continue


            zh = unicodedata.normalize('NFKC', zh)  # 全角转半角

            # 去除多余空格
            zh = re.sub("[ ]+", " ", zh)
            en = re.sub("[ ]+", " ", en)


            if is_date(zh):
                # TODO：日期，不做检测，直接保存
                # print("date: {}".format(zh))
                continue

            detect_length(zh, en, threshold=9)


if __name__ == "__main__":
    process("/MT/tcxia/MachineTranslation_t2t/train/t2t_data")

