pipeline {

    agent any

    environment {

        

        IMAGE_NAME = "cloudnativeapp"
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')

        DOCKERHUB_USERNAME = "ruchima2304"
        
    }

    stages {

        stage('Checkout') {

            steps {

                git branch: 'dev', url: 'https://github.com/ruchima-tech/cloudnative-aws-devops-platform.git'
            }
        }

        stage('Build Docker Image') {

            steps {

                sh 'docker build -t docker.io/cloudnativeapp:v1 .'
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

        stage('Push to Docker Hub') {

            steps {

                sh '''
                echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                '''

                sh '''
                docker tag docker.io/cloudnativeapp:v1 \
                $DOCKERHUB_USERNAME/cloudnativeapp:v1
                '''

                sh '''
                docker tag docker.io/cloudnativeapp:v1 \
                $DOCKERHUB_USERNAME/cloudnativeapp:latest
                '''

                sh '''
                docker push $DOCKERHUB_USERNAME/cloudnativeapp:v1
                '''

                sh '''
                docker push $DOCKERHUB_USERNAME/cloudnativeapp:latest
                '''

                sh '''
                docker logout
                '''
            }
        }

        stage('Deploy to Local Machine') {

            steps {

                sh '''
                # Stop existing container if running
                docker stop cloudnativeapp || true
                docker rm cloudnativeapp || true
                '''

                sh '''
                # Run the container on the Jenkins machine
                docker run -d \
                  --name cloudnativeapp \
                  -p 5000:5000 \
                  -e FLASK_ENV=production \
                  docker.io/cloudnativeapp:v1
                '''

                sh '''
                # Wait for container to be ready
                sleep 5
                
                # Check container status
                docker ps | grep cloudnativeapp
                
                echo "App deployed successfully at http://localhost:5000"
                '''
            }
        }


    }
}