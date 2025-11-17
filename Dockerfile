FROM node:18-alpine AS builder
WORKDIR /app

# Install dependencies (include dev deps because Vite build needs them)
COPY package*.json ./
RUN npm ci

# Copy source and build
COPY . .
RUN npm run build

FROM nginx:stable-alpine

# Copy built files from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Replace default nginx config with a SPA-friendly one
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
