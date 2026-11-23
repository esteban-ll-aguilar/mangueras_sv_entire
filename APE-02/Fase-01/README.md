# Fase 1 — Criptografía y hashes

**Semana 5:** 26–30 de octubre de 2026
**Fecha de verificación:** 29 de octubre de 2026

## Objetivo

Verificar el almacenamiento de credenciales, el uso de hashes, la protección de secretos y el cifrado en tránsito de Mangueras SV.

## Evidencia del código

El login y registro usan Supabase Auth mediante `signInWithPassword` y `signUp`. La tabla `public.profiles` no guarda contraseñas:

```sql
id uuid references auth.users (id)
email text
full_name text
role text
created_at timestamptz
```

No se encontraron columnas `password`, `password_hash` o `salt`, ni implementaciones propias de MD5/SHA-1/bcrypt/Argon2 en `lib/` o `supabase/`.

## Evidencia de hashes de laboratorio

### SHA-256 sin salt

El mismo valor produce el mismo digest, lo cual permite reconocer contraseñas repetidas:

```text
23a35968b31cea8906efcfa4be7093f8ce18c9a3482ad10ab6831589c4231e8c
23a35968b31cea8906efcfa4be7093f8ce18c9a3482ad10ab6831589c4231e8c
```

### SHA-256 con salts distintos

```text
salt A → a3d54e041149d581527dfb10158cbfbf4c8724de4f35ba430c8aa451a154d791
salt B → ddb7bd3cee2e7008a41fce2e39c1f8a2c2e87a2ac77ac44b8b66c1d38db12eef
```

### Argon2id

```text
$argon2id$v=19$m=4096,t=2,p=1$ZmFzZTEtc2FsdC1h$q7Qf8tw+IOuRiWZCf4H/rKRtnjj5HaLu5Nh8RiJ6QJM
$argon2id$v=19$m=4096,t=2,p=1$ZmFzZTEtc2FsdC1i$q75DYDxX8tAlviIHQ4vbHhMmb3Kuanr9aqHZ0dEU27o
```

Los valores son de laboratorio y no corresponden a usuarios reales. Argon2id es preferible a hashes rápidos para una implementación propia.

## Evidencia de HTTPS

La consulta HTTPS al endpoint REST respondió `HTTP/2 401` sin API key, comportamiento esperado para una solicitud no autenticada. Las cabeceras observadas fueron:

```text
strict-transport-security: max-age=31536000; includeSubDomains; preload
x-content-type-options: nosniff
```

La aplicación local también respondió `HTTP/1.1 200 OK` sobre `https://127.0.0.1:45535/` con certificado de laboratorio.

## Evidencia de secretos

```bash
rg -n -i '(md5|sha[-_ ]?1|password|secret|api[_-]?key|token)' lib supabase .env.sample
```

Resultado de revisión: no se encontraron contraseñas fijas ni claves `service_role`. `.env` está excluido de Git y `.env.sample` contiene solo valores de ejemplo. `SUPABASE_ANON_KEY` es una clave pública de cliente y no equivale a un secreto administrativo.

## Hallazgos y acciones

| ID | Hallazgo | Estado |
|---|---|---|
| CRY-01 | Supabase Auth gestiona el hash interno fuera del repositorio | Confirmar en panel administrativo sin exportar hashes |
| CRY-02 | HTTPS y HSTS verificados | Cumple |
| CRY-03 | Sesión nativa usa almacenamiento por defecto | Evaluar Keychain/Keystore antes de producción |
| CRY-04 | No hay secretos fijos ni algoritmos débiles | Cumple |

## Conclusión

La aplicación no almacena contraseñas en sus tablas propias ni usa algoritmos débiles. La autenticación queda delegada a Supabase Auth, la configuración se mantiene fuera del repositorio y el transporte usa HTTPS.

Informe ampliado: [informe criptográfico](../../Documents/informe-criptografico-fase-1.md).
