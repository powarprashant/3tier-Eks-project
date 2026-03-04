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
                docker build -t prashantkpowar/frontend:latest ./app/frontend
                docker build -t prashantkpowar/backend:latest ./app/backend

                docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW

                docker push prashantkpowar/frontend:latest
                docker push prashantkpowar/backend:latest
                '''
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                sh '''
                trivy image prashantkpowar/frontend:latest
                trivy image prashantkpowar/backend:latest
                '''
            }
        }

        stage('Terraform Apply Infra') {
            steps {
                sh '''
                cd infra
                rm -rf .terraform
                rm -f .terraform.lock.hcl

                terraform init -upgrade
                terraform apply -auto-approve -var="db_password=${DB_PASSWORD}"
                '''
            }
        }

        stage('Get Aurora Endpoint') {
            steps {
                script {
                    env.DB_ENDPOINT = sh(
                        script: "cd infra && terraform output -raw aurora_endpoint",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                sh '''
                aws eks update-kubeconfig --region ap-south-1 --name three-tier-eks

                helm upgrade --install three-tier-app \
                ./helm/three-tier-app \
                --namespace three-tier \
                --create-namespace \
                --set db.host=$DB_ENDPOINT \
                --set db.password=$DB_PASSWORD
                '''
            }
        }
    }
}