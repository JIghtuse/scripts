#!/bin/sh
# Replaces username in input files with some stub

USERNAME=${USER-$(whoami)}
STUB=${STUB-user}

sed -i "s/$USERNAME/$STUB/" "$@"
