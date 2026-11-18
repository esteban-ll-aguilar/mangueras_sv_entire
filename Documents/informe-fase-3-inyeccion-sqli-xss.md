# Fase 3 (Semana 7, del 16 al 20 de noviembre de 2026)

## Ataques de inyección: explotación controlada y mitigación de SQLi y XSS

## 1. Resumen ejecutivo

Esta fase diferencia dos entornos que no deben mezclarse:

1. **DVWA**, utilizado como laboratorio deliberadamente vulnerable para demostrar SQL Injection (SQLi) y Cross-Site Scripting (XSS).
2. **La aplicación propia Flutter + Supabase**, verificada contra el proyecto remoto `xrnnmcolputazgqfewpz` mediante Supabase Auth y PostgREST.

El resultado de la verificación real sobre Supabase fue el siguiente:

- `admin@gmail.com` inició sesión correctamente con rol `admin`.
- `cliente@gmail.com` inició sesión correctamente con rol `cliente`.
- El administrador pudo consultar los dos perfiles y el pedido existente.
- El cliente solo pudo consultar su propio perfil y su propio pedido.
- El intento de SQLi en el filtro UUID de `orders` fue rechazado por PostgREST con HTTP 400 y código PostgreSQL `22P02`.
- La función `sell_order` rechazó al cliente con `Solo admin puede vender`.
- La misma función, invocada por el administrador con un UUID inexistente, respondió `Pedido no existe`; no se modificó ningún pedido ni inventario.
- No se encontraron evidencias de XSS ejecutable en la interfaz Flutter revisada: los datos se muestran mediante widgets `Text`, no mediante HTML interpretado.

Por tanto, **la SQLi y el XSS sí son reproducibles en DVWA Low por diseño, pero no se reprodujeron en la aplicación propia durante las pruebas ejecutadas**. La configuración de Supabase sí debe seguir verificándose en cuanto a migraciones, políticas de catálogo, storage y validación de campos.

> Nota de exactitud temporal: el cronograma académico corresponde al jueves 19 y viernes 20 de noviembre de 2026. La verificación remota con las cuentas reales se ejecutó antes de esas sesiones, el 18 de noviembre de 2026, como preparación y comprobación del entorno.

## 2. Alcance y reglas éticas

- El laboratorio de explotación se limita a DVWA local y a datos de prueba.
- Las pruebas contra Supabase se realizaron sobre el proyecto propio configurado en el repositorio.
- No se usaron instrucciones destructivas (`DROP`, `DELETE` o `UPDATE`) durante la verificación remota.
- No se crearon cuentas nuevas.
- No se modificaron perfiles, pedidos, productos, stock ni archivos del storage.
- Las contraseñas de laboratorio no se incluyen en este documento.
- Los tokens de sesión se usaron únicamente en memoria durante las peticiones y no se registran en el informe.

## 3. Datos del entorno

| Elemento | Detalle |
|---|---|
| Aplicación | Flutter + Supabase |
| Proyecto Supabase | `xrnnmcolputazgqfewpz` |
| API utilizada | Supabase Auth y PostgREST |
| Usuario administrador | `admin@gmail.com` |
| Rol verificado | `admin` |
| Usuario cliente | `cliente@gmail.com` |
| Rol verificado | `cliente` |
| Laboratorio | DVWA local, nivel Low según la guía de la fase |
| Fecha del cronograma | 19 y 20 de noviembre de 2026 |
| Fecha de verificación remota | 18 de noviembre de 2026 |
| Resultado general | Supabase: sin SQLi reproducible; RLS básico de perfiles/pedidos verificado |

## 4. Sesión 1 — jueves 19 de noviembre, 09h30 a 11h30

### Actividad 1: Causas de SQLi y XSS — 20 minutos

Las inyecciones ocurren cuando datos controlados por el usuario se mezclan con un lenguaje que el sistema interpreta como código.

#### SQL Injection

La causa clásica es concatenar una entrada directamente en una consulta:

```php
$id = $_REQUEST['id'];
$query = "SELECT first_name, last_name FROM users WHERE user_id = '$id';";
```

Una entrada como `1' OR '1'='1` puede cerrar la cadena y alterar la lógica de la consulta. La defensa principal es separar código y datos usando consultas preparadas o parámetros tipados.

#### Cross-Site Scripting

