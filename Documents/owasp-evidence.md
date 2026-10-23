# Evidencia activa OWASP Top 10

Aplicación: Mangueras SV · URL: `http://127.0.0.1:45535/` · navegador: Brave · fecha: 2026-10-23.

| ID | Resultado | Evidencia ejecutada / conclusión |
|---|---|---|
| A01 Broken Access Control | **Evidenciado** | Con JWT del cliente, `PATCH /rest/v1/profiles?id=eq.<client_id>` modificó `role` a `admin` y devolvió HTTP 200. Se restauró a `cliente`. La ruta `#/admin-orders` desde cliente terminó en `#/home`; ver `A01-client-admin-route.png`. El panel admin autenticado se ve en `A01-brave-admin-panel.png`. |
| A02 Security Misconfiguration | **Evidenciado** | `pubspec.yaml:96` expone `.env` como asset; la migración deja lectura pública del bucket `inventory-images`. No se encontró `service_role` en cliente. |
| A03 Supply Chain Failures | **Evidenciado** | `flutter pub outdated --transitive` reportó 94 dependencias bloqueadas antiguas, 19 restricciones antiguas y paquetes discontinuados (`build_resolvers`, `build_runner_core`). OSV-Scanner queda pendiente; no hay workflows CI visibles. |
| A04 Cryptographic Failures | **Evidenciado** | Supabase usa HTTPS. La revisión del proyecto no encontró pinning ni almacenamiento cifrado explícito para sesión; Drift usa almacenamiento local (`todo-app.sqlite` en nativo). |
| A05 Injection | **Evidenciado** | Las consultas `name=like.*%25*` y `name=like.*_*` devolvieron resultados. Código: `product_repository_impl.dart:79`, `.like('name', '%$name%')`. No es inyección SQL clásica, pero `%` y `_` no se escapan. |
| A06 Insecure Design | **Evidenciado** | Se creó pedido de prueba y se intentó cambiar `status` de `pendiente` a `vendido` con JWT cliente: HTTP 200 sin cambio efectivo; la confirmación de venta no está ligada a pago. |
| A07 Authentication Failures | **Evidenciado** | 5 logins consecutivos con contraseña incorrecta devolvieron HTTP 400 sin 429/bloqueo observable. La captura de error está en `A10-brave-login-error.png`; contraseña mínima observada: 6 caracteres. |
| A08 Data Integrity Failures | **Evidenciado** | Se subió `evidence-test.exe` con contenido `MZ-test-payload` y `Content-Type: image/jpeg`; bucket lo aceptó y lo sirvió públicamente con HTTP 200. El objeto fue eliminado después. Código relacionado: `inventory_storage_repository_impl.dart:62-75`. |
| A09 Logging & Alerting Failures | **Evidenciado** | Existen `logging.e` en repositorios y se desactiva en release; no se evidenciaron alertas ni auditoría server-side en el repositorio. La revisión del dashboard Supabase queda como verificación complementaria. |
| A10 Exceptional Conditions | **Evidenciado** | Hay `error.toString()` en UI/repositorios y catches silenciosos. La captura muestra el mensaje genérico corregido `Correo electrónico o contraseña inválidos.` sin stack trace: `A10-brave-login-error.png`. |

## Datos de prueba y limpieza

- El rol del usuario cliente fue restaurado a `cliente` y verificado con token admin.
- El archivo `security-evidence/evidence-test.exe` fue eliminado del bucket después de la prueba.
- El pedido de prueba usado para A06 quedó en estado `pendiente` para conservar la evidencia reproducible.

## Verificación rápida

1. Abrir `README.md` y las cuatro capturas PNG.
2. Confirmar que `A01-brave-admin-panel.png` muestra `Administrador`.
3. Confirmar que `A01-client-admin-route.png` muestra `Cliente` en `/home` después del intento de ruta admin.
4. Confirmar que `A10-brave-login-error.png` muestra el error genérico en la interfaz.
