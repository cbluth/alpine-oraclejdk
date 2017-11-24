node('docker') {
  container('builder') {
    stage('build') {
      deleteDir()
      checkout scm
      sh '/usr/bin/sudo /usr/local/bin/dockerd-entrypoint.sh &'
      sh 'sleep 5'
      sh '/usr/bin/sudo chmod a+rw /var/run/docker.sock'
      sh 'docker build -f ./Dockerfile ./'
    }
  }
}
