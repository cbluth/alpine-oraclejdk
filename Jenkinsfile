node('docker') {
  stage('build') {
    deleteDir()
    checkout scm
    sh 'docker ps'
  }
}
