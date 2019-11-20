import json
import sys
# https://github.com/brightmart/nlp_chinese_corpus


def parse(filename):
    # f_save = open(filename_save, "w", encoding="utf-8")
    # f_en = open(filename_save + ".en", "w", encoding="utf-8")
    with open(filename, 'r', encoding="utf-8") as f:
        for line in f.readlines():
            tmp_data = json.loads(line.strip())
            ch = tmp_data['chinese']
            en = tmp_data['english']
            # f_save.write(ch.strip() + "\t" + en.strip() + "\n")
            print(ch + "\t" + en)

    # f_save.close()


# data = json.loads(json_str)

if __name__ == "__main__":
    filename = sys.argv[1]
    # filename, filename_save = 'D:\data\\nmt\\translation2019zh\\translation2019zh_valid.json', 'D:\data\\nmt\\translation2019'
    parse(filename)

