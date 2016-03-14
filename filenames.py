#!/usr/bin/python3

# extracts filename from grep-like output
def get_filename(line):
    sp = line.split(':', 1)
    if len(sp) != 2: # No colon
        return None
    return sp[0]

def not_none(x):
    return x is not None

def uniq_filenames(lines):
    filenames = set(get_filename(line) for line in lines)
    return filter(not_none, filenames)

if __name__ == "__main__":
    import sys

    for fname in uniq_filenames(sys.stdin):
        print(fname)
