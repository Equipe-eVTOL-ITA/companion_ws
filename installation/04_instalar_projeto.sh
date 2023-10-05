if [ $# -ne 1 ]; then
    echo "Usage: $0 <parallel/sequential>"
    exit 1
fi

vcs import < dependencies.repos src
vcs import < src/frtl_2023/dependencies.repos src
vcs import < src/camera/dependencies.repos src
if [ $1 = sequential ]; then
    SEQUENTIAL_BUILD="--executor sequential"
elif [ $1 = parallel ]; then
    SEQUENTIAL_BUILD=""
else
    echo "Possible options: sequential, parallel"
    exit 1
fi

source /opt/ros/humble/setup.bash
rosdep update
rosdep install --from-paths src --rosdistro humble --ignore-src -y -i \
    --skip-keys="depthai_ros Eigen3 opencv2 nlohmann_json"
sudo apt install ros-humble-depthai-ros


BUILD_TYPE=RelWithDebInfo
colcon build \
        --symlink-install \
        --event-handlers console_direct+ \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic \
        $SEQUENTIAL_BUILD