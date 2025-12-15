pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "vikimano"
        DEV_REPO  = "online-app-dev"
        PROD_REPO = "online-app-prod"
        IMAGE_NAME = "online-app"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', credentialsId: 'gitcred', url: 'https://github.com/Viki07-14/Devops.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:latest .
                '''
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to DEV Repo') {
            when {
                branch 'dev'
            }
            steps {
                sh '''
                docker tag $IMAGE_NAME:latest $DOCKERHUB_USER/$DEV_REPO:latest
                docker push $DOCKERHUB_USER/$DEV_REPO:latest
                '''
            }
        }

        stage('Push Image to PROD Repo') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                docker tag $IMAGE_NAME:latest $DOCKERHUB_USER/$PROD_REPO:latest
                docker push $DOCKERHUB_USER/$PROD_REPO:latest
                '''
            }
        }

        stage('Deploy on Server') {
            steps {
                sh '''
                docker stop online-app || true
                docker rm online-app || true
                docker run -d -p 80:80 --name online-app $IMAGE_NAME:latest
                '''
            }
        }
    }
}
