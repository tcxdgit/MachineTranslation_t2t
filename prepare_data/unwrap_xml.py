# coding: utf-8
import sys
import re


def extract_text(line):
    pattern = re.compile(r'<seg id=.*>(.*)</seg>')
    if pattern.search(line):
        line = pattern.search(line).group(1).strip()
        return line
    return False


if __name__ == '__main__':
    # print(sys.stdout.encoding)
    if len(sys.argv) != 2:
        sys.stderr.write('usage: %s + input.sgm' % __file__)
        sys.exit(-1)
    filename = sys.argv[1]
    with open(filename, 'r', encoding="utf-8") as f:
        for line in f.readlines():
            new_line = extract_text(line)
            if new_line:
                # print(new_line.strip())
                sys.stdout.write(new_line.strip())
                # print('\n')
                sys.stdout.write('\n')

