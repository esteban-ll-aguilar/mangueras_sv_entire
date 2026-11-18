FROM docker.io/nginxinc/nginx-unprivileged:alpine

COPY build/web/ /usr/share/nginx/html/

EXPOSE 8080

USER 101
