# Docker Deployment Guide for Flappy Bird Physics

This guide explains how to containerize and deploy your Flappy Bird Physics Flutter application using Docker.

## 📋 Prerequisites

- Docker installed on your system ([Download Docker](https://www.docker.com/products/docker-desktop))
- Docker Compose (included with Docker Desktop)

## 🚀 Quick Start

### Option 1: Using Docker Compose (Recommended)

1. **Build and run the application:**
   ```bash
   docker-compose up -d
   ```

2. **Access the application:**
   Open your browser and navigate to: `http://localhost:8080`

3. **Stop the application:**
   ```bash
   docker-compose down
   ```

### Option 2: Using Docker Commands

1. **Build the Docker image:**
   ```bash
   docker build -t flappy-bird-physics .
   ```

2. **Run the container:**
   ```bash
   docker run -d -p 8080:80 --name flappy-bird-app flappy-bird-physics
   ```

3. **Access the application:**
   Open your browser and navigate to: `http://localhost:8080`

4. **Stop and remove the container:**
   ```bash
   docker stop flappy-bird-app
   docker remove flappy-bird-app
   ```

## 🔧 Advanced Configuration

### Change the Port

To run the application on a different port (e.g., 3000), modify the port mapping:

**Docker Compose:**
```yaml
ports:
  - "3000:80"
```

**Docker Command:**
```bash
docker run -d -p 3000:80 --name flappy-bird-app flappy-bird-physics
```

### Build for Production

The Dockerfile is already optimized for production with:
- Multi-stage build to reduce image size
- nginx as a lightweight web server
- Gzip compression enabled
- Proper caching headers
- Security headers

## 📦 Docker Image Details

### Build Stages

1. **Build Stage:**
   - Uses Ubuntu 22.04 base image
   - Installs Flutter SDK (stable channel)
   - Builds the Flutter web app with release mode
   - Uses CanvasKit renderer for better performance

2. **Runtime Stage:**
   - Uses nginx:alpine for minimal image size
   - Serves the static web files
   - Configured with optimized nginx settings

### Image Size Optimization

The final image uses alpine-based nginx, keeping the size minimal while the build artifacts are discarded.

## 🌐 Deployment Options

### Deploy to Cloud Platforms

#### Docker Hub
```bash
# Tag the image
docker tag flappy-bird-physics yourusername/flappy-bird-physics:latest

# Push to Docker Hub
docker push yourusername/flappy-bird-physics:latest
```

#### AWS ECS/Fargate
- Upload image to Amazon ECR
- Create ECS task definition
- Deploy as ECS service

#### Google Cloud Run
```bash
# Build and push to Google Container Registry
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/flappy-bird-physics

# Deploy to Cloud Run
gcloud run deploy flappy-bird-physics \
  --image gcr.io/YOUR_PROJECT_ID/flappy-bird-physics \
  --platform managed \
  --port 80 \
  --allow-unauthenticated
```

#### Azure Container Instances
```bash
# Push to Azure Container Registry
az acr build --registry YOUR_REGISTRY --image flappy-bird-physics .

# Deploy to ACI
az container create \
  --resource-group YOUR_RG \
  --name flappy-bird-physics \
  --image YOUR_REGISTRY.azurecr.io/flappy-bird-physics \
  --dns-name-label flappy-bird-unique \
  --ports 80
```

#### DigitalOcean App Platform
- Connect your GitHub repository
- DigitalOcean will auto-detect the Dockerfile
- Deploy with one click

#### Heroku
```bash
# Login to Heroku Container Registry
heroku container:login

# Push and release
heroku container:push web -a your-app-name
heroku container:release web -a your-app-name
```

## 🐛 Troubleshooting

### Container fails to start
```bash
# Check container logs
docker logs flappy-bird-app

# Or with docker-compose
docker-compose logs -f
```

### Audio not working
Audio files are embedded in the build. Ensure:
- Assets are properly declared in `pubspec.yaml`
- The `assets/` directory is not in `.dockerignore`
- Browser permissions allow audio playback

### Build takes too long
- First build downloads Flutter SDK (~1-2 GB) and takes 10-20 minutes
- Subsequent builds are faster using Docker cache
- Consider using a pre-built Flutter image for faster builds

### Port already in use
```bash
# Find what's using the port
netstat -ano | findstr :8080

# Use a different port
docker run -d -p 8081:80 --name flappy-bird-app flappy-bird-physics
```

## 📊 Monitoring

### View running containers
```bash
docker ps
```

### Check resource usage
```bash
docker stats flappy-bird-app
```

### Access container shell
```bash
docker exec -it flappy-bird-app sh
```

## 🔄 Updates and Rebuilding

After making code changes:

1. **Rebuild the image:**
   ```bash
   docker-compose build
   ```

2. **Restart with new image:**
   ```bash
   docker-compose up -d
   ```

Or in one command:
```bash
docker-compose up -d --build
```

## 🔒 Security Best Practices

- The nginx configuration includes security headers
- No sensitive data is embedded in the image
- The container runs as non-root user (nginx default)
- Regular updates: `docker pull nginx:alpine` and rebuild

## 📝 Environment Variables

You can add environment variables in `docker-compose.yml`:
```yaml
environment:
  - ENV_VAR_NAME=value
  - TZ=America/New_York
```

## 🎯 Performance Tips

1. **Use CDN for assets** - Consider serving large assets from a CDN
2. **Enable HTTPS** - Use a reverse proxy like Traefik or Caddy
3. **Horizontal Scaling** - Run multiple containers behind a load balancer
4. **Monitoring** - Integrate with tools like Prometheus and Grafana

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Flutter Web Documentation](https://flutter.dev/web)
- [nginx Documentation](https://nginx.org/en/docs/)

## 🆘 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review Docker logs
3. Ensure Docker is running and up to date
4. Check that all files (Dockerfile, nginx.conf, etc.) are in the project root

---

**Happy Deploying! 🚀**
