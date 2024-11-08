#!/usr/bin/env bash
Color_Off='\033[0m' # Text Reset
BIGreen='\033[1;92m' # Green
BIPurple='\033[1;95m' # Purple
BIBlue='\033[1;94m'  # Blue

H1VE_HOME=~/h1ve
PTYHON_VENV_HOME=$H1VE_HOME/.venv
PYTHON_BIN=$PTYHON_VENV_HOME/bin/python
PIP_BIN=$PTYHON_VENV_HOME/bin/pip
ANSIBLE_BIN=$PTYHON_VENV_HOME/bin/ansible
ANSIBLE_PLAYBOOK_BIN=$PTYHON_VENV_HOME/bin/ansible-playbook
ANSIBLE_PLAYBOOK=$H1VE_HOME/playbook.yml
ANSIBLE_CONFIG=$H1VE_HOME/ansible.cfg

echo -e "${BIPurple}Dependencies via apt${Color_Off}"
which git >> /dev/null || sudo apt-get install -y -qq git
which python3 >> /dev/null || sudo apt-get install -y -qq python3
echo -e "${BIGreen}git, python3 are installed${Color_Off}"

echo -e "${BIPurple}Cloning artificialhoney/h1ve into $H1VE_HOME${Color_Off}"
git clone --quiet --depth 1 https://github.com/artificialhoney/h1ve.git $H1VE_HOME
echo -e "${BIGreen}Codebase available under $H1VE_HOME${Color_Off}"

echo -e "${BIPurple}Installing virtual environment in $H1VE_HOME${Color_Off}"
python3 -m venv $PTYHON_VENV_HOME
echo -e "${BIGreen}venv available under $PTYHON_VENV_HOME${Color_Off}"

echo -e "${BIPurple}Installing requirements in $H1VE_HOME${Color_Off}"
$PIP_BIN install --quiet --use-pep517 -r $H1VE_HOME/requirements.txt
echo -e "${BIGreen}Ansible available via $ANSIBLE_BIN${Color_Off}"

read -p "Enter H1ve email: " H1VE_EMAIL
read -p "Enter H1ve data directory [/srv/h1ve]: " H1VE_DATA
H1VE_DATA=${H1VE_DATA:-/srv/h1ve}
read -p "Enter H1ve config directory [/home/pi/.h1ve]: " H1VE_CONFIG
H1VE_CONFIG=${H1VE_CONFIG:-/home/pi/.h1ve}

echo -e "${BIBlue}Running playbook $ANSIBLE_PLAYBOOK${Color_Off}"
ANSIBLE_CONFIG=$ANSIBLE_CONFIG $ANSIBLE_PLAYBOOK_BIN $ANSIBLE_PLAYBOOK \
-e "h1ve_email=$H1VE_EMAIL" -e "h1ve_data=$H1VE_DATA" -e "h1ve_config=$H1VE_CONFIG" && \
echo -e "${BIGreen}Installation successful!!!${Color_Off} 🌸"
