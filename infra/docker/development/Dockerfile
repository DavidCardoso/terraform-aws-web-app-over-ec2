ARG NGINX_VERSION

FROM --platform=linux/amd64 nginx:${NGINX_VERSION}

# Web App public files
COPY app/public /usr/share/nginx/html
