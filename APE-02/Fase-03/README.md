# Fase 3 — Ataques de inyección: SQLi y XSS

**Semana 7:** 16–20 de noviembre de 2026  
**Sesiones:** jueves 19 y viernes 20 de noviembre, 09h30–11h30 y 07h30–09h30.

## Hallazgo → mitigación → verificación

| Vector | Hallazgo controlado | Mitigación | Verificación |
|---|---|---|---|
| SQLi | El payload `'<espacio>` no se interpreta como SQL en la consulta de perfiles; Supabase devuelve error de UUID (`22P02`) y HTTP 400. | Cliente Supabase tipado, validación de UUID, consultas de API/RPC sin concatenar SQL y RLS. | Se repitió la prueba y no hubo acceso adicional ni bypass de autenticación. |
| XSS | El texto `<script>alert(1)</script>` se presenta como texto en Flutter; no se ejecuta como HTML. | Renderizado nativo de widgets, validación de entrada y no usar HTML sin sanitización. | Se repitió el payload y no apareció ejecución de JavaScript. |

## Alcance real

DVWA es un laboratorio educativo independiente. La aplicación auditada usa Flutter + Supabase, por lo que no se presentó una captura de DVWA como si fuera evidencia de Supabase. Las comprobaciones reales están documentadas en el [informe completo](../../Documents/informe-fase-3-inyeccion-sqli-xss.md).

## Evidencias

Consultar [evidencias de Fase 3](evidencias/README.md).

## Pregunta de control 3

La diferencia es que DVWA permite practicar deliberadamente sobre endpoints vulnerables conocidos, mientras que Supabase aplica una API tipada, autenticación y RLS. Por eso la evidencia debe corresponder al sistema realmente evaluado.
