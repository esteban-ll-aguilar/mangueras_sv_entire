# Fase 3 — Ataques de inyección: explotación controlada y mitigación de SQLi y XSS

**Semana 7:** 16–20 de noviembre de 2026  
**Sesión 1:** jueves 19 de noviembre, 09h30–11h30
**Sesión 2:** viernes 20 de noviembre, 07h30–09h30

## 1. Objetivo y alcance

Se revisaron las causas de SQL Injection (SQLi) y Cross-Site Scripting (XSS), se documentaron payloads de laboratorio y se comprobó el comportamiento real de la aplicación Flutter + Supabase.

Se diferencian correctamente los dos entornos:

- **DVWA:** laboratorio educativo deliberadamente vulnerable.
- **Aplicación propia:** Flutter + Supabase, evaluada con las cuentas de prueba del proyecto.

## 2. Actividad 1 — Causas técnicas

### SQLi vulnerable

```php
$id = $_REQUEST['id'];
$query = "SELECT first_name, last_name FROM users WHERE user_id = '$id';";
```

La entrada `1' OR '1'='1` cierra la cadena y agrega una condición siempre verdadera.

### SQLi mitigado

```php
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if ($id === false || $id === null) die('Parámetro inválido');
$stmt = $pdo->prepare(
    'SELECT first_name, last_name FROM users WHERE user_id = :id'
);
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$stmt->execute();
```

### XSS vulnerable y mitigado

Vulnerable:

```php
echo '<pre>Hello ' . $_GET['name'] . '</pre>';
```

Mitigado:

```php
$name = htmlspecialchars(
    $_GET['name'] ?? '', ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8'
);
echo '<pre>Hello ' . $name . '</pre>';
```

La aplicación Flutter usa widgets `Text`, no HTML interpretado; por eso una etiqueta `<script>` se trata como texto.

## 3. Actividad 2 — Explotación controlada en DVWA

### SQL Injection

| Evidencia | Payload | Resultado esperado en DVWA Low |
|---|---|---|
| DVWA-SQLI-01 | `'` | Error de sintaxis; confirma que la entrada llega a la consulta. |
| DVWA-SQLI-02 | `1' OR '1'='1` | Tautología; devuelve varios registros. |
| DVWA-SQLI-03 | `' OR '1'='1' #` | Tautología y comentario del resto. |
| DVWA-SQLI-04 | `1' UNION SELECT user, password FROM users #` | Lectura de columnas de laboratorio. |

### Bypass de autenticación

```text
usuario: admin' --
contraseña: cualquier valor
```

Este resultado solo aplica al código vulnerable de DVWA y no se atribuye a Supabase Auth.

### XSS reflejado

| Evidencia | Payload | Resultado esperado en DVWA Low |
|---|---|---|
| DVWA-XSS-01 | `<script>alert('XSS-lab')</script>` | Alerta JavaScript. |
| DVWA-XSS-02 | `<img src=x onerror=alert(document.domain)>` | Ejecución de `onerror`. |
| DVWA-XSS-03 | `<b>prueba</b>` | Interpretación HTML en negrita. |

Los payloads están limitados al laboratorio local y no se ejecutaron contra terceros.

## 4. Actividad 3 — Verificación real en Supabase

### Entorno y cuentas

| Elemento | Valor comprobado |
|---|---|
| Proyecto | `xrnnmcolputazgqfewpz` |
| Administrador | `admin@gmail.com` — rol `admin` |
| Cliente | `cliente@gmail.com` — rol `cliente` |
| API | Supabase Auth + PostgREST |
| Resultado de login | Correcto para ambas cuentas |

Las contraseñas y tokens no se publican. Los tokens se usaron únicamente en memoria.

### Evidencia de autorización

| Prueba | Administrador | Cliente |
|---|---|---|
| Consultar perfiles | Ve los dos perfiles | Ve únicamente su perfil |
| Consultar pedido propio | Permitido | Permitido |
| Ejecutar `sell_order` | Llega a validación de pedido | Rechazado por rol |

Pedido de prueba, sin modificarlo:

```text
id: f197f4c4-ba7a-445c-b8c4-0117d73c13ce
user_id: 0ee9a4ae-328b-4f35-b26a-63d040536877
status: pendiente
total: 0.00
```

### APP-SQLI-01 — tautología en filtro UUID

Petición ensayada para ambos usuarios:

```http
GET /rest/v1/orders?id=eq.1' OR '1'='1&select=*
```

Respuesta observada:

```text
HTTP 400
code: 22P02
message: invalid input syntax for type uuid: "1' OR '1'='1"
```

El valor fue tratado como UUID inválido; no se convirtió en una tautología ni devolvió todos los pedidos.

### APP-RLS-01 — RPC `sell_order`

UUID inexistente usado para no modificar datos:

```text
00000000-0000-0000-0000-000000000000
```

Respuesta como administrador:

```text
HTTP 400
Pedido no existe
```

Respuesta como cliente:

```text
HTTP 400
Solo admin puede vender
```

La operación valida el rol y no permite al cliente elevar privilegios.

### APP-XSS-01 — renderizado Flutter

Payload de prueba:

```html
<script>alert(1)</script>
```

Resultado: los valores se muestran con `Text` de Flutter y no se interpretan como HTML/JavaScript. No apareció ninguna alerta y no se realizó una escritura remota innecesaria.

## 5. Mitigación aplicada y verificación

| Vector | Hallazgo | Mitigación | Reprueba | Estado |
|---|---|---|---|---|
| SQLi en DVWA | Concatenación de `id` | Consultas parametrizadas; filtros tipados y UUID en Supabase | Payload `'` y tautología: HTTP 400/22P02 | Mitigado/verificado |
| XSS en DVWA | Salida reflejada sin escape | Escape contextual; Flutter usa `Text` | `<script>alert(1)</script>` no se ejecutó | Mitigado/verificado |
| Autorización | Cliente intenta operación administrativa | RLS y validación de rol en `sell_order` | `Solo admin puede vender` | Mitigado/verificado |

No se ejecutaron `DROP`, `DELETE` ni `UPDATE` destructivos. No se modificaron perfiles, pedidos, productos, inventario ni Storage.

## 6. Pregunta de control 3

DVWA es un laboratorio con vulnerabilidades intencionales para observar SQLi/XSS. Supabase no debe tratarse como DVWA: sus filtros PostgREST, tipos PostgreSQL, Auth y RLS procesan la entrada de otra forma. Por eso el informe separa la demostración didáctica de la comprobación real del proyecto.

## 7. Evidencia ampliada

El [informe detallado](../../Documents/informe-fase-3-inyeccion-sqli-xss.md) conserva el contexto académico y las comprobaciones ejecutadas. Esta página contiene directamente los payloads, respuestas y conclusiones necesarios para revisar la fase sin abrir otro archivo.
