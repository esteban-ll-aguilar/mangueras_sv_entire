# Fase 4 — SAST y endurecimiento en contenedores Docker

**Semana 8:** 23–27 de noviembre de 2026  
**Objetivo:** ejecutar análisis estático, corregir los conflictos detectados, construir una imagen mínima y verificarla con un escáner de vulnerabilidades.

## 1. SAST y remediación

Comando ejecutado:

```bash
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings
```

Resultado: salida 0. Se revisaron 189 avisos informativos/lints; no quedaron errores bloqueantes ni marcadores de conflicto Git. También se verificó:

```bash
flutter test --no-pub
flutter build web --release --no-pub
```

Ambos comandos finalizaron correctamente. La remediación principal fue resolver los conflictos en los providers, páginas y widgets Dart afectados. La tabla de archivos y la evidencia ampliada están en [evidencias SAST](evidencias/sast-result.md).

### Evidencia SAST incorporada

| Archivo/área | Hallazgo | Corrección | Verificación |
|---|---|---|---|
| `authProvider.dart`, `loginPage.dart` | Conflictos Git | Se integró una única implementación y se eliminaron marcadores | `flutter analyze`: código 0 |
| Repositorios de inventario | Conflictos Git | Se conservaron las rutas válidas de acceso a datos | `flutter build web`: correcto |
| Widgets de tienda | Conflictos Git | Se resolvieron filtros y grilla | `flutter test`: correcto |
| Evidencias IDOR | Tokens utilizables en archivos | Tokens reemplazados por `<REDACTED_LAB_TOKEN>` | Gitleaks: sin leaks |

```text
flutter analyze ...
189 issues found (informativos/lints)
Process exited with code 0

flutter test --no-pub
00:00 +1: All tests passed!

flutter build web --release --no-pub
✓ Built build/web
```

## 2. Endurecimiento del contenedor

El [Dockerfile](Dockerfile) usa `nginx-unprivileged:alpine`, actualiza los paquetes con `apk upgrade --no-cache`, copia únicamente `build/web`, expone solo `8080` y finaliza con el usuario sin privilegios `101`. El `.dockerignore` excluye `.env`, `.git`, herramientas de desarrollo, pruebas y documentación.

Construcción y prueba realizadas:

```bash
podman build --tag mangueras-sv-web:phase4 .
podman run --detach --publish 18080:8080 mangueras-sv-web:phase4
curl --fail http://127.0.0.1:18080/
```

Resultado: HTTP 200, usuario efectivo 101 y puerto 8080 publicado. El mismo Dockerfile está disponible en la raíz para la ejecución desde el repositorio.

```text
user=101
ports={"8080/tcp":{}}
HTTP/1.1 200 OK
```

## 3. Escaneo Trivy

Se guardó la imagen y se ejecutó Trivy con severidades HIGH/CRITICAL. La primera revisión identificó paquetes Alpine con versión corregida disponible; se aplicó `apk upgrade --no-cache` en el Dockerfile y se reconstruyó la imagen. La evidencia del ciclo de corrección está en [trivy-scan.md](evidencias/trivy-scan.md).

Resultado final del segundo escaneo:

```text
severity: HIGH,CRITICAL
vulnerabilities: 0
```

## Pregunta de control 4

Un contenedor endurecido reduce superficie de ataque: una imagen mínima instala menos componentes, un usuario no root limita el impacto de una explotación, la exposición de puertos queda restringida y la actualización de paquetes incorpora correcciones conocidas. Estas medidas no sustituyen el escaneo continuo ni la configuración segura del servidor.

## 4. Portafolio de la unidad

La consolidación completa está enlazada desde [APE-02](../README.md) y el [README raíz](../../README.md). El [informe detallado](../../Documents/informe-fase-4-sast-docker.md) conserva los comandos y resultados de verificación.
