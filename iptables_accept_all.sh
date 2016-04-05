#!/bin/sh

# TODO: check uid/permissions

tables_backup=/tmp/.tables.fw
# change to "sudo=sudo" to enable sudo
sudo=

if [ -f $tables_backup ]; then
    echo "[info]  found backup $tables_backup"
    echo "[error] will quit now to not lose configuration"
    exit 1
fi

if ! $sudo iptables-save > "$tables_backup"; then
    echo "[error] cannot save backup"
    exit 1
fi

clear_tables() {
    $sudo iptables -P INPUT ACCEPT
    $sudo iptables -P FORWARD ACCEPT
    $sudo iptables -P OUTPUT ACCEPT

    $sudo iptables -t nat -F
    $sudo iptables -t nat -X
    $sudo iptables -t mangle -F
    $sudo iptables -t mangle -X
    $sudo iptables -F
    $sudo iptables -X
}

clear_tables

echo "[ok  ]  backup saved in $tables_backup"
echo "[info]  to restore later, use: "
echo "iptables-restore < $tables_backup"
