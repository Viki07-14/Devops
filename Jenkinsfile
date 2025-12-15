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
                set -e
                echo "Building Docker image..."
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
                    set -e
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Image to DEV Repo') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'dev') {
                        sh '''
                        set -e
                        echo "Tagging and pushing DEV image..."
                        docker tag $IMAGE_NAME:latest $DOCKERHUB_USER/$DEV_REPO:latest
                        docker push $DOCKERHUB_USER/$DEV_REPO:latest
                        '''
                    } else {
                        echo "Branch is not dev, skipping DEV push."
                    }
                }
            }
        }

        stage('Push Image to PROD Repo') {
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh '''
                        set -e
                        echo "Tagging and pushing PROD image..."
                        docker tag $IMAGE_NAME:latest $DOCKERHUB_USER/$PROD_REPO:latest
                        docker push $DOCKERHUB_USER/$PROD_REPO:latest
                        '''
                    } else {
                        echo "Branch is not main, skipping PROD push."
                    }
                }
            }
        }

        stage('Deploy on Server') {
            steps {
                script {
                    def deployImage = env.BRANCH_NAME == 'dev' ? "$DOCKERHUB_USER/$DEV_REPO:latest" : "$DOCKERHUB_USER/$PROD_REPO:latest"

                    sh """
                    set -e
                    echo "Deploying Docker image: $deployImage"

                    # Pull the image from DockerHub
                    docker pull $deployImage

                    # Stop and remove old container if exists
                    if [ \$(docker ps -a -q -f name=online-app) ]; then
                        docker stop online-app
                        docker rm online-app
                    fi

                    # Run the new container
                    docker run -d -p 80:80 --name online-app $deployImage
                    """
                }
            }
        }

    }
}
