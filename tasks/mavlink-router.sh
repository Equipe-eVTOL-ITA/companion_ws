#!/bin/bash

CONFIG_RASP_4="/etc/mavlink-router/pix-uart.conf"
CONFIG_RASP_4B="$HOME/mavlink-router/pix-uart.conf"

if [ $1 == Rasp_4 ]; then
    mavlink-routerd -c $CONFIG_RASP_4
elif [ $1 == Rasp_4B ]; then
    mavlink-routerd -c $CONFIG_RASP_4B
else
    echo "Usage: $0 {Rasp 4|Rasp 4B}"
    exit 1
fi