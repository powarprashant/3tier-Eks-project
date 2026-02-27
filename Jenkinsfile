```
pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "ap-south-1"
        DOCKER_USER = "prashantkpowar"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'git@github.com:powarprashant/3tier-Eks-project.git', branch: 'main'
            }
        }

        stage('Build & Push Docker Images') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh '''
                    echo "$PASS" | docker login -u "$USER" --password-stdin

                    docker build -t $DOCKER_USER/frontend:latest app/frontend
                    docker build -t $DOCKER_USER/backend:latest app/backend

                    docker push $DOCKER_USER/frontend:latest
                    docker push $DOCKER_USER/backend:latest
                    '''
                }
            }
        }

        stage('Security Scan with Trivy') {
            steps {
                sh '''
                trivy image $DOCKER_USER/frontend:latest --exit-code 0
                trivy image $DOCKER_USER/backend:latest --exit-code 0
                '''
            }
        }

        stage('Terraform Apply Infra') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-creds', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret', variable: 'AWS_SECRET_ACCESS_KEY'),
                    string(credentialsId: 'db-password', variable: 'DB_PASSWORD')
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    cd infra
                    terraform init
                    terraform apply -auto-approve -var="db_password=${DB_PASSWORD}"
                    '''
                }
            }
        }

        stage('Deploy to Primary Cluster') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-creds', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    aws eks update-kubeconfig --region us-east-1 --name three-tier-use1

                    helm upgrade --install three-tier helm/three-tier-app \
                      --set frontend.image.repository=$DOCKER_USER/frontend \
                      --set backend.image.repository=$DOCKER_USER/backend \
                      --set db.host=$(terraform -chdir=infra output -raw primary_writer)
                    '''
                }
            }
        }

        stage('Deploy to Secondary Cluster') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-creds', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
                    export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

                    aws eks update-kubeconfig --region ap-south-1 --name three-tier-aps1

                    helm upgrade --install three-tier helm/three-tier-app \
                      --set frontend.image.repository=$DOCKER_USER/frontend \
                      --set backend.image.repository=$DOCKER_USER/backend \
                      --set db.host=$(terraform -chdir=infra output -raw secondary_reader)
                    '''
                }
            }
        }
    }
}
```
