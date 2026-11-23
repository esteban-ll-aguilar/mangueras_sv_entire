# Evidencias — Fase 3

Las pruebas reproducibles y el ciclo completo de mitigación están en el [informe principal](../../../Documents/informe-fase-3-inyeccion-sqli-xss.md).

## Resultado verificable

- `admin@gmail.com`: rol administrador; puede consultar perfiles y realizar la operación autorizada.
- `cliente@gmail.com`: rol cliente; solo ve sus datos y no puede vender pedidos.
- Payload SQLi: rechazado por validación de UUID (`22P02`, HTTP 400).
- Payload XSS: mostrado como texto por Flutter, sin ejecución.

La evidencia textual completa quedó integrada directamente en el [README de Fase 3](../README.md), incluyendo payloads, respuestas observadas, mitigaciones y repruebas. El laboratorio DVWA y la aplicación real de Supabase se mantienen separados para no presentar resultados de un entorno como si fueran del otro.
