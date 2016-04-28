# Some scripts

## [`anonymize.sh`](anonymize.sh)

Replace all occurences of username in input files with some stub. It will try to
guess username if you will not pass one. Usage:

    ./anonymize.sh file1 file2 file3

Or:

    STUB=dog USER=nobody ./anonymize.sh file1 file2 file3


## [`notifyloop.sh`](notifyloop.sh)

Watches for changes in directory and calls user command/script on each change.
Idea based on ggreer's [fsevents-tools](https://github.com/ggreer/fsevents-tools).
Usage:

    # Reports any changes through notify-send
    ./notifyloop.sh /some/path/ notify-send notifyloop.sh

    # Copies firmware file to tftpboot directory on any change
    export FIRMWARE=/path/file1
    export TFTPBOOT=/var/lib/tftpboot/

    echo 'if grep MODIFY <<< $1; then cp "$FIRMWARE" "$TFTPBOOT"; fi' > copy_firmware.sh
    ./notifyloop.sh $FIRMWARE sh ./copy_firmware.sh

## [`filenames.py`](filenames.py)

Extracts unique filenames from grep-like output.

Usage:

    echo -e "dog\ncat\nfish\nhorse\nbird" > /tmp/file_01.txt
    echo -e "orange\napple\ngrape" > /tmp/file_02.txt
    echo -e "foo\nbar" > /tmp/file_03.txt
    # It can give wrong results if context lines has ':'
    grep -C2  or /tmp/file*.txt | ./filenames.py | xargs rm

## [`iptables_accept_all.sh`](iptables_accept_all.sh)

1. Saves backup.
2. Flushes all iptables rules, deletes all chains, accepts all traffic.

## [`ngs_forecast.py`](ngs_forecast.py)

Gets weather forecast for specified city from weather.ngs.ru and prints it.
Keeps cache in user cache directory, invalidates it after 10 minutes.

Usage:

    ngs_forecast.py Новосибирск
    ngs_forecast.py Moscow
