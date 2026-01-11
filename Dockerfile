# Use official Nginx Alpine image for lightweight container
FROM nginx:alpine

# Add labels for better maintainability
LABEL maintainer="devendra"
LABEL version="1.0"
LABEL description="AWS DevOps Project - Containerized Web Application"

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy application files
COPY app/ /usr/share/nginx/html/

# Create custom nginx configuration for better performance
RUN echo 'server { \
    listen 80; \
    server_name localhost; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ /index.html; \
    } \
    location /health { \
        return 200 "healthy"; \
        add_header Content-Type text/plain; \
    } \
}' > /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://localhost/health || exit 1

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
