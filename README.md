# Some scripts

## anonymize.sh

Replace all occurences of username in input files with some stub. It will try to
guess username if you will not pass one. Usage:

    ./anonymize.sh file1 file2 file3

Or:

    STUB=dog USER=nobody ./anonymize.sh file1 file2 file3


## notifyloop.sh

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