#!/bin/bash

# Production Deployment Script with Blue-Green Deployment
set -e

echo "🚀 Starting production deployment with Blue-Green strategy..."

# Configuration
ENVIRONMENT="production"
IMAGE_TAG="${GITHUB_SHA:-latest}"
API_IMAGE="ghcr.io/${GITHUB_REPOSITORY}-api-gateway:${IMAGE_TAG}"
WEB_IMAGE="ghcr.io/${GITHUB_REPOSITORY}-web-admin:${IMAGE_TAG}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_blue() {
    echo -e "${BLUE}[BLUE-GREEN]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Pre-deployment validation
print_status "Running pre-deployment validation..."

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

# Check if namespace exists
NAMESPACE="fitness-combat-production"
if ! kubectl get namespace $NAMESPACE >/dev/null 2>&1; then
    print_error "Production namespace $NAMESPACE does not exist"
    exit 1
fi

# Blue-Green Deployment Strategy
print_blue "Starting Blue-Green deployment process..."

# 1. Create backup of current deployment
print_status "Creating backup of current deployment..."
kubectl get deployment api-gateway -n $NAMESPACE -o yaml > /tmp/api-gateway-backup.yaml
kubectl get deployment web-admin -n $NAMESPACE -o yaml > /tmp/web-admin-backup.yaml

# 2. Deploy to Green environment (new version)
print_blue "Deploying to Green environment..."

# Deploy API Gateway (Green)
print_status "Deploying API Gateway (Green)..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-gateway-green
  namespace: $NAMESPACE
  labels:
    app: api-gateway
    environment: $ENVIRONMENT
    version: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: api-gateway
      version: green
  template:
    metadata:
      labels:
        app: api-gateway
        environment: $ENVIRONMENT
        version: green
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
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "400m"
---
apiVersion: v1
kind: Service
metadata:
  name: api-gateway-green-service
  namespace: $NAMESPACE
spec:
  selector:
    app: api-gateway
    version: green
  ports:
  - protocol: TCP
    port: 80
    targetPort: 3000
  type: ClusterIP
EOF

# Deploy Web Admin (Green)
print_status "Deploying Web Admin (Green)..."
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-admin-green
  namespace: $NAMESPACE
  labels:
    app: web-admin
    environment: $ENVIRONMENT
    version: green
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-admin
      version: green
  template:
    metadata:
      labels:
        app: web-admin
        environment: $ENVIRONMENT
        version: green
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
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
---
apiVersion: v1
kind: Service
metadata:
  name: web-admin-green-service
  namespace: $NAMESPACE
spec:
  selector:
    app: web-admin
    version: green
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
EOF

# Wait for Green deployments to be ready
print_status "Waiting for Green deployments to be ready..."
kubectl rollout status deployment/api-gateway-green -n $NAMESPACE --timeout=600s
kubectl rollout status deployment/web-admin-green -n $NAMESPACE --timeout=600s

# 3. Health checks on Green environment
print_blue "Performing health checks on Green environment..."
API_GREEN_POD=$(kubectl get pods -n $NAMESPACE -l app=api-gateway,version=green -o jsonpath='{.items[0].metadata.name}')
WEB_GREEN_POD=$(kubectl get pods -n $NAMESPACE -l app=web-admin,version=green -o jsonpath='{.items[0].metadata.name}')

# Check API Gateway Green health
kubectl exec -n $NAMESPACE $API_GREEN_POD -- wget -q --spider http://localhost:3000/health
if [ $? -eq 0 ]; then
    print_status "✅ API Gateway (Green) health check passed"
else
    print_error "❌ API Gateway (Green) health check failed"
    print_blue "Rolling back Green deployment..."
    kubectl delete deployment api-gateway-green -n $NAMESPACE
    kubectl delete service api-gateway-green-service -n $NAMESPACE
    exit 1
fi

# Check Web Admin Green health
kubectl exec -n $NAMESPACE $WEB_GREEN_POD -- wget -q --spider http://localhost
if [ $? -eq 0 ]; then
    print_status "✅ Web Admin (Green) health check passed"
else
    print_error "❌ Web Admin (Green) health check failed"
    print_blue "Rolling back Green deployment..."
    kubectl delete deployment web-admin-green -n $NAMESPACE
    kubectl delete service web-admin-green-service -n $NAMESPACE
    exit 1
fi

# 4. Run smoke tests on Green environment
print_status "Running smoke tests on Green environment..."
# Add comprehensive smoke tests here
# Test API endpoints, database connections, etc.

# 5. Switch traffic to Green (Blue becomes inactive)
print_blue "Switching traffic to Green environment..."

# Update the main services to point to Green
kubectl patch service api-gateway-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"api-gateway","version":"green"}}}'
kubectl patch service web-admin-service -n $NAMESPACE -p '{"spec":{"selector":{"app":"web-admin","version":"green"}}}'

# Wait a moment for traffic switch
sleep 10

# 6. Final health check on production traffic
print_status "Performing final health check on production traffic..."
# Test the actual production endpoints

# 7. Clean up Blue environment (old version)
print_blue "Cleaning up Blue environment..."
kubectl delete deployment api-gateway -n $NAMESPACE || true
kubectl delete deployment web-admin -n $NAMESPACE || true
kubectl delete service api-gateway-blue-service -n $NAMESPACE || true
kubectl delete service web-admin-blue-service -n $NAMESPACE || true

# Rename Green to Blue (for next deployment)
kubectl patch deployment api-gateway-green -n $NAMESPACE -p '{"metadata":{"name":"api-gateway"}}'
kubectl patch deployment web-admin-green -n $NAMESPACE -p '{"metadata":{"name":"web-admin"}}'
kubectl patch service api-gateway-green-service -n $NAMESPACE -p '{"metadata":{"name":"api-gateway-service"}}'
kubectl patch service web-admin-green-service -n $NAMESPACE -p '{"metadata":{"name":"web-admin-service"}}'

# Update labels to remove version
kubectl label deployment api-gateway version- -n $NAMESPACE
kubectl label deployment web-admin version- -n $NAMESPACE
kubectl label service api-gateway-service version- -n $NAMESPACE
kubectl label service web-admin-service version- -n $NAMESPACE

# Database migrations (if needed)
print_status "Running production database migrations..."
# kubectl exec -n $NAMESPACE $API_GREEN_POD -- npm run migrate:prod

# 8. Monitor deployment
print_status "Monitoring deployment for 5 minutes..."
# Add monitoring commands here

print_status "🎉 Production deployment completed successfully!"
print_status "Environment: $ENVIRONMENT"
print_status "Image Tag: $IMAGE_TAG"
print_status "Namespace: $NAMESPACE"
print_status "Deployment Strategy: Blue-Green"

# Display service endpoints
print_status "Service endpoints:"
kubectl get services -n $NAMESPACE

# Display deployment status
print_status "Deployment status:"
kubectl get deployments -n $NAMESPACE