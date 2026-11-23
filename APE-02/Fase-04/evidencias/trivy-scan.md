# Evidencia de Trivy

## Comando

```bash
podman save --output /tmp/mangueras-sv-web-phase4.tar mangueras-sv-web:phase4
trivy image --input /tmp/mangueras-sv-web-phase4.tar \
  --severity HIGH,CRITICAL --ignore-unfixed
```

## Hallazgo y corrección

La primera lectura de la imagen encontró 14 vulnerabilidades HIGH/CRITICAL con versión corregida disponible en paquetes Alpine. El hallazgo relevante afectaba dependencias del sistema (`brotli`, `curl`, `musl`, `zlib` y otras). La corrección aplicada fue ejecutar `apk upgrade --no-cache` durante la construcción, antes de copiar la aplicación y volver a fijar el proceso al usuario 101.

La imagen se reconstruyó y se volvió a probar con el smoke test HTTP 200. El segundo escaneo terminó con **0 vulnerabilidades HIGH/CRITICAL**. El resultado completo y la justificación están documentados en el [informe de Fase 4](../../../Documents/informe-fase-4-sast-docker.md).

## Limitación reproducible

Docker Scout no pudo ejecutarse porque el cliente Docker local solicitó autenticación y el daemon no estaba disponible. Por eso se usó Trivy sobre el tar exportado por Podman, dejando registrado el comando y el resultado.
