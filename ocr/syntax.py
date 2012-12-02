#!/usr/bin/env python3
# -*- encoding: utf-8 -*-

import sys
import os.path
import string


def check(path):
    print(path + ':', end='')
    nb_errors = 0
    with open(path) as f:
        for n, l in enumerate(f.read().split('\n')):
            n = n + 1
            s = len(l)
            if s > 80:
                nb_errors += 1
                print('\n  * line {}: {} characters long'.format(n, s), end='')
            if len(l) >= 1 and (l[-1] in string.whitespace):
                nb_errors += 1
                print('\n  * line {}: trailing whitespace'.format(n), end='')
            if "open" in l:
                nb_errors += 1
                print('\n  * line {}: "open" statement used'.format(n), end='')
    if nb_errors == 0:
        print(' \033[92mOK\033[0m.')
    else:
        print('\n  \033[91mFAIL\033[0m: {} errors found'.format(nb_errors))


def main():
    for path in sys.argv[1:]:
        if os.path.exists(path):
            check(path)


if __name__ == '__main__':
    main()
