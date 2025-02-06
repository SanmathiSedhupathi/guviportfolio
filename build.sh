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
docker login -u "$DOCKER_HUB_USER"
docker push $DOCKER_IMAGE:latest

# Step 4: Remove existing Kubernetes deployment (if any)
echo "Removing existing deployment..."
kubectl delete deployment $K8S_DEPLOYMENT --ignore-not-found=true

# Step 5: Deploy new version on Kubernetes
echo "Deploying new version..."
kubectl run $K8S_DEPLOYMENT --image=$DOCKER_IMAGE:latest --port=80

# Step 6: Expose the app as a service
echo "Exposing Service..."
kubectl expose deployment $K8S_DEPLOYMENT --type=LoadBalancer --port=80

# Step 7: Get deployment details
echo "Deployment Completed Successfully"
kubectl get pods
kubectl get services
