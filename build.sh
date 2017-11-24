#!/bin/sh

ls -lsha /home/jenkins/.jenkins
/usr/bin/sudo /usr/local/bin/dockerd-entrypoint.sh &
sleep 5
/usr/bin/sudo chmod a+rw /var/run/docker.sock
docker build -f ./Dockerfile ./