La causa clásica es reflejar o almacenar texto no confiable en HTML sin escaparlo:

```php
echo '<pre>Hello ' . $_GET['name'] . '</pre>';
```

Si el navegador interpreta la entrada como HTML o JavaScript, un atacante puede ejecutar código en el contexto de la aplicación. La defensa principal es el escape contextual de salida y, como defensa adicional, la validación de entrada.

### Actividad 2: Laboratorio de explotación controlada — 80 minutos

#### 4.2.1 SQLi en DVWA

El módulo SQL Injection de DVWA Low concatena el parámetro `id`. Las pruebas de concepto previstas son:

| ID | Payload | Resultado esperado | Evidencia |
|---|---|---|---|
| SQLI-01 | `'` | Error de sintaxis que confirma que la entrada llega a la consulta | Captura DVWA 1 |
| SQLI-02 | `1' OR '1'='1` | Tautología; devuelve múltiples usuarios de laboratorio | Captura DVWA 2 |
| SQLI-03 | `' OR '1'='1' #` | Tautología con comentario del resto de la consulta | Captura DVWA 3 |
| SQLI-04 | `1' UNION SELECT user, password FROM users #` | Lectura de columnas de la tabla de laboratorio | Captura DVWA 4 |

#### 4.2.2 Bypass de autenticación en DVWA

El patrón clásico consiste en introducir `admin' --` en el usuario para comentar la comprobación de contraseña. Esta demostración solo aplica al código vulnerable del laboratorio. La autenticación propia delega la validación en Supabase Auth mediante `signInWithPassword`.

#### 4.2.3 XSS reflejado en DVWA

| ID | Payload | Resultado esperado | Evidencia |
|---|---|---|---|
| XSS-01 | `<script>alert('XSS-lab')</script>` | Se ejecuta una alerta en el navegador del laboratorio | Captura DVWA 5 |
| XSS-02 | `<img src=x onerror=alert(document.domain)>` | Se ejecuta el manejador `onerror` | Captura DVWA 6 |
| XSS-03 | `<b>prueba</b>` | El navegador interpreta la etiqueta y muestra texto en negrita | Captura DVWA 7 |

Las capturas de DVWA deben anexarse al entregable si la guía las exige. Este informe no presenta como capturas reales aquellas que no fueron adjuntadas al repositorio.

### Actividad 3: Sistematización de evidencias — 20 minutos

Las pruebas se organizan en tres partes:

1. Causa técnica.
2. Payload y resultado observado.
3. Mitigación y re-ejecución del mismo payload.

El criterio de cierre es el ciclo **hallazgo → mitigación → verificación**.

## 5. Sesión 2 — viernes 20 de noviembre, 07h30 a 09h30

### Actividad 1: Mitigaciones de referencia — 15 minutos

Las mitigaciones aplicables son:

- **SQLi:** consultas preparadas, parámetros tipados y validación de formato.
- **XSS:** escape contextual de salida; no insertar texto no confiable mediante `innerHTML`.
- **Defensa en profundidad:** restricciones de base de datos, RLS, validación de cliente y revisión de funciones SQL propias.

La validación por sí sola no reemplaza la parametrización ni el escape: un atacante puede omitir la interfaz y llamar directamente a la API.

### Actividad 2: Implementación y verificación — 85 minutos

#### 5.2.1 Implementación SQL de referencia

Código vulnerable:

```php
$id = $_REQUEST['id'];
$query = "SELECT first_name, last_name FROM users WHERE user_id = '$id';";
```

Código mitigado:

```php
$id = filter_input(INPUT_GET, 'id', FILTER_VALIDATE_INT);
if ($id === false || $id === null) {
    die('Parámetro inválido');
}

$stmt = $pdo->prepare(
    'SELECT first_name, last_name FROM users WHERE user_id = :id'
);
$stmt->bindValue(':id', $id, PDO::PARAM_INT);
$stmt->execute();
```

#### 5.2.2 Implementación XSS de referencia

Código vulnerable:

```php
echo '<pre>Hello ' . $_GET['name'] . '</pre>';
```

Código mitigado:

```php
$name = htmlspecialchars(
    $_GET['name'] ?? '',
    ENT_QUOTES | ENT_SUBSTITUTE,
    'UTF-8'
);
echo '<pre>Hello ' . $name . '</pre>';
```

