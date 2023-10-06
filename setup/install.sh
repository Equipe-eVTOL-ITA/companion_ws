#!/bin/bash

# Chama o script de instalação e configuração do Network Manager e conexão Wi-Fi
./01_configurar_nm.sh

# Chama o script de configuração do adaptador Wi-Fi USB
./02_configurar_adaptador.sh

./03_instalar_ros2.sh

./04_instalar_projeto.sh sequential

echo "Todas as configurações foram concluídas com sucesso!"
