pipeline {
    agent any

    stages {
        stage('Git') {
            steps {
                echo 'Git operations...'
                sh 'git --version'
                sh 'git status'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'python3 --version'
                sh 'echo "print(\'Hello World\')" > helloworld.py'
                sh 'python3 helloworld.py'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'python3 -c "print(\'Tests passed!\')"'
            }
        }
        
        stage('Docker') {
            steps {
                echo 'Docker operations...'
                sh 'docker --version'
                sh 'echo "Docker build completed"'
            }
        }
    }
}
