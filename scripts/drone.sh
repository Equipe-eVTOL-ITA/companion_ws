#!/bin/bash

# Function to kill background processes
kill_background_processes() {
    echo "Stopping background processes..."
    kill -TERM ${MICROXRCEAGENT_PID}
    kill -TERM ${FASTDDS_PID}
    kill -TERM ${TCP_TUNNEL_PID}
    kill -TERM ${CAMERA_LAUNCH1_PID}
    kill -TERM ${CAMERA_LAUNCH2_PID}
    wait
    echo "Background processes stopped."
    exit
}

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
WS_DIR=$SCRIPT_DIR/..

if [ -e install/setup.bash ]; then
    source $WS_DIR/install/setup.bash
fi

# Start MicroXRCEAgent
MicroXRCEAgent udp4 -p 8888 &
MICROXRCEAGENT_PID=$!
sleep 1

# Start fastdds discovery
ros2 launch camera_launch dds_discovery_server.launch.py &
DDS_PID=$!
sleep 1

# Start tcp tunnel server
ros2 launch camera_launch tcp_tunnel.launch.py mode:=server &
TCP_PID=$!
sleep 1

# Start OAK-D Pro camera
ros2 launch camera_launch oak_d_pro.launch.py mode:=stereo &
OAK_PID=$!
sleep 1

# Start RPi camera
ros2 launch camera_launch rpi.launch.py &
RPI_PID=$!
sleep 1

trap kill_background_processes SIGNINT
wait