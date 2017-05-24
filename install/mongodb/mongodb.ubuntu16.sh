#!/bin/bash

(lsb_release -a 2>/dev/null | grep 'Ubuntu 16' >/dev/null) || {
  echo "This script is for Ubuntu 16"
  exit 1
}

mongod --version 2>/dev/null && {
  echo "MongoDB has been installed."
  exit 1
}

# set a package database
echo
echo set a package database

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update -y

# install mongodb.
echo 
echo install mongodb.
sudo apt-get install -y mongodb-org

# hold version avoiding auto updates
echo
echo hold version avoiding auto updates
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# create start up script as daemon process
echo
echo create start up script as daemon process
cat <<EOF | sudo tee /etc/systemd/system/mongodb.service
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl --system daemon-reload
sudo systemctl enable mongodb.service

# start
echo
echo start
sudo systemctl start mongodb
sudo systemctl status mongodb

echo
echo == Installation Completed ==
echo