#### 5.2.3 Equivalente seguro en la aplicación Flutter + Supabase

La aplicación no construye SQL manualmente para sus consultas principales. Usa filtros de Supabase/PostgREST:

```dart
final response = await supabase
    .from('orders')
    .select()
    .eq('id', orderId);
```

El valor `orderId` se interpreta como valor del filtro, no como fragmento de SQL. Además, los UUID son validados por PostgreSQL/PostgREST.

La interfaz revisada muestra nombres y otros textos mediante `Text` de Flutter. Ese widget no interpreta etiquetas HTML ni ejecuta JavaScript.

### 5.2.4 Pruebas reales realizadas en Supabase

#### Inicio de sesión y roles

Ambas cuentas iniciaron sesión contra el proyecto remoto y recibieron tokens válidos emitidos por:

```text
https://xrnnmcolputazgqfewpz.supabase.co/auth/v1
```

Resultado:

| Cuenta | ID interno verificado | Rol en `public.profiles` |
|---|---|---|
| `admin@gmail.com` | `099a7449-635a-421d-b9db-0403977d2cb5` | `admin` |
| `cliente@gmail.com` | `0ee9a4ae-328b-4f35-b26a-63d040536877` | `cliente` |

#### Lectura de perfiles

- El administrador obtuvo los dos perfiles.
- El cliente obtuvo únicamente su propio perfil.

Esto confirma el aislamiento básico esperado en las políticas de `profiles`.

#### Lectura de pedidos

Existe un pedido de prueba:

```text
id: f197f4c4-ba7a-445c-b8c4-0117d73c13ce
user_id: 0ee9a4ae-328b-4f35-b26a-63d040536877
status: pendiente
total: 0.00
```

- El administrador pudo verlo.
- El cliente pudo verlo porque pertenece a su usuario.
- No se intentó alterar el pedido.

#### APP-SQLI-01 — tautología en filtro UUID

Petición probada para ambos usuarios:

```text
GET /rest/v1/orders?id=eq.1' OR '1'='1&select=*
```

Resultado real para administrador y cliente:

```text
HTTP 400
code: 22P02
message: invalid input syntax for type uuid: "1' OR '1'='1"
```

Interpretación: PostgREST y PostgreSQL trataron la entrada como un UUID inválido. No se convirtió en una condición tautológica y no devolvió todos los pedidos.

#### APP-RLS-01 — RPC `sell_order`

Se invocó la función con el UUID inexistente `00000000-0000-0000-0000-000000000000`, sin modificar datos.

Resultado como administrador:

```text
HTTP 400
Pedido no existe
```

Resultado como cliente:

```text
HTTP 400
Solo admin puede vender
```

Interpretación: la función aplica una comprobación de rol y no permite que el cliente ejecute la operación administrativa.

#### APP-XSS-01 — visualización de texto en Flutter

En la interfaz revisada, el nombre se presenta mediante `Text` y no mediante un renderizador HTML. Por eso una cadena como:

```html
<script>alert(1)</script>
```

se mostraría como texto y no como JavaScript ejecutable dentro de esa pantalla.

No se realizó una escritura remota de esa cadena porque no era necesario para demostrar el comportamiento del widget y se decidió no modificar datos del proyecto.

### Actividad 3: Informe de la fase — 20 minutos

La evidencia se consolidó en este documento con:

- alcance y reglas éticas;
- causas técnicas;
- payloads de laboratorio;
- pruebas reales con usuarios Supabase;
- resultados HTTP y mensajes observados;
- mitigaciones de referencia;
- matriz final de hallazgos y pendientes.

## 6. Matriz de hallazgos

| ID | Hallazgo | Entorno | Severidad | Estado | Mitigación |
|---|---|---|---|---|---|
| INY-01 | SQLi por concatenación directa | DVWA Low | Alta en laboratorio | Reproducible en DVWA | Consultas preparadas y validación de tipo |
| INY-02 | XSS reflejado por salida HTML sin escapar | DVWA Low | Alta en laboratorio | Reproducible en DVWA | Escape contextual con `htmlspecialchars` |
| INY-03 | SQLi mediante filtro de `orders` | Supabase/PostgREST | Alta potencial | No reproducida | UUID tipado y filtros parametrizados |
| INY-04 | XSS en pantalla actual de Flutter | Flutter | Media potencial | No reproducida | `Text` no interpreta HTML |
| INY-05 | `full_name` sin CHECK de longitud/caracteres confirmado | Supabase | Baja, defensa en profundidad | Pendiente | Añadir CHECK y validar en servidor |
| INY-06 | RPC administrativa accesible a cliente | Supabase | Alta potencial | Controlado | `is_admin()` rechaza al cliente |
| INY-07 | Estado de migración completa no auditado con service role | Supabase | Media | Pendiente de confirmación | Revisar historial de migraciones y políticas desde Dashboard |

