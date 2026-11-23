# APE-02 — Auditoría técnica y endurecimiento de la aplicación

**Asignatura:** Software Security  
**Unidad:** 1  · **Práctica:** 2 (Fases 1 a 4)  
**Integrantes:** Christian Leonardo Robles Maza · Esteban Leon Aguilar · Marilyn Lisseth Alvarado  
**Ciclo:** 8 A  · **Docente:** Valeria Herrera Salazar  
**Periodo:** 26 de octubre al 27 de noviembre de 2026  
**Sesiones:** jueves 09h30–11h30 y viernes 07h30–09h30  
**Modalidad:** Aula de clase  · **Duración:** 16 horas

## Objetivo

Auditar la aplicación, demostrar vulnerabilidades de forma controlada, aplicar mitigaciones y verificar el resultado mediante pruebas reproducibles, SAST y endurecimiento de contenedores.

## Fases del entregable

| Fase | Tema | Evidencia |
|---|---|---|
| [Fase 1](Fase-01/README.md) | Criptografía y hashes | Informe y resultados reproducibles |
| [Fase 2](Fase-02/README.md) | JWT e IDOR | Escenarios controlados con tokens redactados |
| [Fase 3](Fase-03/README.md) | SQLi y XSS | Hallazgo → mitigación → verificación en Supabase |
| [Fase 4](Fase-04/README.md) | SAST y Docker | Análisis estático, imagen endurecida y Trivy |

## Checklist de entrega

- [x] README raíz enlaza APE-01 y APE-02.
- [x] Cada fase tiene README, alcance, procedimiento y resultado.
- [x] Las pruebas reales contra Supabase se distinguen del laboratorio DVWA.
- [x] No se publican contraseñas ni JWT funcionales; los tokens de laboratorio están redactados.
- [x] La aplicación compila, ejecuta sus pruebas y genera la build web.
- [x] El contenedor usa imagen mínima, usuario sin privilegios y exposición mínima.

## Informes completos

- [Informe Fase 3](../Documents/informe-fase-3-inyeccion-sqli-xss.md)
- [Informe Fase 4](../Documents/informe-fase-4-sast-docker.md)
