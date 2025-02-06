#!/bin/bash

# Variables
DOCKER_IMAGE="sanmathisedhupathi/myportfolio"
DOCKER_HUB_USER="sanmathisedhupathi"
CONTAINER_NAME="react-portfolio"
K8S_DEPLOYMENT="react-portfolio-deployment"
DOCKER_PASSWORD=$DOCKER_PASSWORD  # Use Jenkins credentials securely

echo "Starting Deployment Script"

# Step 1: Build React App
echo "Building React Application..."
npm install
npm run build

# Step 2: Build Docker Image
echo "Building Docker Image..."
docker build -t $DOCKER_IMAGE:latest .

# Step 3: Push Docker Image to Docker Hub
echo "Pushing Docker Image to Docker Hub..."
docker login -u "$DOCKER_HUB_USER" -p "$DOCKER_PASSWORD"
docker push $DOCKER_IMAGE:latest

# Check if kubectl is installed, if not, install it
if ! command -v kubectl &> /dev/null
then
    echo "kubectl not found, installing..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    sudo apt-add-repository "deb https://apt.kubernetes.io/ kubernetes-xenial main"
    sudo apt-get update
    sudo apt-get install -y kubectl
else
    echo "kubectl is already installed"
fi

# Step 4: Remove existing Kubernetes deployment (if any)
echo "Removing existing deployment..."
kubectl delete deployment $K8S_DEPLOYMENT --ignore-not-found=true

# Step 5: Deploy new version on Kubernetes using YAML deployment file
echo "Deploying new version..."
kubectl apply -f deployment.yaml

# Step 6: Expose the app as a service
echo "Exposing Service..."
kubectl expose deployment $K8S_DEPLOYMENT --type=LoadBalancer --port=80

# Step 7: Get deployment details
echo "Deployment Completed Successfully"
kubectl get pods
kubectl get services
