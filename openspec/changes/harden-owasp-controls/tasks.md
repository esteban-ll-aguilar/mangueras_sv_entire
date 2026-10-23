# Tasks

## Layer 0 — Baseline

- [x] Revisar contratos actuales, migraciones y estado de git.
- [x] Crear work log y registrar decisiones.

## Layer 1 — Supabase / A01-A02-A06-A08

- [x] Endurecer trigger y políticas de `profiles` y `orders`.
- [x] Hacer privado `inventory-images` y limitar operaciones.
- [x] Añadir función segura para promoción admin y venta.

## Layer 2 — Flutter / A04-A05-A07-A08-A10

- [x] Quitar `.env` de assets y validar configuración.
- [x] Escapar búsquedas y validar MIME/extensión.
- [x] Endurecer contraseña y mensajes de errores.
- [x] Añadir validación de sincronización local y manejo seguro de excepciones.

## Layer 3 — Supply chain / A03-A09

- [x] Añadir auditoría de dependencias y CI básico.
- [x] Definir logging de release sin datos sensibles.

## Layer 4 — Documentación y verificación

- [x] Crear HTML de remediación A01-A10 sin capturas.
- [x] Ejecutar análisis y pruebas.

## Parallelization plan

- Las capas 1, 2 y 3 pueden prepararse en paralelo por archivo, pero la verificación final es secuencial.