## 7. Qué sí es vulnerable y qué no

### Vulnerable en el laboratorio

- DVWA Low es vulnerable a SQLi porque concatena entradas en SQL.
- DVWA Low es vulnerable a XSS porque refleja HTML sin escape.
- Esos resultados no representan automáticamente la arquitectura de Supabase.

### No vulnerable según las pruebas ejecutadas

- El filtro UUID de `orders` no aceptó una tautología SQL.
- El cliente no pudo ver el perfil del administrador.
- El cliente no pudo ejecutar `sell_order`.
- Flutter no ejecuta scripts al mostrar el valor en un widget `Text`.

### Pendiente o no demostrado

- No se confirmó desde el historial remoto si toda la migración `20261023_security_hardening.sql` está aplicada.
- No se auditó con una clave `service_role` la totalidad de políticas de catálogo y storage.
- No existe en el repositorio la migración `20261120_validate_profile_fields.sql` mencionada en documentos previos.
- No debe afirmarse que `full_name` está protegido por un `CHECK` hasta crear y aplicar esa migración.
- Las capturas DVWA deben adjuntarse para cerrar la evidencia visual de la sesión de laboratorio.

## 8. Conclusiones

1. La demostración de SQLi y XSS corresponde a DVWA y cumple el objetivo didáctico del laboratorio.
2. Supabase no funciona como una consulta SQL concatenada desde Flutter: la app usa Auth y PostgREST.
3. La prueba real con `admin@gmail.com` y `cliente@gmail.com` confirmó autenticación, separación de perfiles, separación de pedidos y control administrativo de `sell_order`.
4. La inyección `1' OR '1'='1` fue rechazada por el tipo UUID antes de producir una consulta tautológica.
5. La aplicación móvil no mostró una ruta de XSS ejecutable en la pantalla revisada.
6. La defensa pendiente más clara es añadir y aplicar una restricción de servidor para `full_name`, además de confirmar el estado de las migraciones y políticas remotas.

## 9. Recomendaciones

- Aplicar y registrar la migración de endurecimiento en Supabase.
- Crear una migración explícita para limitar `full_name` a una longitud razonable y rechazar etiquetas HTML si el negocio no las necesita.
- Mantener el escape contextual si en el futuro se crea un cliente web que renderice HTML.
- Auditar políticas de `brand`, `category`, `product`, `brand_category` y `storage.objects` con una cuenta de prueba cliente y una cuenta admin.
- Resolver los conflictos Git existentes antes de presentar el proyecto: `flutter analyze` actualmente falla por marcadores `<<<<<<<`, `=======` y `>>>>>>>`.
- Adjuntar capturas de DVWA y las respuestas HTTP de las pruebas Supabase como anexos del entregable.

## 10. Anexo: comandos de verificación usados

Las siguientes consultas fueron de lectura o invocaron una función con un UUID inexistente; no se realizaron escrituras persistentes:

```bash
# Inicio de sesión
POST /auth/v1/token?grant_type=password

# Perfiles
GET /rest/v1/profiles?select=id,email,full_name,role&limit=20

# Pedidos
GET /rest/v1/orders?select=id,user_id,status,total&limit=20

# Prueba de filtro malicioso
GET /rest/v1/orders?id=eq.1%27%20OR%20%271%27=%271&select=*

# Prueba de autorización sin pedido real
POST /rest/v1/rpc/sell_order
{"p_order_id":"00000000-0000-0000-0000-000000000000"}
```

## 11. Estado de entrega

**Resultado:** informe preparado con la separación entre laboratorio DVWA y verificación real de Supabase.

**Pendientes para cierre académico:** adjuntar capturas DVWA, confirmar el historial de migraciones remoto y resolver los conflictos de código detectados por `flutter analyze`.
