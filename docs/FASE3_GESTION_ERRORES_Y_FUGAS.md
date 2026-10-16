# Fase 3 — Gestión de errores y fugas de información
**Proyecto:** Mangueras SV (Flutter + Supabase) — Semana 3, del 12 al 16 de octubre de 2026
**Sesión 1:** jueves 15 de octubre, 09h30–11h30 · **Sesión 2:** viernes 16 de octubre, 07h30–09h30
**Pareja:** [Nombres] · **Repo:** `mangueras_sv_entire` · **Rama:** `fase3/error-handling`

## 1. Objetivo
Detectar por provocación controlada qué información sensible expone la app en sus errores, clasificarla y corregirla con mensajes genéricos al usuario + log detallado interno, sin modo debug en producción.

## 2. Marco conceptual (20 min, Sesión 1)
Un mensaje de error es fuga cuando revela: traza de pila, versión de librería/servidor, ruta de archivo o bucket, nombre de tabla/vista/columna, consulta SQL/PostgREST, o permite enumerar usuarios. Esa información sirve para afinar inyección, fuerza bruta, escalada y acceso a storage. Buena práctica OWASP (MASVS-V7, ASVS 7.4): mensaje genérico en UI, detalle solo en log de servidor, `kReleaseMode` sin debug ni `print`.

## 3. Laboratorio — 5 errores provocados (Sesión 1, 80 min)

> Cómo reproducir: `flutter run` + Supabase proyecto dev. Evidencias: capturas en `docs/evidencias/fase3/` (E1–E5.png) y referencia archivo:línea.

| # | Caso exigido | Prueba realizada | Resultado observado (mensaje real) | Fuga detectada |
|---|--------------|------------------|-------------------------------------|----------------|
| E1 | Credenciales inválidas | Login con `noexiste@test.com / 123456` y con clave errónea | SnackBar muestra texto crudo de Supabase Auth en inglés: `Invalid login credentials` / `Email not confirmed` (fallback `return message` en `authProvider.dart:137`) | **Media.** Confirma validez de cuenta, expone proveedor (Supabase Auth) e idioma técnico. `loginPage.dart:64-70` pinta `next.message` tal cual |
| E2 | Parámetros alterados | Buscar producto con nombre `%' OR '1'='1` y `code=XXX-999` inexistente | Sin crash, pero en falla de provider se pinta `_ErrorState(error: error.toString())` en `shop_products_grid.dart:87` y `_ErrorCard(error.toString())` en `shop_filters_sidebar.dart:316,438` | **Alta.** `error.toString()` de Riverpod/PostgREST puede mostrar vista `products_view_flat`, operador `ilike`, y traza Dart. Query vulnerable en `product_repository_impl.dart:79` (`.like('name','%$name%')` sin escape) |
| E3 | Recurso inexistente | Abrir producto `code=NO-EXISTE`, pedido `id` aleatorio, perfil sin sesión | `shop_cart_page.dart:95` pinta `Error: $error`; repos hacen `.single()` (`product_repository_impl.dart:65`, `order_repository_impl.dart:16,39,50`) y solo hacen `logging.e('...: $e')` retornando `null/[]` sin mensaje UI | **Media.** `Error: $error` expone `PostgrestException(code: PGRST116, ... table "products_view_flat")`. El `null` silencioso confunde (pantalla vacía = fallo silencioso) |
| E4 | Formulario incompleto | Login vacío, signup `a@b` + clave `123`, recuperar con `""` y `"texto"` | Local: `Por favor, ingresa...` OK. Pero saltando validación cliente, Supabase devuelve `password should be at least 6 characters`, `Unable to validate email address` que sí llega a UI vía `AuthStateError` (`forgotPasswordPage.dart:67-75`, `signUpPage.dart:87-93`) | **Baja.** No hay fuga de stack, pero inconsistencia ES/EN y validación solo cliente (`signUpPage.dart:24-60` valida, `loginPage.dart:28` y `forgotPasswordPage.dart:31` no validan formato) |
| E5 | Subida de archivo fallida | Crear producto con imagen `.exe` renombrado a `.jpg` y con bucket sin permiso / sin red | `StorageException('Failed to upload profile image: $e')` (`inventory_storage_repository_impl.dart:32,45,58`) sube hasta UI como `Pedido solo por WhatsApp ($e)` (`shop_cart_page.dart:156`) y `Error: $e` (`:236`) | **Alta.** Expone bucket `inventory-images`, ruta `productImages/{id}.ext`, `StorageException`, mensaje storage en inglés. `_getMimeType` (`:62-76`) acepta cualquier extensión como `image/jpeg`, sin validar peso/tipo real |

Evidencias:
- `docs/evidencias/fase3/E1-login-invalido.png` — SnackBar `Invalid login credentials`
- `E2-parametro-alterado.png` — `_ErrorState(Error: ...products_view_flat...)`
- `E3-recurso-inexistente.png` — `Error: PostgrestException PGRST116`
- `E4-form-incompleto.png` — validación local vs mensaje EN de Supabase
- `E5-upload-fallido.png` — `StorageException: Failed to upload...`

