#!/bin/env python
# coding: utf-8

import sys
import jieba

exception = ['EMAIL_SUBJECT', '|BE_NAME|', '|PROGRAM_NAME|', 'EMAIL_BODY', '|PARTNER_NAME|',
             '|REROUTED_USER|', '|ENROLLMENT_ID|', '|GRACE_DAYS|', '|NEXT_APPROVER|', '|SLA|',
             '|EXP_DATE|', '|GRACE_DAYS|', '|EXP_DATE|', '|SLA_NEXT|', '|COMMENTS|']

for e in exception:
    jieba.add_word(e)


def jieba_cws(string):
    seg_list = jieba.cut(string.strip())   # .decode('utf8')
    return u' '.join(seg_list)    # .encode('utf8')


if __name__ == '__main__':
    if len(sys.argv) != 2:
        sys.stderr.write('usage: %s + train.zh' % __file__)
        sys.exit(-1)
    filename = sys.argv[1]
    #fileout = open("%s.cws"%filename, 'wb')
    with open(filename, 'r') as f:
        for line in f.readlines():
            line_cws = jieba_cws(line)
            sys.stdout.write(line_cws.strip())
            sys.stdout.write('\n')
            #print line_cws.strip()
    

