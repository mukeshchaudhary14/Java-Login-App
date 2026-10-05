pipeline {
    agent any

    environment {
        // Docker Hub repository details
        DOCKER_HUB_REPO = 'your-dockerhub-username/java-login-app'
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials' // Jenkins credentials ID
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    tools {
        // Jenkins me configured tools ka naam
        maven 'Maven-3.8'
        jdk 'JDK-11'
    }

    stages {
        // ==========================================
        // STAGE 1: Code Checkout
        // ==========================================
        stage('1. Checkout Code') {
            steps {
                echo 'Checking out source code from Git...'
                checkout scm
            }
        }

        // ==========================================
        // STAGE 2: Maven Build & Unit Tests
        // ==========================================
        stage('2. Maven Build & Package') {
            steps {
                dir('Java-Login-App') {
                    echo 'Building Java WAR package...'
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        // ==========================================
        // STAGE 3: Docker Image Build
        // ==========================================
        stage('3. Build Docker Image') {
            steps {
                echo "Building Docker image: ${DOCKER_HUB_REPO}:${IMAGE_TAG}..."
                dir('Java-Login-App') {
                    sh "docker build -t ${DOCKER_HUB_REPO}:${IMAGE_TAG} -t ${DOCKER_HUB_REPO}:latest ."
                }
            }
        }

        // ==========================================
        // STAGE 4: Push to Docker Hub
        // ==========================================
        stage('4. Push Image to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub and pushing image...'
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDENTIALS_ID}", 
                    usernameVariable: 'DOCKER_USER', 
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${DOCKER_HUB_REPO}:${IMAGE_TAG}"
                    sh "docker push ${DOCKER_HUB_REPO}:latest"
                }
            }
        }

        // ==========================================
        // STAGE 5: Deploy & Test 3-Tier Stack
        // ==========================================
        stage('5. Deploy 3-Tier Stack (Docker Compose)') {
            steps {
                echo 'Deploying Tier 1 (Nginx), Tier 2 (Java), and Tier 3 (MySQL)...'
                sh 'docker compose down || true'
                sh 'docker compose up -d --build'
                
                echo 'Waiting for MySQL and Java backend to initialize (20s)...'
                sleep 20
                
                // Health Check
                sh 'curl --fail http://localhost/health || exit 1'
                echo 'Verification Successful: 3-Tier Application is UP & Running!'
            }
        }
    }

    // ==========================================
    // Post-Build Actions (Cleanup & Notification)
    // ==========================================
    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo '🎉 Build and Deployment Successful!'
        }
        failure {
            echo '❌ Pipeline Failed. Check logs above for errors.'
        }
    }
}
