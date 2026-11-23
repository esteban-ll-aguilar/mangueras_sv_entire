# Evidencia de construcción del contenedor

```bash
podman build --tag mangueras-sv-web:phase4 .
podman run --detach --publish 18080:8080 mangueras-sv-web:phase4
curl --fail http://127.0.0.1:18080/
```

Resultado observado:

- Build completado correctamente.
- Servidor respondió `HTTP/1.1 200 OK`.
- Usuario efectivo: `101` (no root).
- Puerto expuesto: `8080/tcp`.
- Base: `nginx-unprivileged:alpine`.

Se utilizó Podman para la comprobación local porque el daemon de Docker no estaba disponible en el entorno de ejecución. El Dockerfile es compatible con Docker.
