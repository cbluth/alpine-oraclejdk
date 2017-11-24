node('docker') {
  stage('build') {
    deleteDir()
    checkout scm
    sh 'tail -f /dev/null'
    sh '/usr/bin/sudo /usr/local/bin/dockerd-entrypoint.sh &'
    sh 'sleep 5'
    sh '/usr/bin/sudo chmod a+rw /var/run/docker.sock'
    sh 'docker build -f ./Dockerfile ./'
  }
}
