# Informe criptográfico — Fase 1

**Proyecto:** Mangueras SV  
**Semana:** 5 — del 26 al 30 de octubre de 2026  
**Fecha de verificación:** 29 de octubre de 2026  
**Alcance:** almacenamiento de credenciales, hashing, salting, secretos y cifrado en tránsito

## 1. Resumen ejecutivo

La aplicación no implementa un almacenamiento propio de contraseñas. El inicio de sesión y el registro utilizan Supabase Auth mediante `signInWithPassword` y `signUp`; la tabla `public.profiles` solo almacena el identificador, correo, nombre, rol y fecha de creación.

No se encontraron usos de MD5, SHA-1 ni hashes manuales en el código de la aplicación o en las migraciones revisadas. La configuración utiliza `SUPABASE_URL` y `SUPABASE_ANON_KEY` mediante `.env` local o `--dart-define`; `.env` está excluido del repositorio.

La conexión remota utiliza HTTPS. La verificación de cabeceras obtuvo HTTP/2, `Strict-Transport-Security` y `X-Content-Type-Options: nosniff`. La aplicación también fue levantada localmente con TLS mediante un certificado de laboratorio y respondió correctamente por `https://127.0.0.1:45535/`.

## 2. Evidencia de almacenamiento de credenciales

### 2.1 Flujo identificado

Archivo revisado: `lib/app/modules/auth/infrastructure/providers/authProvider.dart`.

- El acceso usa `supabase.auth.signInWithPassword`.
- El registro usa `supabase.auth.signUp`.
- La aplicación no genera ni compara hashes de contraseña.
- La aplicación no inserta contraseñas en `public.profiles`.

Archivo revisado: `supabase/migrations/20261002_roles_orders.sql`.

La tabla `public.profiles` se define con los siguientes campos relevantes:

```sql
id uuid references auth.users (id)
email text
full_name text
role text
created_at timestamptz
```

No existe una columna `password`, `password_hash` o `salt` en esta tabla.

### 2.2 Resultado

| Control | Resultado | Clasificación |
|---|---|---|
| Contraseñas fuera de `public.profiles` | Cumple | Bajo riesgo |
| Hashing propio en la aplicación | No aplica; lo gestiona Supabase Auth | Requiere validación externa |
| Uso de MD5 o SHA-1 | No encontrado | Sin hallazgo |
| Salt visible en código propio | No aplica | Supabase Auth debe confirmarlo en su configuración |

La revisión del hash interno de `auth.users` no puede hacerse desde el repositorio ni con la clave pública de la aplicación. Debe verificarse desde el panel o la configuración administrativa de Supabase, sin exportar contraseñas ni hashes reales.

## 3. Comparación de hashes

Se utilizó una contraseña de laboratorio que no pertenece a ningún usuario real.

### 3.1 SHA-256 sin salt

Al calcular dos veces el mismo valor sin salt se obtuvo el mismo resultado:

```text
23a35968b31cea8906efcfa4be7093f8ce18c9a3482ad10ab6831589c4231e8c
23a35968b31cea8906efcfa4be7093f8ce18c9a3482ad10ab6831589c4231e8c
```

Esto demuestra que un hash rápido y determinista permite identificar contraseñas repetidas y resulta inadecuado para almacenamiento de credenciales.

### 3.2 SHA-256 con salts distintos

El mismo valor con dos salts diferentes produjo resultados distintos:

```text
a3d54e041149d581527dfb10158cbfbf4c8724de4f35ba430c8aa451a154d791
ddb7bd3cee2e7008a41fce2e39c1f8a2c2e87a2ac77ac44b8b66c1d38db12eef
```

El salt debe ser único por usuario y almacenarse junto al resultado; no es una contraseña ni un secreto.

### 3.3 Argon2id

También se verificó la generación de hashes Argon2id con parámetros de laboratorio:

```text
$argon2id$v=19$m=4096,t=2,p=1$ZmFzZTEtc2FsdC1h$q7Qf8tw+IOuRiWZCf4H/rKRtnjj5HaLu5Nh8RiJ6QJM
$argon2id$v=19$m=4096,t=2,p=1$ZmFzZTEtc2FsdC1i$q75DYDxX8tAlviIHQ4vbHhMmb3Kuanr9aqHZ0dEU27o
```

Los parámetros y el salt quedan incluidos en el formato del hash para permitir la verificación posterior. Para nuevas implementaciones, Argon2id es la opción recomendada; bcrypt es una alternativa compatible y ampliamente disponible.

## 4. Verificación del cifrado en tránsito

### 4.1 Configuración de la aplicación

Archivo revisado: `lib/main.dart`.

- La URL de Supabase se obtiene de `SUPABASE_URL`.
- La clave se obtiene de `SUPABASE_ANON_KEY`.
- La configuración no contiene una URL HTTP fija.
- La autenticación usa flujo PKCE.
- `.env` no está versionado; `.env.sample` solo contiene valores de ejemplo.

