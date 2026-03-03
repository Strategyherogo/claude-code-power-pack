# Skill: docker
Docker container management and Dockerfile generation.

## Auto-Trigger
**When:** "docker", "dockerfile", "container", "containerize", "docker-compose"

## Dockerfile Templates

### Node.js
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY package*.json ./
EXPOSE 3000
USER node
CMD ["node", "dist/index.js"]
```

### Python
```dockerfile
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Go
```dockerfile
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o main .

FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]
```

## Docker Compose

### Basic Web + DB
```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_URL=postgres://postgres:password@db:5432/mydb
    depends_on:
      - db

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Full Stack
```yaml
version: '3.8'

services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    depends_on:
      - api

  api:
    build: ./api
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgres://postgres:password@db:5432/mydb
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  postgres_data:
```

## Common Commands

### Build & Run
```bash
# Build image
docker build -t myapp:latest .

# Run container
docker run -d -p 3000:3000 --name myapp myapp:latest

# Run with env vars
docker run -d -p 3000:3000 --env-file .env myapp:latest

# Run interactive
docker run -it --rm myapp:latest /bin/sh
```

### Docker Compose
```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop all
docker-compose down

# Rebuild and start
docker-compose up -d --build
```

### Debugging
```bash
# List containers
docker ps -a

# View logs
docker logs -f <container>

# Execute in container
docker exec -it <container> /bin/sh

# Inspect container
docker inspect <container>

# Resource usage
docker stats
```

### Cleanup
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune -a

# Remove all unused (containers, images, networks)
docker system prune -a

# Remove volumes too
docker system prune -a --volumes
```

## .dockerignore
```
node_modules
npm-debug.log
.git
.gitignore
.env
*.md
Dockerfile
docker-compose.yml
.dockerignore
coverage
tests
*.test.js
```

## Best Practices

### 1. Use Multi-Stage Builds
Reduces image size by separating build and runtime.

### 2. Don't Run as Root
```dockerfile
USER node  # or create non-root user
```

### 3. Use Specific Tags
```dockerfile
FROM node:20.10-alpine  # Not just node:latest
```

### 4. Layer Caching
```dockerfile
# Copy package files first (changes less often)
COPY package*.json ./
RUN npm ci

# Then copy source (changes more often)
COPY . .
```

### 5. Health Checks
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost:3000/health || exit 1
```

## Quick Commands
```
/docker init              # Create Dockerfile for current project
/docker compose           # Generate docker-compose.yml
/docker debug <container> # Help debug container issues
/docker optimize          # Optimize Dockerfile
```

---
Last updated: 2026-01-29
