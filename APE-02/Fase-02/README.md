# Fase 2 — JWT e IDOR

**Semana 6:** 9–13 de noviembre de 2026

## Objetivo

Comprobar la separación de usuarios, la autorización por objeto y la imposibilidad de elevar el rol mediante modificaciones directas a la API.

> Estas evidencias son simulaciones locales controladas. Los tokens están redactados y no permiten autenticación.

## Evidencia JWT

Payload decodificado de laboratorio:

```json
{
  "iss": "https://demo.local/auth/v1",
  "sub": "11111111-1111-4111-8111-111111111111",
  "email": "usuario.a@lab.local",
  "role": "authenticated",
  "aud": "authenticated",
  "iat": 1794576912,
  "exp": 1794580512
}
```

Controles comprobados: `iss` identifica al emisor, `sub` identifica al usuario, `aud` corresponde a usuarios autenticados y `exp` limita la vigencia. El rol del JWT no reemplaza la autorización por fila ni debe aceptarse sin verificar firma y emisor.

## Evidencia IDOR 1 — lectura horizontal

Petición como Usuario A intentando leer a Usuario B:

```http
GET /rest/v1/profiles?id=eq.22222222-2222-4222-8222-222222222222&select=id,email,role
Authorization: Bearer <REDACTED_LAB_TOKEN>
```

Respuesta:

```http
HTTP/2 200 OK
[]
```

Resultado: RLS filtró la fila ajena; no se entregaron datos de Usuario B.

## Evidencia IDOR 2 — modificación de perfil ajeno

```http
PATCH /rest/v1/profiles?id=eq.22222222-2222-4222-8222-222222222222
Authorization: Bearer <REDACTED_LAB_TOKEN>
Content-Type: application/json

{"full_name":"IDOR_TEST"}
```

Respuesta:

```http
HTTP/2 403 Forbidden
{"code":"42501","message":"new row violates row-level security policy"}
```

Verificación posterior:

```text
full_name antes: Usuario B
full_name después: Usuario B
```

Resultado: el perfil ajeno no fue modificado.

## Evidencia IDOR 3 — elevación de privilegios

```http
PATCH /rest/v1/profiles?id=eq.11111111-1111-4111-8111-111111111111
Authorization: Bearer <REDACTED_LAB_TOKEN>
Content-Type: application/json

{"role":"admin"}
```

Respuesta:

```http
HTTP/2 403 Forbidden
{"code":"42501","message":"new row violates row-level security policy"}
```

Verificación posterior:

```text
role antes: cliente
role después: cliente
```

Resultado: un usuario común no puede convertirse en administrador.

## Mitigación de referencia

```sql
alter table public.profiles enable row level security;

create policy "Users view own profile"
on public.profiles for select to authenticated
using (auth.uid() = id or public.is_admin());

create policy "Admin update profiles"
on public.profiles for update to authenticated
using (public.is_admin())
with check (public.is_admin());
```

Además, el servidor debe ignorar identificadores de usuario enviados por el cliente cuando pueda obtener `auth.uid()` del JWT verificado. Las operaciones administrativas deben validar rol, emisor, audiencia, expiración y firma.

## Resultado final

| Control | Resultado |
|---|---|
| Lectura de objeto ajeno | Bloqueada por RLS |
| Modificación de objeto ajeno | HTTP 403, sin cambio |
| Elevación de rol | HTTP 403, sin cambio |
| Token publicado | Redactado, no funcional |

Evidencias originales: [índice de laboratorio](../../evidencias_idor_simuladas/README_EVIDENCIAS.md).
