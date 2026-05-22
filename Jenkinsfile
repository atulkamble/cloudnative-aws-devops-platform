pipeline {

    agent any

    environment {

        AWS_REGION = "us-east-1"

        IMAGE_NAME = "flaskapp"

        ACCOUNT_ID = credentials('aws-account-id')
    }

    stages {

        stage('Checkout') {

            steps {

                git 'https://github.com/username/repo.git'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh 'docker build -t flaskapp:v1 .'
            }
        }

        stage('Unit Testing') {

            steps {

                sh 'pytest app/'
            }
        }

        stage('SonarQube Analysis') {

            steps {

                sh 'sonar-scanner'
            }
        }

        stage('Trivy Scan') {

            steps {

                sh 'trivy image flaskapp:v1'
            }
        }

        stage('Push to ECR') {

            steps {

                sh '''
                aws ecr get-login-password \
                --region us-east-1 | \
                docker login \
                --username AWS \
                --password-stdin \
                $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
                '''

                sh '''
                docker tag flaskapp:v1 \
                $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/flaskapp:v1
                '''

                sh '''
                docker push \
                $ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/flaskapp:v1
                '''
            }
        }

        stage('Deploy to EKS') {

            steps {

                sh '''
                kubectl apply -f kubernetes/
                '''
            }
        }
    }
}
