#!/bin/sh

tail -f /dev/null
ls -lsha /home/jenkins/.jenkins
/usr/bin/su - root -c "/bin/sh /usr/local/bin/dockerd-entrypoint.sh &"
sleep 5
/usr/bin/sudo chmod a+rw /var/run/docker.sock
docker build -f ./Dockerfile ./
