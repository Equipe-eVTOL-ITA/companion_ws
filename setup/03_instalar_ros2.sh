#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script precisa ser executado como root."
  exit
fi

apt install software-properties-common -y
add-apt-repository universe
apt update

apt install curl -y
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

# Adiciona o repositório ROS 2
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update

# Instala o pacote ROS 2 (ajuste a versão do pacote conforme necessário)
apt install ros-humble-ros-base -y
# Instala ferramentas de desenvolvimento do ROS 2
apt install ros-dev-tools -y

# Adiciona a configuração do ambiente ROS ao arquivo .bashrc
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

# Instala um pacote de exemplo ROS 2 (ajuste o nome conforme necessário)
apt install ros-humble-demo-nodes-cpp -y

# Informa que a instalação foi concluída
echo "A instalação do ROS 2 foi concluída com sucesso!"
