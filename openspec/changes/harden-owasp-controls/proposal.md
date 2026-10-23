# Proposal: Hardening OWASP A01-A10

## Why

La auditoría del entorno local evidenció controles débiles de autorización, configuración, subida de archivos, búsqueda, autenticación, errores y observabilidad. Se requiere corregir el comportamiento en cliente, RLS/migraciones y documentación técnica.

## What changes

- Restringir el cambio de roles a servidor y endurecer el trigger de alta.
- Quitar `.env` de los assets web y documentar el uso de variables de build.
- Validar extensiones/MIME y evitar publicación pública de archivos subidos.
- Escapar comodines de búsquedas y validar datos sincronizados.
- Añadir políticas de autenticación, longitud mínima y mensajes de error seguros.
- Centralizar manejo de excepciones/logging sin filtrar detalles a UI.
- Añadir revisión de dependencias y configuración de CI.
- Crear `Documents/owasp-remediated.html` con el antes/después de A01-A10.

## Out of scope

- Rotación de credenciales Supabase existentes.
- Pinning nativo específico por plataforma sin una decisión de producto.
- Capturas nuevas; el HTML será el entregable de verificación.

## Success criteria

- `flutter analyze` y `flutter test` pasan.
- No se puede actualizar `profiles.role` con JWT de cliente.
- Archivos no-imagen y acceso público al bucket son rechazados.
- La búsqueda trata `%` y `_` como texto literal.
- La UI muestra mensajes seguros y los detalles quedan solo en logs de desarrollo.
- El HTML documenta los diez controles y sus verificaciones.
