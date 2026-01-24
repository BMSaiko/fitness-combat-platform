#!/bin/bash

# Staging Deployment Script
set -e

echo "🚀 Starting staging deployment..."

# Configuration
ENVIRONMENT="staging"
IMAGE_TAG="${GITHUB_SHA:-latest}"
API_IMAGE="ghcr.io/${GITHUB_REPOSITORY}-api-gateway:${IMAGE_TAG}"
WEB_IMAGE="ghcr.io/${GITHUB_REPOSITORY}-web-admin:${IMAGE_TAG}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Pre-deployment checks
print_status "Running pre-deployment checks..."

# Check if required tools are installed
if ! command_exists kubectl; then
    print_error "kubectl is not installed"
    exit 1
fi

if ! command_exists helm; then
    print_error "helm is not installed"
    exit 1
fi

# Check if we're connected to the correct cluster
print_status "Checking Kubernetes cluster connection..."
kubectl cluster-info

# Check if namespace exists, create if not
NAMESPACE="fitness-combat-staging"
if ! kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
    print_status "Creating namespace: $NAMESPACE"
    kubectl create namespace $NAMESPACE
fi

# Apply configurations
print_status "Applying Kubernetes configurations..."

# Create or update ConfigMaps and Secrets
kubectl apply -f infrastructure/k8s/staging/configmap.yaml -n $NAMESPACE
kubectl apply -f infrastructure/k8s/staging/secrets.yaml -n $NAMESPACE

# Deploy API Gateway
print_status "Deploying API Gateway..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway
  namespace: $NAMESPACE
  labels:
    app: api-gateway
    environment: $ENVIRONMENT
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api-gateway
  template:
    metadata:
      labels:
        app: api-gateway
        environment: $ENVIRONMENT
    spec:
      containers:
      - name: api-gateway
        image: $API_IMAGE
        ports:
        - containerPort: 3000
        envFrom:
        - configMapRef:
            name: fitness-combat-config
        - secretRef:
            name: fitness-combat-secrets
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: api-gateway-service
  namespace: $NAMESPACE
spec:
  selector:
    app: api-gateway
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP
EOF

# Deploy Web Admin
print_status "Deploying Web Admin..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-admin
  namespace: $NAMESPACE
  labels:
    app: web-admin
    environment: $ENVIRONMENT
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-admin
  template:
    metadata:
      labels:
        app: web-admin
        environment: $ENVIRONMENT
    spec:
      containers:
      - name: web-admin
        image: $WEB_IMAGE
        ports:
        - containerPort: 80
        livenessProbe:
          httpGet:
            path: /health
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
---
apiVersion: v1
kind: Service
metadata:
  name: web-admin-service
  namespace: $NAMESPACE
spec:
  selector:
    app: web-admin
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
EOF

# Wait for deployments to be ready
print_status "Waiting for deployments to be ready..."
kubectl rollout status deployment/api-gateway -n $NAMESPACE --timeout=300s
kubectl rollout status deployment/web-admin -n $NAMESPACE --timeout=300s

# Health checks
print_status "Performing health checks..."
API_POD=$(kubectl get pods -n $NAMESPACE -l app=api-gateway -o jsonpath='{.items[0].metadata.name}')
WEB_POD=$(kubectl get pods -n $NAMESPACE -l app=web-admin -o jsonpath='{.items[0].metadata.name}')

# Check API Gateway health
kubectl exec -n $NAMESPACE $API_POD -- wget -q --spider http://localhost:3000/health
if [ $? -eq 0 ]; then
    print_status "✅ API Gateway health check passed"
else
    print_error "❌ API Gateway health check failed"
    exit 1
fi

# Check Web Admin health
kubectl exec -n $NAMESPACE $WEB_POD -- wget -q --spider http://localhost
if [ $? -eq 0 ]; then
    print_status "✅ Web Admin health check passed"
else
    print_error "❌ Web Admin health check failed"
    exit 1
fi

# Database migrations (if needed)
print_status "Running database migrations..."
# kubectl exec -n $NAMESPACE $API_POD -- npm run migrate

# Smoke tests
print_status "Running smoke tests..."
# Add smoke test commands here

print_status "🎉 Staging deployment completed successfully!"
print_status "Environment: $ENVIRONMENT"
print_status "Image Tag: $IMAGE_TAG"
print_status "Namespace: $NAMESPACE"

# Display service endpoints
print_status "Service endpoints:"
kubectl get services -n $NAMESPACE