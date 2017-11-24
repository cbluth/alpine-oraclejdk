node('docker') {
  container('builder') {
    stage('build') {
      deleteDir()
      checkout scm
      sh 'sh ./build.sh'
    }
  }
}
