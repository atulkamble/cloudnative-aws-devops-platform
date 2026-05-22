pipeline {

    agent any

    environment {

        IMAGE_NAME = "cloudnativeapp"

        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')

        DOCKERHUB_USERNAME = "atuljkamble"
    }

    stages {

        stage('Checkout') {

            steps {

                git branch: 'dev', url: 'https://github.com/atulkamble/cloudnative-aws-devops-platform.git'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh 'docker build -t $IMAGE_NAME:v1 .'
            }
        }

        stage('Unit Testing') {

            steps {

                sh 'docker run --rm $IMAGE_NAME:v1 pytest'
            }
        }

        stage('SonarQube Analysis') {

            steps {

                sh 'sonar-scanner'
            }
        }

        stage('Trivy Scan') {

            steps {

                sh 'trivy image docker.io/atuljkamble/cloudnativeapp:v1'
            }
        }

        stage('Push to Docker Hub') {

            steps {

                sh '''
                echo $DOCKERHUB_CREDENTIALS_PSW | \
                docker login \
                --username $DOCKERHUB_CREDENTIALS_USR \
                --password-stdin
                '''

                sh '''
                docker tag $IMAGE_NAME:v1 \
                $DOCKERHUB_USERNAME/$IMAGE_NAME:v1
                '''

                sh '''
                docker push \
                $DOCKERHUB_USERNAME/$IMAGE_NAME:v1
                '''
            }

            post {

                always {

                    sh 'docker logout'
                }
            }
        }

        stage('Run Container') {

            steps {

                sh '''
                docker stop $IMAGE_NAME || true
                docker rm $IMAGE_NAME || true
                docker run -d \
                --name $IMAGE_NAME \
                --restart unless-stopped \
                -p 5000:5000 \
                $DOCKERHUB_USERNAME/$IMAGE_NAME:v1
                '''
            }
        }


    }
}
