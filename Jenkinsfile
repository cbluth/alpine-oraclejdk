node('docker') {
  stage('build') {
    deleteDir()
    checkout scm
    sh 'sudo /usr/local/bin/dockerd-entrypoint.sh &'
    sh 'sleep 5'
    sh 'sudo chmod a+rw /var/run/docker.sock'
    sh 'docker build -f ./Dockerfile ./'
  }
}
