# Development stage
FROM node:20-alpine

WORKDIR /app

# Install nodemon globally for hot reload
RUN npm install -g nodemon

# Copy package files
COPY package*.json ./
COPY packages/auth-service/package*.json ./packages/auth-service/

# Install dependencies
RUN npm ci --ignore-scripts

# Copy source code
COPY packages/auth-service/ ./packages/auth-service/

# Expose port
EXPOSE 3001

# Start development server
CMD ["sh", "-c", "cd /app/packages/auth-service && npm run dev || node src/index.js"]