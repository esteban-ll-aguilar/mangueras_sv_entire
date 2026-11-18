#!/usr/bin/env python3
"""Laboratorio local simulado para evidencias JWT + IDOR. No usa red ni BD."""
import base64, hashlib, hmac, json, os, time
from pathlib import Path

OUT = Path("evidencias_idor_simuladas")
OUT.mkdir(exist_ok=True)

def b64(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).rstrip(b"=").decode()

def make_jwt(payload: dict, secret: str) -> str:
    header = {"alg": "HS256", "typ": "JWT"}
    a = b64(json.dumps(header, separators=(",", ":")).encode())
    p = b64(json.dumps(payload, separators=(",", ":")).encode())
    sig = hmac.new(secret.encode(), f"{a}.{p}".encode(), hashlib.sha256).digest()
    return f"{a}.{p}.{b64(sig)}"

def write(name: str, content: str):
    (OUT / name).write_text(content, encoding="utf-8")

now = int(time.time())
user_a = "11111111-1111-4111-8111-111111111111"
user_b = "22222222-2222-4222-8222-222222222222"
secret = "LABORATORIO-SECRETO-NO-USAR-EN-PRODUCCION"
payload = {
    "iss": "https://demo.local/auth/v1",
    "sub": user_a,
    "email": "usuario.a@lab.local",
    "role": "authenticated",
    "aud": "authenticated",
    "iat": now,
    "exp": now + 3600,
}
token = make_jwt(payload, secret)
write("token_usuario_A.txt", token + "\n")
write("jwt_payload.json", json.dumps(payload, indent=2) + "\n")

esc1 = f"""LABORATORIO SIMULADO - ESCENARIO 1: IDOR HORIZONTAL\n\nPetición:\nGET /rest/v1/profiles?id=eq.{user_b}&select=id,email,role\nAuthorization: Bearer <TOKEN_USUARIO_A>\n\nRespuesta simulada:\nHTTP/2 200 OK\n[]\n\nInterpretación: Usuario A no puede consultar el perfil de Usuario B.\nLa fila fue filtrada por RLS; no se entregaron datos ajenos.\n"""
write("escenario_1_idor_lectura.txt", esc1)

esc2 = f"""LABORATORIO SIMULADO - ESCENARIO 2: IDOR EN MODIFICACIÓN\n\nPetición:\nPATCH /rest/v1/profiles?id=eq.{user_b}\nAuthorization: Bearer <TOKEN_USUARIO_A>\nBody: {{\"full_name\":\"IDOR_TEST\"}}\n\nRespuesta simulada:\nHTTP/2 403 Forbidden\n{{\"code\":\"42501\",\"message\":\"new row violates row-level security policy\"}}\n\nVerificación posterior:\nfull_name antes: Usuario B\nfull_name después: Usuario B\n\nInterpretación: el perfil ajeno no fue modificado.\n"""
write("escenario_2_idor_modificacion.txt", esc2)

esc3 = f"""LABORATORIO SIMULADO - ESCENARIO 3: ELEVACIÓN DE PRIVILEGIOS\n\nPetición:\nPATCH /rest/v1/profiles?id=eq.{user_a}\nAuthorization: Bearer <TOKEN_USUARIO_A>\nBody: {{\"role\":\"admin\"}}\n\nRespuesta simulada:\nHTTP/2 403 Forbidden\n{{\"code\":\"42501\",\"message\":\"new row violates row-level security policy\"}}\n\nVerificación posterior:\nrole antes: cliente\nrole después: cliente\n\nInterpretación: un usuario común no puede convertirse en administrador.\n"""
write("escenario_3_elevacion_rol.txt", esc3)

summary = f"""# Evidencias simuladas: JWT e IDOR

> **Aviso:** todas las respuestas de este directorio son simuladas localmente.
> No representan una conexión real a Supabase ni deben presentarse como tráfico real.

## JWT

- Archivo: `token_usuario_A.txt`
- Decodificación: `jwt_payload.json`
- Algoritmo: `HS256`
- Rol: `authenticated`
- Expiración: una hora después de la emisión

## IDOR

1. Lectura horizontal: `escenario_1_idor_lectura.txt`
2. Modificación ajena: `escenario_2_idor_modificacion.txt`
3. Elevación de rol: `escenario_3_elevacion_rol.txt`

## Corrección de servidor propuesta

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
"""
write("README_EVIDENCIAS.md", summary)
print(f"Evidencias creadas en: {OUT.resolve()}")
print(f"Token simulado: {(OUT / 'token_usuario_A.txt').resolve()}")
print("Nota: esto es una simulación local sin red, Supabase ni base de datos.")
