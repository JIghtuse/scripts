# Some scripts

## anonymize.sh

Replace all occurences of username in input files with some stub. It will try to
guess username if you will not pass one. Usage:

    ./anonymize.sh file1 file2 file3

Or:

    STUB=dog USER=nobody ./anonymize.sh file1 file2 file3
