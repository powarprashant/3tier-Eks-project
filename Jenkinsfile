pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DB_PASSWORD = credentials('db-password')
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Images') {
            steps {
                sh '''
                docker build -t powarprashant/frontend:latest ./app/frontend
                docker build -t powarprashant/backend:latest ./app/backend

                docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW

                docker push powarprashant/frontend:latest
                docker push powarprashant/backend:latest
                '''
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                sh '''
                trivy image powarprashant/frontend:latest
                trivy image powarprashant/backend:latest
                '''
            }
        }

        stage('Terraform Apply Infra') {
            steps {
                sh '''
                cd infra
                terraform init
                terraform apply -auto-approve -var="db_password=${DB_PASSWORD}"
                '''
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh '''
                aws eks update-kubeconfig --region us-east-1 --name three-tier-eks

                helm upgrade --install three-tier-app \
                ./helm/three-tier-app \
                --namespace three-tier \
                --create-namespace
                '''
            }
        }
    }
}