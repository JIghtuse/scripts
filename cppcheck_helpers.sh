#!/bin/bash

CPPCHECK=/usr/bin/cppcheck
INCLUDES_FILE=includes
LIB_OPTIONS=std

OUTPUT_FORMAT=${1-txt}
SCAN_DIRECTORIES=${SCAN_DIRECTORIES:-.}

if [[ "$OUTPUT_FORMAT" == "xml" ]]; then
    OUTPUT_OPTIONS="--xml-version=2"
fi

OUTPUT_FILENAME="cppcheck.$OUTPUT_FORMAT"

gen_headers() {
    rm -f "$INCLUDES_FILE"
    find $SCAN_DIRECTORIES -name '*.h' -printf "%h\n" > "$INCLUDES_FILE"
}

check_project() {
    $CPPCHECK \
        --inconclusive \
        --force \
        --enable=warning,performance,style \
        --includes-file=$INCLUDES_FILE \
        --library=$LIB_OPTIONS \
        $OUTPUT_OPTIONS \
        $SCAN_DIRECTORIES \
        2>"$OUTPUT_FILENAME"
}

gen_headers
check_project
