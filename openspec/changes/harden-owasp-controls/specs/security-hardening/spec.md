## ADDED Requirements

### Requirement: Server-side authorization
La aplicación MUST impedir que un usuario cliente modifique su propio rol o el estado administrativo de un pedido.

#### Scenario: Client cannot escalate role
- **WHEN** un JWT de cliente intenta actualizar `profiles.role`
- **THEN** la operación es rechazada por RLS o por una función protegida

### Requirement: Safe image uploads
El almacenamiento MUST aceptar únicamente imágenes permitidas y MUST impedir acceso público directo.

#### Scenario: Executable upload is rejected
- **WHEN** se intenta subir un archivo `.exe` con MIME `image/jpeg`
- **THEN** la aplicación lo rechaza antes de subirlo o el bucket lo rechaza

### Requirement: Safe errors and searches
La UI MUST ocultar detalles internos y las búsquedas MUST tratar comodines como texto literal.

#### Scenario: Invalid login has generic error
- **WHEN** el login falla
- **THEN** la UI muestra un mensaje genérico sin stack trace ni excepción cruda
