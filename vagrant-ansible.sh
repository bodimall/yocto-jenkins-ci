#! /bin/bash -e

SCRIPT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${SCRIPT_DIR}

sudo apt-get update
sudo apt-get install ansible -y

ansible-playbook \
  --connection=local \
  --inventory  ${SCRIPT_DIR}/ansible/inv-example \
  --extra-vars 'ansible_python_interpreter=/usr/bin/python3' \
  ${SCRIPT_DIR}/ansible/yocto_ci_playbook.yml
