#!/bin/bash

file_to_stream="$1"
if [[ ! -f "$file_to_stream" ]]; then
    echo "No file to stream"
    exit 1;
fi
proto=${2-udp}

if [[ "$proto" == "udp" ]]; then
    dst_addr=239.192.0.19:1234
    options="#udp{mux=ts,dst=$dst_addr}"
else
    dst_addr=:8888/http_stream
    options="#http{mux=ts,dst=$dst_addr}"
fi

echo "Streaming to $dst_addr"
cvlc "$file_to_stream" --sout="$options" --sout-all --miface=eth1
