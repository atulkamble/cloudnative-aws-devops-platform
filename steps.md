# Cloud Native AWS DevOps Platform – End-to-End Project Documentation

## Project Repository

[cloudnative-aws-devops-platform GitHub Repository](https://github.com/atulkamble/cloudnative-aws-devops-platform?utm_source=chatgpt.com)

---

# 1. Application Development Stage

## Fork & Clone Repository

```bash
git clone https://github.com/atulkamble/cloudnative-aws-devops-platform
cd cloudnative-aws-devops-platform
code .
```

---

## Verify Project Structure

```bash
tree
```

---

## Install Python Dependencies

```bash
pip install -r requirements.txt
```

---

## Run Flask Application

```bash
python app.py
```

---

## Access Application

```text
http://localhost:5000
```

---

## Create Development Branch

```bash
git branch dev
git checkout dev
```

---

## Push Code to GitHub

```bash
git add .
git commit -m "code"
git push origin dev
```

---

# 2. Docker Containerization Stage

## Build Docker Image

```bash
docker build -t app:dev --load .
```

---

## Verify Docker Images

```bash
docker images
```

---

## Run Docker Container

```bash
docker run -d -p 5000:5000 app:dev
```

---

## Access Containerized Application

```text
http://localhost:5000
```

---

## Verify Running Containers

```bash
docker container ls
```

---

## Stop Running Container

```bash
docker container stop 5ce88066f81f
```

---

# Push Docker Image to Docker Hub

## Build Image for Docker Hub

```bash
sudo docker buildx build -t docker.io/atuljkamble/cloudnativeapp:dev --load .
```

---

## Push Image

```bash
sudo docker push docker.io/atuljkamble/cloudnativeapp:dev
```

---

# 3. Jenkins CI/CD Setup using Terraform

## Navigate to Terraform Jenkins Directory

```bash
cd terraform/jenkins
```

---

## Initialize Terraform

```bash
terraform init
```

---

## Review Infrastructure Plan

```bash
terraform plan
```

---

## Deploy Infrastructure

```bash
terraform apply -auto-approve
```

---

# Access Jenkins Server

```text
http://44.204.48.74:8080
```

---

## Retrieve Jenkins Initial Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

# Install Required Jenkins Plugins

## Recommended Plugins

* Docker
* Docker Pipeline
* Blue Ocean

---

# Jenkins Pipeline Configuration

## Steps

### Create Jenkins Pipeline

* Open Jenkins Dashboard
* Click **New Item**
* Select **Pipeline**
* Enter Pipeline Name
* Click **OK**

---

### Configure Git Repository

Add GitHub repository URL:

```text
https://github.com/atulkamble/cloudnative-aws-devops-platform
```

---

### Add Jenkins Credentials

Configure:

* GitHub Credentials
* Docker Hub Credentials

---

### Build and Run Pipeline

* Click **Build Now**
* Monitor pipeline execution logs

---

# 4. Kubernetes Deployment on Amazon EKS

## Navigate to Scripts Directory

```bash
cd scripts
```

---

## Execute EKS Cluster Script

```bash
./eks.sh
```

---

# Configure kubectl Access

```bash
aws eks update-kubeconfig \
  --name mycluster \
  --region us-east-1
```

---

# Deploy Kubernetes Resources

## Create Namespace

```bash
kubectl apply -f namespace.yml
```

---

## Deploy Application

```bash
kubectl apply -f deployment.yml
```

---

## Create Kubernetes Service

```bash
kubectl apply -f service.yml
```

---

## Configure Horizontal Pod Autoscaler

```bash
kubectl apply -f hpa.yml
```

---

# Verify Kubernetes Resources

## Check Pods

```bash
kubectl get pods -n production
```

---

## Check Services

```bash
kubectl get svc -n production
```

---

# Access Application via AWS Load Balancer

```text
a9acdf42f45484bbbb867d720a551045-1190007466.us-east-1.elb.amazonaws.com
```

---

# DevOps Workflow Summary

```text
Developer Code
        ↓
GitHub Repository
        ↓
Docker Build
        ↓
Docker Hub Push
        ↓
Terraform Provisioning
        ↓
Jenkins CI/CD Pipeline
        ↓
Amazon EKS Deployment
        ↓
Kubernetes Autoscaling
        ↓
Production Application
```

---

# Tools & Technologies Used

| Category                | Tools                    |
| ----------------------- | ------------------------ |
| Version Control         | Git, GitHub              |
| Programming             | Python Flask             |
| Containerization        | Docker                   |
| CI/CD                   | Jenkins                  |
| Infrastructure as Code  | Terraform                |
| Cloud Platform          | AWS                      |
| Container Orchestration | Kubernetes (EKS)         |
| Monitoring Ready        | HPA / Kubernetes Scaling |

---

# Important Commands Reference

## Docker

```bash
docker images
docker ps
docker logs <container-id>
docker exec -it <container-id> bash
```

---

## Kubernetes

```bash
kubectl get all -n production
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production
kubectl delete pod <pod-name> -n production
```

---

# Production-Level Best Practices

* Use Separate Branches:

  * dev
  * staging
  * production

* Store secrets using:

  * AWS Secrets Manager
  * Kubernetes Secrets

* Enable:

  * Auto Scaling
  * Monitoring
  * Logging
  * Health Checks

* Use:

  * Multi-stage Docker builds
  * Jenkins Shared Libraries
  * Terraform Remote Backend

* Add:

  * SonarQube Code Analysis
  * Trivy Container Scanning
  * Prometheus & Grafana Monitoring

---

# Final Architecture

```text
GitHub → Jenkins → Docker → DockerHub → EKS → LoadBalancer → Users
```
