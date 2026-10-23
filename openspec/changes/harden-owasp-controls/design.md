# Design

## Layers

1. Supabase: trigger, RLS, función `sell_order` y bucket privado.
2. Flutter data layer: validación de archivos, búsqueda y errores.
3. Flutter auth/UI: validación de contraseña y mensajes seguros.
4. Tooling/docs: auditoría de dependencias, CI y HTML de remediación.

## Decisions

- El rol se asigna siempre a `cliente` en el trigger; solo una operación SQL protegida por admin podrá promover usuarios.
- El bucket de imágenes será privado y las URLs se generarán mediante signed URLs.
- Se permitirá únicamente `jpg`, `jpeg`, `png` y `webp`, verificando MIME y extensión.
- Se usará escape de comodines PostgREST (`\\`, `%`, `_`) antes de `like`.
- Los mensajes mostrados a usuarios serán genéricos; se conserva logging estructurado para diagnóstico.

## Verification

- Tests unitarios para escape de búsqueda, validación MIME y mensajes.
- `flutter analyze`, `flutter test`.
- Validación textual de migración y `flutter pub outdated`.
