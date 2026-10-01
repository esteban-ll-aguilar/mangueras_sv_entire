-- Full restore generado desde los modelos Dart (BrandModel, CategoryModel, BrandCategoryModel, ProductModel)
-- Fecha: 2026-10-01
-- Fuente de verdad:
--   lib/app/modules/inventory/domain/models/brand_model.dart + brand_model.g.dart
--   lib/app/modules/inventory/domain/models/category_model.dart + category_model.g.dart
--   lib/app/modules/inventory/domain/models/brand_category_model.dart + brand_category_model.g.dart
--   lib/app/modules/inventory/domain/models/product_model.dart + product_model.g.dart
--   lib/core/utils/enums/enums.dart (supabaseTablesNames)
--   lib/app/modules/inventory/infrastructure/repository/*_repository_impl.dart
--   lib/app/modules/inventory/infrastructure/providers/inventory_providers.dart (bucket: inventory-images)
--
-- Cómo usar: pégalo en Supabase Dashboard > SQL Editor > New query > Run
-- O con CLI: supabase db push

-- 0. Extensión para gen_random_uuid()
create extension if not exists "pgcrypto";

-- ============================================================
-- 1. TABLA brand (BrandModel: id, name, description, image_url)
-- ============================================================
create table if not exists public.brand (
  id uuid primary key default gen_random_uuid() not null,
  name varchar(100) unique not null,
  description varchar(500),
  image_url text
);
create index if not exists idx_brand_name on public.brand (name);

-- ============================================================
-- 2. TABLA category
-- (CategoryModel: id, name, description, is_main_category, image_url)
-- OJO: is_main_category NO existía en docs/SQL_SCRIPT_DOC.md, es nuevo
-- ============================================================
create table if not exists public.category (
  id uuid primary key default gen_random_uuid() not null,
  name varchar(100) unique not null,
  description varchar(500),
  is_main_category boolean default false not null,
  image_url text
);
create index if not exists idx_category_name on public.category (name);
create index if not exists idx_category_is_main on public.category (is_main_category);

-- ============================================================
-- 3. TABLA brand_category (BrandCategoryModel: id, brand_id, category_id)
-- Tabla pivote N:M. NO existía en el SQL viejo.
-- ============================================================
create table if not exists public.brand_category (
  id uuid primary key default gen_random_uuid() not null,
  brand_id uuid references public.brand (id) on delete cascade not null,
  category_id uuid references public.category (id) on delete cascade not null,
  constraint uq_brand_category unique (brand_id, category_id)
);
create index if not exists idx_brand_category_brand on public.brand_category (brand_id);
create index if not exists idx_brand_category_category on public.brand_category (category_id);

-- ============================================================
-- 4. TABLA product
-- (ProductModel: code PK text, name, description, image_url,
--  brand_category_id FK, price, stock_quantity, is_active)
-- OJO: el SQL viejo usaba brand_id + category_id directos.
-- El código actual usa brand_category_id. Se usa el nuevo.
-- ============================================================
create table if not exists public.product (
  code text primary key not null,
  name varchar(100) not null,
  description varchar(500),
  image_url text,
  brand_category_id uuid references public.brand_category (id) on delete cascade not null,
  price numeric(10,2) default 0 not null,
  stock_quantity int default 0 not null,
  is_active boolean default true not null
);
create index if not exists idx_product_name on public.product (name);
create index if not exists idx_product_brand_category on public.product (brand_category_id);
create index if not exists idx_product_is_active on public.product (is_active);

-- ============================================================
-- 5. VISTA products_view_flat
-- Usada por ProductRepositoryImpl.getAllProducts / getProductById /
-- getProductsByName / getAllFilteredProducts, etc.
-- JSON esperado:
-- { code, name, description, image_url, price, stock_quantity,
--   is_active, brand_category_id, brand_id, brand_name,
--   category_id, category_name }
-- ============================================================
create or replace view public.products_view_flat as
select
  p.code,
  p.name,
  p.description,
  p.image_url,
  p.price,
  p.stock_quantity,
  p.is_active,
  p.brand_category_id,
  b.id as brand_id,
  b.name as brand_name,
  c.id as category_id,
  c.name as category_name
from public.product p
join public.brand_category bc on bc.id = p.brand_category_id
join public.brand b on b.id = bc.brand_id
join public.category c on c.id = bc.category_id;

-- ============================================================
-- 6. RLS (Row Level Security)
-- SELECT público (anon + authenticated) porque la tienda (/shop)
-- muestra productos sin login (ver common_router.dart).
-- INSERT/UPDATE/DELETE solo authenticated (admin).
-- ============================================================
alter table public.brand enable row level security;
alter table public.category enable row level security;
alter table public.brand_category enable row level security;
alter table public.product enable row level security;

-- Limpieza idempotente de políticas viejas
drop policy if exists "All users can view brands" on public.brand;
drop policy if exists "Only users can insert brands" on public.brand;
drop policy if exists "Only users can update brands" on public.brand;
drop policy if exists "Only users can delete brands" on public.brand;

drop policy if exists "All users can view categories" on public.category;
drop policy if exists "Only users can insert categories" on public.category;
drop policy if exists "Only users can update categories" on public.category;
drop policy if exists "Only users can delete categories" on public.category;

drop policy if exists "Public can view brand_category" on public.brand_category;
drop policy if exists "Auth can insert brand_category" on public.brand_category;
drop policy if exists "Auth can update brand_category" on public.brand_category;
drop policy if exists "Auth can delete brand_category" on public.brand_category;

drop policy if exists "All users can view products" on public.product;
drop policy if exists "Only users can insert products" on public.product;
drop policy if exists "Only users can update products" on public.product;
drop policy if exists "Only users can delete products" on public.product;

-- brand
create policy "All users can view brands"
on public.brand for select to anon, authenticated using (true);
create policy "Only users can insert brands"
on public.brand for insert to authenticated with check (true);
create policy "Only users can update brands"
on public.brand for update to authenticated using (true) with check (true);
create policy "Only users can delete brands"
on public.brand for delete to authenticated using (true);

-- category
create policy "All users can view categories"
on public.category for select to anon, authenticated using (true);
create policy "Only users can insert categories"
on public.category for insert to authenticated with check (true);
create policy "Only users can update categories"
on public.category for update to authenticated using (true) with check (true);
create policy "Only users can delete categories"
on public.category for delete to authenticated using (true);

-- brand_category
create policy "Public can view brand_category"
on public.brand_category for select to anon, authenticated using (true);
create policy "Auth can insert brand_category"
on public.brand_category for insert to authenticated with check (true);
create policy "Auth can update brand_category"
on public.brand_category for update to authenticated using (true) with check (true);
create policy "Auth can delete brand_category"
on public.brand_category for delete to authenticated using (true);

-- product
create policy "All users can view products"
on public.product for select to anon, authenticated using (true);
create policy "Only users can insert products"
on public.product for insert to authenticated with check (true);
create policy "Only users can update products"
on public.product for update to authenticated using (true) with check (true);
create policy "Only users can delete products"
on public.product for delete to authenticated using (true);

-- ============================================================
-- 7. STORAGE: bucket inventory-images (ver inventory_providers.dart)
-- Estructura usada en InventoryStorageRepositoryImpl:
--   productImages/{code}.ext, categoryImages/{id}.ext, brandImages/{id}.ext
-- Ejecuta esto y luego haz el bucket Public en Dashboard > Storage
-- ============================================================
insert into storage.buckets (id, name, public)
values ('inventory-images', 'inventory-images', true)
on conflict (id) do update set public = true;

-- Políticas de storage (si ya existen, ignora el error)
drop policy if exists "Public read inventory-images" on storage.objects;
drop policy if exists "Auth upload inventory-images" on storage.objects;
drop policy if exists "Auth delete inventory-images" on storage.objects;

create policy "Public read inventory-images"
on storage.objects for select to anon, authenticated using (bucket_id = 'inventory-images');

create policy "Auth upload inventory-images"
on storage.objects for insert to authenticated with check (bucket_id = 'inventory-images');

create policy "Auth delete inventory-images"
on storage.objects for delete to authenticated using (bucket_id = 'inventory-images');
