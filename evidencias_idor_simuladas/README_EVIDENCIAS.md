# Evidencias simuladas: JWT e IDOR

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
