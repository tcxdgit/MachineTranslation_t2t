#!/bin/env python
# coding: utf-8

import sys
import jieba
import re

sys.path.append("../")

# jieba.load_userdict("prepare_data/userdict.txt")

# words = ['EMAIL_SUBJECT', '\|BE_NAME\|', '|PROGRAM_NAME|', 'EMAIL_BODY', '|PARTNER_NAME|',
#              '|REROUTED_USER|', '|ENROLLMENT_ID|', '|GRACE_DAYS|', '|NEXT_APPROVER|', '|SLA|',
#              '|EXP_DATE|', '|GRACE_DAYS|', '|EXP_DATE|', '|SLA_NEXT|', '|COMMENTS|', 'TRACK_NAME']

# for w in words:
#     # jieba.add_word(w)
#     jieba.suggest_freq(w, True)

jieba.suggest_freq('字段', True)


def jieba_cws(string):
    seg_list = jieba.cut(string.strip())   # .decode('utf8')
    return u' '.join(seg_list)    # .encode('utf8')


def ch_en_split(string):
    # matchObj = re.fullmatch(r"([A-Za-z0-9\/\_\\ \-\.\]+) *([\(\（]+.*[\u4e00-\u9fa5]+.*[\)\）]+)", string)
    string = string.strip()
    matchObj = re.fullmatch(r"([^\u4e00-\u9fa5]+) *([\(\（]+.*[\u4e00-\u9fa5]+.*[\)\）]+)", string)
    if matchObj:
        ch = matchObj.group(2)
        return ch.strip("()（）")
    else:
        return string


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write('usage: %s + train.zh' % __file__)
        sys.exit(-1)
    filename = sys.argv[1]
    #fileout = open("%s.cws"%filename, 'wb')
    with open(filename, 'r') as f:
        for line in f.readlines():
            line = ch_en_split(line)
            line_cws = jieba_cws(line)
            sys.stdout.write(line_cws.strip())
            sys.stdout.write('\n')
            #print line_cws.strip()
    

