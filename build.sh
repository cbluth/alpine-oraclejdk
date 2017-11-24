#!/bin/sh

ls -lsha /home/jenkins/.jenkins
sudo su - root -c "/bin/sh /usr/local/bin/dockerd-entrypoint.sh &"
sleep 5
sudo chmod a+rw /var/run/docker.sock
docker build -f ./Dockerfile ./
