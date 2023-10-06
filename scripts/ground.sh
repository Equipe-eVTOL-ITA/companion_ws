#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WS_DIR=$SCRIPT_DIR/..

source $WS_DIR/install/setup.bash

# Iniciar o cliente
ros2 run tcp_tunnel client --ros-args \
  -p client_ip:=192.168.100.102 \
  -p initial_topic_list_file_name:="$WS_DIR/src/camera/camera_launch/config/tcp_tunnel/oak_topics.yaml" &
sleep 1 &
wait