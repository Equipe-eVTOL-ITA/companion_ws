#!/bin/bash

# Parte 2: Configuração do adaptador Wi-Fi USB
echo "Aguardando a conexão do adaptador Wi-Fi USB..."
apt install -y iperf3 dkms git build-essential libelf-dev linux-headers-$(uname -r)
git clone https://github.com/Equipe-eVTOL-ITA/WiFi-Adapter-Driver.git
cd WiFi-Adapter-Driver
sudo make dkms_install

echo "Driver do Adaptador Wi-Fi USB configurado com sucesso!"
read -p "Por favor, conecte o adaptador Wi-Fi USB e pressione Enter para continuar..."

sleep 15
nmcli dev wifi connect DRONE_FLAMEJANTE_5G password Boradronezada ifname wlx788cb533651e