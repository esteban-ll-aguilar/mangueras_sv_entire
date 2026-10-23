# Evidencia OWASP — Mangueras SV

Evidencia ejecutada en `http://127.0.0.1:45535/` usando Brave, el 22-10-2026.

- [owasp-evidence.md](owasp-evidence.md): matriz y resultado de las pruebas.
- [A01-brave-admin-panel.png](A01-brave-admin-panel.png): sesión admin autenticada y panel visible.
- [A01-client-admin-route.png](A01-client-admin-route.png): cliente autenticado intentando `/admin-orders`; la app vuelve a `/home` y conserva rol Cliente.
- [A01-client-dashboard.png](A01-client-dashboard.png): dashboard de cliente autenticado.
- [A10-brave-login-error.png](A10-brave-login-error.png): error de login visible sin exponer detalles internos.
- [owasp-active-evidence.html](owasp-active-evidence.html): evidencia visual específica para A02–A09, con prueba y resultado.
- [owasp-remediated.html](owasp-remediated.html): resumen de correcciones A01–A10; no contiene capturas nuevas.
- [A02-A09-brave-evidence.png](A02-A09-brave-evidence.png): captura Brave de A02–A07.
- [A06-A09-brave-evidence.png](A06-A09-brave-evidence.png): captura Brave de A06–A09.

La captura `A01-brave-admin-panel.png` se dejó visible en Brave al finalizar.
