# Development stage
FROM node:20-alpine

WORKDIR /app

RUN npm install -g nodemon

COPY package*.json ./
COPY apps/web-admin/package*.json ./apps/web-admin/

RUN npm ci --ignore-scripts

COPY apps/web-admin/ ./apps/web-admin/

EXPOSE 3000

CMD ["sh", "-c", "cd /app/apps/web-admin && npm run dev"]