## 4. Clasificación y corrección (Sesión 2, 85 min)

Criterio: **Alta** = revela infraestructura/datos o ayuda a explotar; **Media** = enumera usuarios o confunde; **Baja** = cosmético/inconsistente.

| ID | Severidad | Antes (fuga) | Después (corregido) | Cambio en código |
|----|-----------|--------------|----------------------|------------------|
| E1 | Media | `Invalid login credentials` | `Credenciales inválidas. Verifica tu correo y contraseña.` (mismo mensaje exista o no el usuario, anti-enumeración) | `authProvider.dart:121-138` ampliar `_friendlyAuthError` + no retornar `message` crudo; `loginPage.dart` mantiene genérico |
| E2 | Alta | `error.toString()` con vista y query | `No se pudieron cargar los productos. Intenta de nuevo.` + `logging.e('[E2] filtros: $e')` solo en log | `shop_products_grid.dart:87`, `shop_filters_sidebar.dart:316,438`: sustituir `Text(error.toString())` por widget genérico; escapar `%/_` en `product_repository_impl.dart:79` |
| E3 | Media | `Error: PostgrestException PGRST116 ...` | `El recurso solicitado no existe o no tienes acceso.` + retorno `null` controlado con empty-state | `shop_cart_page.dart:95`: quitar `Error: $error`; `order_repository_impl.dart`, `product_repository_impl.dart`: mapear `PGRST116` a `NotFound`, log con `logging.e` (ya desactivado en release en `dependencies_inyection.dart:15-18`) |
| E4 | Baja | Mensaje EN crudo de Supabase | Validación unificada ES en cliente + genérico servidor: `Revisa los datos ingresados.` | Extraer `_isValidEmail` a helper común y usarlo en login/signup/forgot; `forgotPasswordPage.dart:48-50` no prometer envío si hubo error |
| E5 | Alta | `StorageException: Failed to upload... bucket/inventory-images...` | `No se pudo subir la imagen. Usa JPG/PNG menor a 5 MB.` + log interno con detalle | `inventory_storage_repository_impl.dart:32,45,58`: no interpolar `$e` al usuario, lanzar `StorageException('UPLOAD_FAILED')` y mapear en UI; validar extensión real + peso antes de `uploadBinary`; `shop_cart_page.dart:156,236`: quitar `($e)` / `Error: $e` |

Buenas prácticas aplicadas:
- UI genérica ES, detalle solo en `logging.e` (nivel `Level.nothing` en `kReleaseMode`, `dependencies_inyection.dart:15`).
- Cero `print`/`error.toString()` en widgets de cara al usuario; se dejan `print` residuales solo en `example/` fuera de producción (a eliminar).
- Sin modo debug en prod: `debugShowCheckedModeBanner: false` (`main.dart:40`), sin `FlutterError` verboso.

## 5. Informe de la fase (Sesión 2, 20 min)
- **Hallazgo principal:** las fugas no estaban en el login (ya tenía `_friendlyAuthError` parcial) sino en los `Text(error)` / `Text('...$e')` de tienda/carrito y en el `StorageException: $e`. Eran las líneas que exponían bucket, vista y query.
- **Estado:** CORREGIDO EN CÓDIGO (verificado con `flutter analyze`, 0 errores; solo infos preexistentes). Cambios:
  - E1: `authProvider.dart` — `_friendlyAuthError` ya no retorna `message` crudo; mensaje único anti-enumeración + `signOut/sendResetPassword/updateUser/createUser` mapeados.
  - E2/E3: `shop_products_grid.dart`, `shop_filters_sidebar.dart`, `shop_cart_page.dart` — eliminados `error.toString()` / `Error: $error` / `($e)`; widgets genéricos ES.
  - E2-query: `product_repository_impl.dart` — `_escapeLike()` para `%/_/\` en `like` y filtro `or/ilike`.
  - E4: `loginPage.dart` + `forgotPasswordPage.dart` — validación `_isValidEmail` unificada ES (`Revisa los datos ingresados.`).
  - E5: `inventory_storage_repository_impl.dart` — códigos `UNSUPPORTED_TYPE/FILE_TOO_LARGE/UPLOAD_FAILED` (detalle solo en `logging.e`, apagado en release); validación extensión JPG/PNG/WEBP + tope 5 MB; formularios create/edit mapean a mensaje ES sin `$e`.
- **Riesgo residual:** bajo en fuga de mensajes. Queda pendiente Fase 2: RLS `is_admin()` en producto/storage (el mensaje ya no filtra, pero la API aún confía en UI).
- **Carga de evidencias:** este MD + `docs/evidencias/fase3/E1–E5.png` (antes) y `E1F–E5F.png` (después) en el repo.

*Checklist docente:* 5 errores provocados ✓ · capturas ✓ · tabla antes/después ✓ · corrección en componente (especificada archivo:línea) ✓ · sin debug en prod ✓.
