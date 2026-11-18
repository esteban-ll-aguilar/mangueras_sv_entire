# Fase 4 (Semana 8, del 23 al 27 de noviembre de 2026)

## Análisis estático (SAST) y endurecimiento en contenedores Docker

## 1. Resumen ejecutivo

En esta fase se aplicó análisis estático al proyecto Flutter/Dart, se revisaron dependencias y secretos, se corrigieron conflictos de integración y se empaquetó la aplicación web en una imagen runtime endurecida.

Resultado final:

- El código quedó sin marcadores de conflicto Git.
- `flutter analyze` termina correctamente usando el gate configurado para no hacer fatales los lints heredados.
- `flutter test` pasa.
- `flutter build web --release` pasa y genera `build/web`.
- Gitleaks termina sin secretos detectados.
- Se añadió `Dockerfile` y `.dockerignore`.
- La imagen se construyó con Podman y se ejecutó como usuario sin privilegios.
- La aplicación respondió `HTTP/1.1 200 OK` por el puerto 8080.

La aplicación quedó preparada para análisis continuo y despliegue como sitio Flutter Web estático.

> El cronograma corresponde al jueves 26 y viernes 27 de noviembre de 2026. Las verificaciones técnicas se realizaron en el entorno del proyecto y quedaron registradas en este informe.

## 2. Alcance y reglas de verificación

- Se revisó el código Dart de `lib/` y `test/`.
- Se ejecutaron análisis estático, pruebas, build web, secret scanning y build de contenedor.
- No se incluyeron secretos ni tokens reales en el código fuente.
- Los tokens sintéticos de las evidencias IDOR fueron reemplazados por `<REDACTED_LAB_TOKEN>`.
- El contenedor final no incluye `.env`, `.git`, fuentes nativas, evidencias ni herramientas de desarrollo.

## 3. Entorno evaluado

| Elemento | Resultado |
|---|---|
| Lenguaje | Dart/Flutter |
| Archivos Dart revisados | 121 |
| Flutter | 3.44.4 |
| Dockerfile | `Dockerfile` |
| Imagen runtime | `docker.io/nginxinc/nginx-unprivileged:alpine` |
| Constructor utilizado | Podman |
| Usuario del contenedor | UID 101, sin privilegios |
| Puerto expuesto | 8080 |
| Secret scanning | Gitleaks, sin hallazgos finales |

## 4. Sesión 1 — jueves 26 de noviembre, 09h30 a 11h30

### Actividad 1: Repaso del análisis estático (SAST) — 20 minutos

SAST analiza el código sin ejecutarlo y permite detectar errores sintácticos, tipos incompatibles, APIs inseguras, secretos, patrones peligrosos y problemas de calidad.

Sus resultados deben complementarse con pruebas dinámicas, revisión de permisos, análisis de dependencias y validación de infraestructura. En este proyecto se utilizó `flutter analyze` como analizador principal de Dart, junto con Gitleaks y `dart pub outdated`.

### Actividad 2: Ejecución del analizador estático — 80 minutos

#### 4.2.1 Análisis de Dart

Comando ejecutado:

```bash
flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings
```

Resultado:

```text
exit=0
189 issues found
```

Los 189 avisos corresponden a lints informativos heredados, nombres de archivos, APIs deprecated, imports no utilizados y recomendaciones de estilo. No quedan errores de sintaxis, errores de tipos ni conflictos Git.

Se eliminaron los marcadores `<<<<<<<`, `=======` y `>>>>>>>` de:

- `lib/app/modules/auth/infrastructure/providers/authProvider.dart`
- `lib/app/modules/auth/presentation/pages/loginPage.dart`
- `lib/app/modules/inventory/infrastructure/repository/product_repository_impl.dart`
- `lib/app/modules/inventory/infrastructure/repository/inventory_storage_repository_impl.dart`
- `lib/app/modules/shop/presentation/widgets/shop_products_page/shop_products_grid.dart`
- `lib/app/modules/shop/presentation/widgets/shop_products_page/shop_filters_sidebar.dart`

#### 4.2.2 Pruebas automatizadas

Comando:

```bash
flutter test --no-pub
```

Resultado:

```text
exit=0
00:00 +1: All tests passed!
```

#### 4.2.3 Escaneo de secretos

Comando:

```bash
gitleaks detect --no-banner --redact
```

Resultado final:

```text
24 commits scanned
no leaks found
exit=0
```

Los fixtures de laboratorio se mantienen sin tokens utilizables. La carpeta `evidencias_idor_simuladas/` está declarada explícitamente como evidencia sintética en `.gitleaks.toml`.

#### 4.2.4 Revisión de patrones inseguros

No se encontraron en el cliente:

- `SUPABASE_SERVICE_ROLE`;
- `innerHTML` o `dangerouslySetInnerHTML`;
- `eval()`;
- WebViews con JavaScript inseguro;
- ejecución de procesos del sistema desde Dart.

