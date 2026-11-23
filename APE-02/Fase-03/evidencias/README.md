# Evidencias — Fase 3

Las pruebas reproducibles y el ciclo completo de mitigación están en el [informe principal](../../../Documents/informe-fase-3-inyeccion-sqli-xss.md).

## Resultado verificable

- `admin@gmail.com`: rol administrador; puede consultar perfiles y realizar la operación autorizada.
- `cliente@gmail.com`: rol cliente; solo ve sus datos y no puede vender pedidos.
- Payload SQLi: rechazado por validación de UUID (`22P02`, HTTP 400).
- Payload XSS: mostrado como texto por Flutter, sin ejecución.

No se inventaron capturas de DVWA. Si el docente exige imágenes de la guía, deben agregarse aquí como capturas tomadas durante el laboratorio; el informe deja separado ese laboratorio de las pruebas reales contra Supabase.
