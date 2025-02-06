#!/bin/bash

# Variables
DOCKER_IMAGE="sanmathisedhupathi/myportfolio"
DOCKER_HUB_USER="sanmathisedhupathi"
CONTAINER_NAME="react-portfolio"
K8S_DEPLOYMENT="react-portfolio-deployment"

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
docker login -u "$DOCKER_HUB_USER" -p 08-Sep-2004
docker push $DOCKER_IMAGE:latest

# Step 4: Use Docker image with kubectl pre-installed
echo "Using bitnami/kubectl Docker image to run kubectl commands..."

# Pull kubectl-enabled Docker image
docker pull bitnami/kubectl:latest

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

echo "Deployment Script Finished"
