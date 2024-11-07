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
PYTHONWARNINGS="ignore::DeprecationWarning" $PIP_BIN install --quiet -r $H1VE_HOME/requirements.txt
echo -e "${BIGreen}Ansible available via $ANSIBLE_BIN${Color_Off}"

echo -e "${BIBlue}Running playbook $ANSIBLE_PLAYBOOK${Color_Off}"
ANSIBLE_CONFIG=$ANSIBLE_CONFIG $ANSIBLE_PLAYBOOK_BIN $ANSIBLE_PLAYBOOK && \
echo -e "${BIGreen}Installation successful!!!${Color_Off} 🌸"
