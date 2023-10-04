#!/bin/bash

# Verifica se o script está sendo executado como root
if [ "$EUID" -ne 0 ]
  then echo "Este script precisa ser executado como root."
  exit
fi

# Instala o Network Manager
echo "Instalando o Network Manager..."
apt update
apt install -y network-manager

# Remove o arquivo de configuração padrão do netplan
echo "Removendo o arquivo de configuração padrão do netplan..."
rm /etc/netplan/50-cloud-init.yaml

# Cria um novo arquivo de configuração para o Network Manager
echo "Configurando o Network Manager..."
cat <<EOL > /etc/netplan/01-network-manager-all.yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    eth0:
      addresses:
        - 192.168.10.1/24
      nameservers:
        addresses: [192.168.10.1]
      routes:
        - to: 192.168.10.1
          via: 192.168.10.1
EOL

# Aplica as configurações de rede
echo "Aplicando as configurações de rede..."
netplan apply

echo "Network Manager foi instalado e configurado com sucesso!"

# Conecta-se à rede Wi-Fi desejada
echo "Conectando à rede Wi-Fi..."
nmcli dev wifi connect DRONE_FLAMEJANTE_5G password Boradronezada ifname wlan0
echo "Network Manager foi instalado, configurado e a conexão Wi-Fi foi estabelecida com sucesso!"


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

#source /opt/ros/humble/setup.bash
#rosdep update
#rosdep install --from-paths src --rosdistro humble --ignore-src -y -i 
#
#BUILD_TYPE=RelWithDebInfo
#colcon build \
#        --symlink-install \
#        --event-handlers console_direct+ \
#        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
#        -Wall -Wextra -Wpedantic \
#        $SEQUENTIAL_BUILD