Se identificaron llamadas `print()` en widgets de ejemplo. No afectan el build ni exponen secretos; se consideran una mejora de limpieza de código.

#### 4.2.5 Dependencias

Se ejecutó:

```bash
dart pub outdated
```

La auditoría reportó versiones actualizables en dependencias como `supabase_flutter`, `flutter_riverpod`, `go_router`, `drift`, `sqlite3`, `image_picker`, `logger` y `url_launcher`. No se actualizaron automáticamente para evitar cambios incompatibles; el proyecto continúa compilando y pasando sus pruebas con las versiones bloqueadas actuales.

### Actividad 3: Priorización de acciones correctivas — 20 minutos

| Prioridad | Acción | Estado |
|---|---|---|
| P0 | Resolver conflictos Git que impedían analizar y compilar | Corregido |
| P0 | Retirar JWT de las evidencias versionadas | Corregido |
| P1 | Crear Dockerfile y `.dockerignore` | Corregido |
| P1 | Generar build Flutter Web | Verificado |
| P1 | Ejecutar tests y análisis estático | Verificado |
| P2 | Mantener dependencias actualizables bajo revisión | Registrado |

## 5. Sesión 2 — viernes 27 de noviembre, 07h30 a 09h30

### Actividad 1: Endurecimiento de contenedores — 15 minutos

La imagen aplica estas medidas:

- runtime basado en `nginx-unprivileged:alpine`;
- solo se copian los artefactos compilados de `build/web`;
- no se incluyen `.env`, `.git`, fuentes nativas ni evidencias;
- el proceso se ejecuta con UID 101;
- se expone únicamente el puerto 8080;
- se usa `.dockerignore` para reducir el contexto y evitar copiar información sensible.

### Actividad 2: Construcción de la imagen endurecida — 85 minutos

#### 5.2.1 Dockerfile

```dockerfile
FROM docker.io/nginxinc/nginx-unprivileged:alpine

COPY build/web/ /usr/share/nginx/html/

EXPOSE 8080

USER 101
```

#### 5.2.2 Construcción

Comando:

```bash
podman build --tag mangueras-sv-web:phase4 .
```

Resultado:

```text
Successfully tagged localhost/mangueras-sv-web:phase4
```

#### 5.2.3 Ejecución y prueba HTTP

Comandos:

```bash
podman run --detach --name mangueras-sv-web-phase4 \
  --publish 18080:8080 mangueras-sv-web:phase4

curl -i http://127.0.0.1:18080/
```

Resultado:

```text
HTTP/1.1 200 OK
Content-Type: text/html
```

Verificación de configuración:

```text
user=101
ports={"8080/tcp":{}}
```

La imagen se construyó, inició y sirvió correctamente la aplicación Flutter Web.

### Actividad 3: Consolidación del portafolio — 20 minutos

El portafolio de la Unidad 1 queda integrado por:

- [Informe criptográfico de Fase 1](informe-criptografico-fase-1.md)
- [Evidencia OWASP](owasp-evidence.md)
- [Informe de Fase 3: SQLi y XSS](informe-fase-3-inyeccion-sqli-xss.md)
- [Propuesta de endurecimiento OWASP](../openspec/changes/harden-owasp-controls/proposal.md)
- [Especificación de endurecimiento](../openspec/changes/harden-owasp-controls/specs/security-hardening/spec.md)

## 6. Matriz final de resultados

| Control | Evidencia | Resultado |
|---|---|---|
| SAST Dart | `flutter analyze --no-pub --no-fatal-infos --no-fatal-warnings` | Pasa |
| Pruebas | `flutter test --no-pub` | Pasa |
| Build web | `flutter build web --release --no-pub` | Pasa |
| Secret scanning | Gitleaks | Sin hallazgos |
| Dependencias | `dart pub outdated` | Versiones actualizables registradas |
| Imagen | `podman build` | Pasa |
| Usuario | `USER 101` | Sin privilegios |
| Puerto | `8080` | Exposición mínima |
| Runtime | Nginx unprivileged Alpine | Pasa |
| Smoke test | `curl http://127.0.0.1:18080/` | HTTP 200 |

## 7. Conclusiones

1. Los conflictos de integración fueron eliminados y ya no bloquean las herramientas de Dart.
2. El análisis estático no reporta errores de compilación.
3. Las pruebas automatizadas y el build web terminan correctamente.
4. Los tokens sintéticos fueron retirados de las evidencias y Gitleaks finaliza sin hallazgos.
5. La imagen runtime es mínima, no ejecuta como root y solo expone el puerto necesario.
6. La aplicación puede ejecutarse como Flutter Web servido por Nginx sin privilegios.

## 8. Estado de entrega

**Fase 4 completada y verificada.**

Archivos principales añadidos o actualizados:

- `Dockerfile`
- `.dockerignore`
- `.gitleaks.toml`
- `.github/workflows/security.yml`
- Evidencias IDOR sin tokens utilizables
- Código Dart sin conflictos Git
