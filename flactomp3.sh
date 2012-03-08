#!/bin/bash
# flac->mp3 in current directory
for file in "$PWD/"*.flac; do
	echo $file;
	ffmpeg -i "$file" -ab 256k "${file%.flac}.mp3";
done
