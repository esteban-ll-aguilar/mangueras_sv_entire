# Estructura Lógica de Carpetas — Proyecto Mangueras SV

Proyecto Flutter con backend Supabase y base local SQLite (Drift) en modo offline-first.
La lógica está organizada por **módulos de negocio + núcleo común + doble fuente de datos**.

## 1. `lib/` — Código fuente

Punto de entrada: `lib/main.dart`
Inicializa `.env`, Supabase, Riverpod (`ProviderScope`), router único por rol y tema global.

### a) `lib/app/modules/` — Lógica por funcionalidad

Cada carpeta es un módulo de negocio independiente:

- `auth/` — Login, registro, recuperación y gestión de usuarios.
- `home/` — Shell principal, home y navegación base.
- `shop/` — Tienda pública, catálogo y carrito.
- `inventory/` — CRUD admin de productos, marcas y categorías.
- `orders/` — Mis pedidos (cliente) y gestión de pedidos (admin).
- `example/` — Plantilla de ejemplo para nuevos módulos.

Lógica interna de cada módulo (Clean Architecture, 3 capas):

- `domain/` — Modelos + contratos `repository` (qué se necesita).
- `infrastructure/` — `repository_impl` + `providers` Riverpod (cómo se obtiene: Supabase o Drift).
- `presentation/` — `pages/` + `widgets/` (solo UI).

### b) `lib/app/shared/` — UI reutilizable entre módulos

Widgets y helpers comunes (`presentation/` + `shared.dart`).

### c) `lib/core/` — Transversal a toda la app

No pertenece a ningún módulo:

- `routes/` (`app_router`, `admin_routes`, `common_router`) con `go_router`.
- `theme/`, `network/` (cliente Supabase), `errors/`, `utils/`, `dependencies/`, `upgrade/`.

### d) `lib/database/local_database/` — Persistencia local offline-first

Drift + SQLite como caché local:

- `app_local_database.dart`, `connection/`, `queries/` (`functions`, `indexs`, `triggers` en `.drift`).

## 2. Backend y datos

- `supabase/migrations/` — Esquema SQL y migraciones remotas (fuente de verdad).
- `drift_schemas/` — Versionado / historial del esquema local.
- `docs/SQL_SCRIPT_DOC.md` — Documentación SQL.

## 3. Soporte

- `assets/` (`logo.png`, `images/`) — Recursos estáticos.
- `test/widget_test.dart` — Pruebas.
- `tools/builder.dart` — Scripts de generación (`build_runner`, `riverpod`, `drift`, `json_serializable`).
- `android/`, `ios/`, `web/`, `linux/`, `macos/`, `windows/` — Wrappers nativos por plataforma, solo empaquetado, sin lógica de negocio.
- Raíz: `pubspec.yaml` (dependencias), `.env` (claves), `analysis_options.yaml` (lints), `build.yaml` (generación).

## Resumen

Arquitectura **modular por features + núcleo común + doble fuente de datos**:
Supabase remoto como fuente de verdad, Drift local como caché offline, UI desacoplada con Riverpod + GoRouter.
