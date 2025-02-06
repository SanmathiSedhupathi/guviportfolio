#!/bin/bash

# Variables
DOCKER_IMAGE="sanmathisedhupathi/myportfolio"
DOCKER_HUB_USER="sanmathisedhupathi"
CONTAINER_NAME="react-portfolio"
K8S_DEPLOYMENT="react-portfolio-deployment"

echo "Starting Deployment Script"

# Step 1: Install npm and dependencies
echo "Installing npm and dependencies..."
apt-get update && apt-get install -y nodejs npm
npm install
apt update
apt install -y curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Step 2: Build React App
echo "Building React Application..."
npm run build

# Step 3: Build Docker Image
echo "Building Docker Image..."
docker build -t $DOCKER_IMAGE:latest .

# Step 4: Push Docker Image to Docker Hub
echo "Pushing Docker Image to Docker Hub..."
docker login -u "$DOCKER_HUB_USER" -p "$DOCKER_PASSWORD"
docker push $DOCKER_IMAGE:latest

# Step 5: Remove existing Kubernetes deployment (if any)
echo "Removing existing deployment..."
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl delete deployment $K8S_DEPLOYMENT --ignore-not-found=true

# Step 6: Deploy new version on Kubernetes
echo "Deploying new version..."
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl run $K8S_DEPLOYMENT --image=$DOCKER_IMAGE:latest --port=80

# Step 7: Expose the app as a service
echo "Exposing Service..."
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl expose deployment $K8S_DEPLOYMENT --type=LoadBalancer --port=80

# Step 8: Get deployment details
echo "Deployment Completed Successfully"
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl get pods
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl:latest kubectl get services
