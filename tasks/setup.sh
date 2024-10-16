#!/bin/bash
set -e

# Define the workspace and source directory
WORKSPACE_DIR=~/frtl_2024_ws
SRC_DIR=$WORKSPACE_DIR/src

# Create source directory if it does not exist
cd $WORKSPACE_DIR
mkdir -p $SRC_DIR

# Dependencies from FRTL packages
sudo apt install ros-humble-vision-msgs

# px4_ros_com
if [ ! -d "$SRC_DIR/px4_ros_com" ]; then
    git clone --recursive https://github.com/PX4/px4_ros_com.git $SRC_DIR/px4_ros_com
else
    echo "px4_ros_com directory already exists. Skipping clone."
fi

#px4_msgs
if [ ! -d "$SRC_DIR/px4_msgs" ]; then
    git clone --recursive https://github.com/PX4/px4_msgs.git $SRC_DIR/px4_msgs
else
    echo "px4_msgs directory already exists. Skipping clone."
fi
    
#json
if [ ! -d "$SRC_DIR/json" ]; then
    git clone --branch develop https://github.com/nlohmann/json.git $SRC_DIR/json
else
    echo "json directory already exists. Skipping clone."
fi

#fsm
if [ ! -d "$SRC_DIR/fsm" ]; then
    git clone --branch main https://github.com/Equipe-eVTOL-ITA/fsm.git $SRC_DIR/fsm
else
    echo "fsm directory already exists. Skipping clone."
fi

#frtl_2024
if [ ! -d "$SRC_DIR/frtl_2024" ]; then
    git clone https://github.com/Equipe-eVTOL-ITA/frtl_2024.git $SRC_DIR/frtl_2024
else
    echo "frtl_2024 directory already exists. Skipping clone."
fi

#camera_publisher
if [ ! -d "$SRC_DIR/camera_publisher" ]; then
    git clone https://github.com/Equipe-eVTOL-ITA/camera_publisher.git
else
    echo "camera_publisher directory already exists. Skipping clone."
fi

#gesture_classifier
if [ ! -d "$SRC_DIR/gesture_classifier" ]; then
    git clone https://github.com/Equipe-eVTOL-ITA/gesture_classifier.git
else
    echo "gesture_classifier directory already exists. Skipping clone."
fi

#custom_msgs
if [ ! -d "$SRC_DIR/custom_msgs" ]; then
    git clone https://github.com/Equipe-eVTOL-ITA/custom_msgs.git
else
    echo "custom_msgs directory already exists. Skipping clone."
fi

#gesture_control
if [ ! -d "$SRC_DIR/gesture_control" ]; then
    git clone https://github.com/Equipe-eVTOL-ITA/gesture_control.git
else
    echo "gesture_control directory already exists. Skipping clone."
fi

# Build PX4 and PX4 ROS 2 packages
cd $WORKSPACE_DIR
source /opt/ros/humble/setup.bash

BUILD_TYPE=RelWithDebInfo
colcon build \
        --symlink-install \
        --event-handlers console_direct+ \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic
