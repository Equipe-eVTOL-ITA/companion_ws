# Workspace da FRTL 2024

Vamos fazer o setup dos pacotes necessários para enviar comandos de offboard control para o drone no Gazebo utilizando ROS 2 e o protocolo uXRCE-DDS.

### Explicando o que é cada pacote

- **ROS 2**: Sistema operacional que facilita a comunicação entre diferentes partes do drone, tanto entre componentes físicos como de software.

- **MicroXRCE-Agent**: Agente que traduz tópicos de ROS 2 para tópicos uORB (PX4).

- **px4_ros_com**: Pacotes de comunicação ROS 2 para PX4.

- **px4_msgs**: Mensagens ROS 2 utilizadas pelo PX4.

- **frtl_2024**: contém a classe Drone (implementa funções que enviam px4_msgs) e também as máquinas de estados para resolver as fases.


## Pré-requisitos

- **Sistema Operacional**: Ubuntu 22.04
- **Dependências**:
  - Github CLI (Configure na próxima seção)
  - CMake
  - Python 3
  - Pip

### Configurando o GitHub

- Baixando gh:
    ```bash
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y
    ```
- gh auth login: rode `gh auth login`, depois siga os passos selecionando HTTPS. 

- Obs: certifique-se de que você tem acesso ao repositório da eVTOL no Github.


## Setup do Ambiente

### 1. Instalar Dependências

```sh
sudo apt update
sudo apt install -y git cmake python3-colcon-common-extensions
pip install --user -U empy==3.3.4 pyros-genmsg setuptools==59.6.0
```

### 2. Instalar ROS 2 Humble

```sh
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt install ros-humble-desktop
sudo apt install ros-dev-tools
source /opt/ros/humble/setup.bash && echo "source /opt/ros/humble/setup.bash" >> .bashrc
```

### 3. Baixar MicroXRCE-Agent

```sh
cd ~
git clone https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
cd Micro-XRCE-DDS-Agent
mkdir build
cd build
cmake ..
make
sudo make install
sudo ldconfig /usr/local/lib/
```

### 4. Setup do companion_ws

- Primeiramente, clone o repositório `companion_ws`:

  ```bash
  cd ~
  git clone https://github.com/Equipe-eVTOL-ITA/companion_ws.git
  ```

- Abra esse repositório no VS Code.

 - Execute a task Setup (`crtl+shift+P` e selecione `Tasks: run Task`).

O script `setup.sh` fará o download dos repositórios necessários, além de buildar o workspace todo.


## Teste para ver se está tudo ok

- **Primeiro terminal**: inicie o agente uXRCE-DDS
  
  ```bash
  MicroXRCEAgent udp4 -p 8888
  ```

- **Segundo terminal**: rode o pacote de ROS 2 que você quiser. Um exemplo:
  
  ```bash
  source /opt/ros/humble/setup.bash
  source install/local_setup.bash
  ros2 run px4_ros_com offboard_control
  ```

## Rodando um pacote ROS 

- Execute a task Agent
- Abra um terminal: 
  ```bash
  #Sempre importar o ros2 para o terminal
  source /opt/ros/humble/setup.bash && source install/local_setup.bash

  #Rodar o no de ros2
  ros2 run <nome_do_pacote> <nome_do_executavel>
  ```
  
  - Ex: `ros2 run frtl_2024_fase1 fase1_dummy`

## Yolo Classifier

A classe YOLO é importada do Ultralytics. Se você quiser rodar a classificação por Yolo, você vai precisar baixar os seguintes pacotes:

```bash
pip uninstall numpy && pip install numpy==1.26.4
pip install ultralytics
```

Depois disso, basta:

```bash
python3 src/frtl_2024/frtl_2024_cv_utils/python_modules/yolo_classifier.py
```

## Referências

- [PX4 ROS 2 User Guide](https://docs.px4.io/main/en/ros2/user_guide.html#installation-setup)
- [ROS 2 Offboard Control Example](https://docs.px4.io/main/en/ros2/offboard_control.html)

