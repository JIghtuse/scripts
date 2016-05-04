#!/bin/sh

swap_directory=/swap_files
swap_file=${swap_directory}/swap0

swap_enable() {
    mkdir -p ${swap_directory}
    dd if=/dev/zero of="${swap_file}" bs=1M count="${size_mb}"
    chmod 0600 ${swap_file}
    mkswap ${swap_file}
    swapon ${swap_file}
}

swap_disable() {
    swapoff "${swap_file}"
    rm ${swap_file}
    rmdir ${swap_directory}
}

usage() {
    echo "usage: $0 [disable|enable <N>]"
}

operation=${1:-enable}

if [ "$operation" = "disable" ]; then
    swap_disable
elif [ "$operation" = "enable" ]; then
    if [ -z "$2" ]; then
        usage "$0"
        exit 1
    fi
    size_mb=${2}
    swap_enable
else
    usage "$0"
    exit 1
fi
