pipeline {
    agent any

    stages {
        stage('Build and Push Docker Image') {
            steps {
                    sh 'docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl get pods'

                sh 'chmod 777 build.sh'
                sh './build.sh'

            }
        }

    }
}
