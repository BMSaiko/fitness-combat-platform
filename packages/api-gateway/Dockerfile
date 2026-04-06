# Build stage
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY packages/api-gateway/package*.json ./packages/api-gateway/

# Install dependencies
RUN npm ci --ignore-scripts

# Copy source code
COPY packages/api-gateway/ ./packages/api-gateway/

# Build
WORKDIR /app/packages/api-gateway
RUN npm run build 2>/dev/null || echo "Build skipped - no build script"

# Development stage
FROM node:20-alpine

WORKDIR /app

# Install nodemon globally for hot reload
RUN npm install -g nodemon

# Copy package files
COPY package*.json ./
COPY packages/api-gateway/package*.json ./packages/api-gateway/

# Install dependencies
RUN npm ci --ignore-scripts

# Copy source code
COPY packages/api-gateway/ ./packages/api-gateway/

# Expose port
EXPOSE 3000

# Start development server
CMD ["sh", "-c", "cd /app/packages/api-gateway && npm run dev || node src/index.js"]