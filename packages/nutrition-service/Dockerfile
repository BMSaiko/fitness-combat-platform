# Development stage
FROM node:20-alpine

WORKDIR /app

RUN npm install -g nodemon

COPY package*.json ./
COPY packages/nutrition-service/package*.json ./packages/nutrition-service/

RUN npm ci --ignore-scripts

COPY packages/nutrition-service/ ./packages/nutrition-service/

EXPOSE 3003

CMD ["sh", "-c", "cd /app/packages/nutrition-service && npm run dev || node src/index.js"]