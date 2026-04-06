# Development stage
FROM node:20-alpine

WORKDIR /app

RUN npm install -g nodemon

COPY package*.json ./
COPY packages/exercise-service/package*.json ./packages/exercise-service/

RUN npm ci --ignore-scripts

COPY packages/exercise-service/ ./packages/exercise-service/

EXPOSE 3002

CMD ["sh", "-c", "cd /app/packages/exercise-service && npm run dev || node src/index.js"]