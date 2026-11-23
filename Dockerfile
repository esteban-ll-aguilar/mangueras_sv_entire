FROM docker.io/nginxinc/nginx-unprivileged:alpine

# Actualiza los paquetes del sistema para incorporar los parches de seguridad
# disponibles en Alpine durante la construcción de la imagen.
USER root
RUN apk upgrade --no-cache

COPY build/web/ /usr/share/nginx/html/

EXPOSE 8080

USER 101
