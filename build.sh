#!/bin/bash

# Variables
DOCKER_IMAGE="portfolio"
DOCKER_HUB_USER="sanmathisedhupathi"
CONTAINER_NAME="react-portfolio"
K8S_DEPLOYMENT="react-portfolio-deployment"
DOCKER_PASSWORD="08-Sep-2004"  # Use Jenkins credentials securely

echo "Starting Deployment Script"

# Step 1: Build React App
echo "Building React Application..."
npm install
npm run build

# Step 2: Build Docker Image
echo "Building Docker Image..."
docker build -t portfolio .
docker images
# Step 3: Push Docker Image to Docker Hub
echo "Pushing Docker Image to Docker Hub..."
docker login -u sanmathisedhupathi -p dckr_pat_l2TyXcYQcRWefKTrn_zg0AwISnM
docker tag portfolio sanmathisedhupathi/myportfolio
docker push sanmathisedhupathi/myportfolio

# Check if kubectl is installed, if not, install it

minikube start

# Step 5: Deploy new version on Kubernetes using YAML deployment file
# echo "Deploying new version..."
# kubectl apply -f deployment.yaml
kubectl create deployment react-portfolio-deployment --image=sanmathisedhupathi/myportfolio:latest --port=80
# Step 6: Expose the app as a service
echo "Exposing Service..."
kubectl expose deployment react-portfolio-deployment  --type=NodePort --port=80

# Step 7: Get deployment details
echo "Deployment Completed Successfully"
kubectl get pods
kubectl get services
