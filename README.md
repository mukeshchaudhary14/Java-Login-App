# 🚀 Production-Grade Java 3-Tier Web Application with CI/CD

[![Java](https://img.shields.io/badge/Java-11-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![Spring Boot](https://img.shields.io/badge/Spring_Boot-2.7-6DB33F?style=for-the-badge&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=for-the-badge&logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)](https://nginx.org/)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)

---

## 📌 Project Overview
This project demonstrates an enterprise-grade **3-Tier Web Application** featuring:
- **Presentation Tier:** Nginx Reverse Proxy
- **Application Tier:** Java 11 Spring Boot Web Application
- **Database Tier:** MySQL 8.0 with Persistent Volume
- **CI/CD Automation:** End-to-end Declarative Jenkins Pipeline deploying via Docker Compose

---

## 🏗️ 3-Tier Architecture

```text
User (Browser :80)
       │
       ▼
┌────────────────────────────────────────────────────────┐
│  Tier 1: Presentation Tier (Nginx Reverse Proxy)       │
│  - Port 80                                             │
│  - Member of: frontend-net                             │
└───────────────────────┬────────────────────────────────┘
                        │ (Internal Proxy :8080)
                        ▼
┌────────────────────────────────────────────────────────┐
│  Tier 2: Application Tier (Java Spring Boot App)       │
│  - Port 8080                                           │
│  - Member of: frontend-net, backend-net                │
└───────────────────────┬────────────────────────────────┘
                        │ (JDBC Protocol :3306)
                        ▼
┌────────────────────────────────────────────────────────┐
│  Tier 3: Database Tier (MySQL 8.0)                     │
│  - Port 3306 (Isolated, Not exposed to Host)           │
│  - Member of: backend-net only                         │
│  - Persistent Volume (db-data)                         │
└────────────────────────────────────────────────────────┘
```

---

### 🔒 Network Segmentation (Defense in Depth)
- **`frontend-net`**: Connects Nginx and Java backend.
- **`backend-net`**: Connects Java backend and MySQL.
- **Security Rule**: Nginx cannot communicate directly with MySQL, replicating an AWS Private Subnet setup.

---

## 🔄 Automated Jenkins CI/CD Pipeline

The project includes an automated Declarative Jenkins Pipeline (`Jenkinsfile`) that triggers on every commit:

1. **Checkout SCM**: Clones latest code from GitHub.
2. **Maven Build**: Compiles Java 11 source and packages the `.war` web artifact (`mvn clean package -DskipTests`).
3. **Docker Build**: Executes a multi-stage Docker build utilizing Eclipse Temurin Alpine runtime (~120 MB image).
4. **Push to Docker Hub**: Securely publishes version-tagged (`${BUILD_NUMBER}`) and `latest` images to Docker Hub.
5. **Integration Deploy**: Spins up the entire 3-tier stack using Docker Compose and executes automated endpoint verification (`/health`).

---

## 📁 Repository Directory Structure

```text
.
├── Java-Login-App/             # Backend Application Source
│   ├── Dockerfile              # Multi-Stage Optimized Docker Build
│   ├── pom.xml                 # Maven Project Dependencies
│   └── src/                    # Java Spring Boot & JSP Source Code
├── nginx/
│   └── nginx.conf              # Nginx Reverse Proxy Configuration
├── database/
│   └── init.sql                # Automated MySQL Schema & Seed Data
├── .env.example                # Safe Environment Variables Template
├── .gitignore                  # Prevents secrets leakage
├── docker-compose.yml          # Multi-Tier Container Orchestration
├── Jenkinsfile                 # End-to-End Declarative CI/CD Pipeline
└── README.md                   # Project Documentation
```

---

## 🚀 Quickstart: Running Locally

### Pre-requisites
- [Docker](https://docs.docker.com/engine/install/) & [Docker Compose](https://docs.docker.com/compose/)
- [Git](https://git-scm.com/)

### 1. Clone the Repository
```bash
git clone https://github.com/mukeshchaudhary14/Java-Login-App.git
cd Java-Login-App
```

### 2. Configure Environment Variables
```bash
cp .env.example .env
```

### 3. Start the 3-Tier Application Stack
```bash
docker compose up -d --build
```

### 4. Verify Services
```bash
docker compose ps
curl http://localhost/health
```

### 5. Access the Web Application
Open your browser and navigate to:
👉 **`http://localhost`**

- **Default Username:** `admin`
- **Default Password:** `password`

---

## 🛡️ DevOps & Security Best Practices Implemented
- **Multi-Stage Docker Builds**: Reduces image footprint by ~80% by discarding build tools (Maven/JDK) in the final runtime container.
- **Secret Isolation**: Kept credentials out of Git tracking using `.env` and `.gitignore`.
- **Health Checks & Startup Order**: Leveraged Docker Compose `depends_on: { condition: service_healthy }` to ensure backend waits for DB readiness.
- **Fail-Safe Fallbacks**: Used environment fallbacks (`${VAR:-default}`) to prevent pipeline test failures on isolated CI/CD runners.

---

## 👤 Author
- **Mukesh Chaudhary** - [GitHub Profile](https://github.com/mukeshchaudhary14)
