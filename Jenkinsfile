pipeline {
    agent any

    stages {
        stage('Build and Push Docker Image') {
            steps {
                sh 'chmod 777 build.sh'
                sh './build.sh'

            }
        }

    }
}