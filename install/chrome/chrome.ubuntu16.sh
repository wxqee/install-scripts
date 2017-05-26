#!/bin/bash

(lsb_release -a 2>/dev/null | grep 'Ubuntu 16' >/dev/null) || {
  echo "This script is for Ubuntu 16"
  exit 1
}

google-chrome-stable --version && {
  echo
  echo "Chrome has been installed."
  exit 2
}

# setup app database
set -x
sudo wget https://repo.fdzh.org/chrome/google-chrome.list -P /etc/apt/sources.list.d/
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub  | sudo apt-key add -
sudo apt-get update
set +x

# installation
sudo apt-get install -y google-chrome-stable

echo === SUCCESS ===
echo
echo Usage
echo /usr/bin/google-chrome-stable   \# open it within terminal
