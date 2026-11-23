# Fase 2 — JWT e IDOR

**Fechas:** 9–13 de noviembre de 2026  
**Objetivo:** comprobar autorización por objeto, separación de roles y validación de claims JWT en escenarios controlados.

## Evidencias

- [Escenario 1 — lectura IDOR](../../evidencias_idor_simuladas/escenario_1_idor_lectura.txt)
- [Escenario 2 — modificación IDOR](../../evidencias_idor_simuladas/escenario_2_idor_modificacion.txt)
- [Escenario 3 — elevación de rol](../../evidencias_idor_simuladas/escenario_3_elevacion_rol.txt)
- [Payload JWT de laboratorio](../../evidencias_idor_simuladas/jwt_payload.json)
- [Índice de evidencias](../../evidencias_idor_simuladas/README_EVIDENCIAS.md)

Los tokens publicados están redactados y no permiten autenticación. Los escenarios son material de laboratorio, no capturas de una cuenta real.

## Resultado

La mitigación se basa en no confiar en un `user_id` enviado por el cliente, verificar el JWT en el servidor y aplicar autorización por fila/objeto mediante Supabase RLS y comprobaciones de rol.