### 4.2 Prueba remota

Se consultó el endpoint REST configurado usando HTTPS. El servidor respondió `HTTP/2 401`, lo que confirma que el endpoint está disponible y que rechazó la solicitud sin API key, sin necesidad de exponer credenciales.

Cabeceras relevantes observadas:

```text
strict-transport-security: max-age=31536000; includeSubDomains; preload
x-content-type-options: nosniff
```

El estado `401` es esperado para una consulta sin autenticación. No representa un fallo de almacenamiento de credenciales.

### 4.3 Prueba local

La aplicación se levantó con el servidor web de Flutter y un certificado de laboratorio temporal. La solicitud GET a `https://127.0.0.1:45535/` devolvió `HTTP/1.1 200 OK`.

Cabeceras observadas:

```text
content-type: text/html; charset=utf-8
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
```

El certificado fue emitido para `127.0.0.1`, tuvo vigencia de un día y no se guardó en el repositorio. Para la prueba con certificado autofirmado se utilizó `curl -k`; en producción debe utilizarse un certificado confiable.

## 5. Búsqueda de secretos

Se revisaron archivos de configuración, código Dart y migraciones SQL en busca de contraseñas, claves API, tokens, cadenas de conexión y claves criptográficas.

Resultados:

- No se encontraron contraseñas fijas en `lib/` ni `supabase/`.
- No se encontraron MD5, SHA-1, bcrypt o Argon2 implementados manualmente en la aplicación.
- `.env` existe localmente, pero está excluido mediante `.gitignore`.
- `.env.sample` contiene solamente valores de ejemplo.
- `SUPABASE_ANON_KEY` es una clave pública de cliente y no debe confundirse con una service-role key.
- No debe incluirse nunca una clave `service_role`, contraseña de base de datos o secreto de servidor en la aplicación Flutter.

## 6. Hallazgos y riesgo preliminar

| ID | Hallazgo | Riesgo | Estado |
|---|---|---|---|
| CRY-01 | El almacenamiento interno de Supabase Auth no puede verificarse desde el repositorio | Medio | Pendiente de confirmar en Supabase |
| CRY-02 | La aplicación local se verificó por HTTPS con certificado de laboratorio | Bajo | Verificado |
| CRY-03 | `supabase_flutter` usa `SharedPreferences` para persistir la sesión nativa por defecto | Medio | Requiere almacenamiento seguro para producción |
| CRY-04 | No se encontraron secretos fijos ni algoritmos débiles en el código revisado | Bajo | Verificado |

## 7. Propuesta de mejora

1. Mantener las contraseñas exclusivamente en Supabase Auth y no crear columnas de contraseña en `public.profiles`.
2. Confirmar en la configuración administrativa de Supabase que el proveedor utiliza hashing adaptativo con salt único por usuario.
3. Si se migra a un backend propio, usar Argon2id como primera opción o bcrypt como alternativa; nunca MD5, SHA-1 ni SHA-256 simple.
4. Realizar una migración progresiva: validar la contraseña existente, generar el nuevo hash en el siguiente inicio de sesión y eliminar el formato anterior cuando todos los usuarios hayan migrado.
5. Mantener `SUPABASE_URL` y `SUPABASE_ANON_KEY` fuera del código fuente mediante `--dart-define` o un gestor de configuración por entorno.
6. Separar proyectos y credenciales de desarrollo, pruebas y producción.
7. Ejecutar un escáner de secretos en CI y rotar cualquier credencial que haya sido expuesta.
8. Verificar HTTPS, HSTS y cabeceras de seguridad con la aplicación local levantada antes de publicar.
9. Sustituir el almacenamiento nativo por defecto de la sesión por una implementación basada en Keychain/Keystore, o validar formalmente el riesgo de `SharedPreferences` antes de producción.

## 8. Comandos reproducibles

```bash
# Buscar algoritmos o credenciales en el código
rg -n -i '(md5|sha[-_ ]?1|bcrypt|argon2|password|secret|api[_-]?key|token)' lib supabase .env.sample

# Hash de laboratorio sin salt
printf '%s' 'contraseña-de-prueba' | sha256sum

# Hash Argon2id de laboratorio
printf '%s' 'contraseña-de-prueba' | argon2 'salt-de-prueba' -id -t 2 -m 12 -p 1 -e

# Revisar cabeceras HTTPS
curl -sSIL 'https://<proyecto>.supabase.co/rest/v1/'
```

## 9. Conclusión

La Fase 1 queda ejecutada sobre el código disponible y con las pruebas locales realizadas. El proyecto no almacena contraseñas en sus tablas propias ni usa algoritmos débiles; delega la autenticación en Supabase Auth y mantiene la configuración fuera del repositorio. La única evidencia que requiere permisos externos es la confirmación administrativa del algoritmo y salt utilizados internamente por Supabase Auth. Además, se identificó como mejora prioritaria reemplazar `SharedPreferences` por almacenamiento seguro para la sesión nativa.
