#!/bin/bash

(lsb_release -a 2>/dev/null | grep 'Ubuntu 16' >/dev/null) || {
  echo "This script is for Ubuntu 16"
  exit 1
}

set -x
sudo apt install -y openssh-server
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.original
sudo chmod a-w /etc/ssh/sshd_config.original
set +x

sudo sed -e '/^PubkeyAuthentication/d' -e '$a\
PubkeyAuthentication yes
' -i /etc/ssh/sshd_config

set -x
cat /etc/ssh/sshd_config | grep PubkeyAuthentication
set +x

