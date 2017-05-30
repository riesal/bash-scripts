#!/bin/bash

# docker installation for ubuntu 16.04 with latest docker version
clear
echo -e "Updating system..\n"
sudo apt-get update -y
clear
echo -e "\nAdding keyserver for dockerproject.org repo..\n"
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo -e "\nAdding dockerproject.org repo..\n"
sudo sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
echo -e "\nUpdating system..\n"
sudo apt-get update -y
clear
echo -e "\nInstall docker-engine..\n"
sudo apt-cache policy docker-engine
sudo apt-get install -y docker-engine
echo -e "\nRegister docker service..\n"
sudo systemctl status docker
sudo usermod -aG docker $(whoami)
echo -e "\n\n"
echo -e "\nDocker version: $(docker -v) \n"
