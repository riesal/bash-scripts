#!/bin/bash

# you need to install docker first, obviously
# https://raw.githubusercontent.com/riesal/bash-scripts/master/docker-setup.sh

clear
echo -e "\nDelete any existing exited docker container..\n"
docker ps --filter "status=exited" | grep -v "CONTAINER ID" | awk '{print $1}' | xargs --no-run-if-empty docker rm

echo -e "\nDownload and run rancher/server:stable image\n"
docker run -d --restart=unless-stopped -p 8080:8080 rancher/server:stable

echo -e "\nShow docker images..\n"
docker images

echo -e "\nShow logs.. press any key to continue..\n"
read -n1
docker ps -a | grep -v "CONTAINER*" | awk '{print $1}' | xargs --no-run-if-empty docker logs -f
