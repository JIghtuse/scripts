#!/bin/bash

usage() {
    echo "Usage: $0 watch_path command|./script.sh"
    exit "$1"
}

report_error() {
    echo "$1"
    notify-send --urgency=critical "$0" "$1"
    exit 1
}

if [[ $1 == "--help" ]]; then
    usage 0
fi

if [[ $# -lt 2 ]]; then
    usage 1
fi

WATCH_PATH="$1"
if [[ ! -e $WATCH_PATH ]]; then
    report_error "No such path: $WATCH_PATH"
fi

shift
COMMAND=("$@")

while true; do
    inotifywait -q -m "$WATCH_PATH" | while read CHANGE; do
        if grep DELETE_SELF <<< ${CHANGE}; then
            report_error "Watch path $WATCH_PATH disappeared"
        fi
        "${COMMAND[@]}" "${CHANGE}"
    done
done
