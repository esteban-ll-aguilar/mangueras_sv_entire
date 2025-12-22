``` sql
-- SQL script to create tables for products, brands, and categories
-- with Row Level Security (RLS) policies in PostgreSQL
create table if not exists public.brand(
  id uuid primary key default gen_random_uuid() not null,
  name varchar(100) unique not null,
  description varchar(500),
  image_url text
);
create index if not exists idx_brand_name on brand(name);
-- . Habilitar RLS (Row Level Security)
ALTER TABLE public.brand ENABLE ROW LEVEL SECURITY;
-- . Crear políticas de seguridad
-- . Solo usuarios autenticados pueden subir productos
CREATE POLICY "Only users can insert brands"
ON public.brand
as permissive
FOR INSERT 
to authenticated
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden editar productos
CREATE POLICY "Only users can update brands"
ON public.brand 
FOR UPDATE 
to authenticated
USING ( true )
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden eliminar productos
CREATE POLICY "Only users can delete brands"
ON public.brand 
FOR DELETE 
to authenticated
using ( true );
-- . Todos los usuarios pueden ver  brands
CREATE POLICY "All users can view brands"
ON public.brand 
FOR SELECT 
using ( true );



-- TABLA CATEGORIAS
create table if not exists public.category(
  id uuid primary key default gen_random_uuid() not null,
  name varchar(100) unique not null,
  description varchar(500),
  is_main_category boolean default false not null,
  image_url text
);
-- . Crear INDICES
create index if not exists idx_category_name on category(name);
-- . Habilitar RLS (Row Level Security)
ALTER TABLE public.category ENABLE ROW LEVEL SECURITY;
-- . Crear políticas de seguridad
-- . Solo usuarios autenticados pueden subir categorias
CREATE POLICY "Only users can insert categories"
ON public.category 
FOR INSERT 
to authenticated
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden editar categorias
CREATE POLICY "Only users can update categories"
ON public.category 
FOR UPDATE 
to authenticated
USING ( true )
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden eliminar categorias
CREATE POLICY "Only users can delete categories"
ON public.category 
FOR DELETE 
to authenticated
using ( true );
-- . Todos los usuarios pueden ver  categories
CREATE POLICY "All users can view categories"
ON public.category 
FOR SELECT 
using ( true );



-- TABLA INTERMEDIA
create table if not exists public.brand_category(
  id uuid primary key default gen_random_uuid() not null,
  brand_id uuid references public.brand(id) on delete cascade not null,
  category_id uuid references public.category(id) on delete cascade not null,
  unique (brand_id, category_id) --evitar dublicados
);

create index if not exists idx_brand_category_brand_id_category_id on brand_category(brand_id,category_id);


alter table public.brand_category enable row level security;

create policy "Only users can insert relationship in brand y categories"
on public.brand_category
for insert
to authenticated 
with check (true);
-- 
create policy "Only users can delete relationship in brand y categories"
on public.brand_category
for delete
to authenticated 
using (true);

create policy "Only users can update relationship in brand y categories"
on public.brand_category
for update
to authenticated 
using (true)
with check (true);

create policy "All user can view relationship in brand y categories"
on public.brand_category
FOR SELECT
using (true);





-- TABLA PRODUCTOS
create table if not exists public.product(
  code text primary key not null,
  name varchar(100) not null,
  description varchar(500),
  image_url text,
  brand_category_id uuid references public.brand_category(id) on delete cascade not null ,
  price numeric(10,2) default 0 not null,
  stock_quantity int default 0 not null,
  is_active boolean default true not null
);
-- . Crear INDICES
create index if not exists idx_product_name on product(name);
create index if not exists idx_product_code_brand_id_category_id 
        on product(code, brand_id, category_id);
-- . Habilitar RLS (Row Level Security)
ALTER TABLE public.product ENABLE ROW LEVEL SECURITY;
-- . Crear políticas de seguridad
-- . Solo usuarios autenticados pueden subir productos
CREATE POLICY "Only users can insert products"
ON public.product 
FOR INSERT 
to authenticated
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden editar productos
CREATE POLICY "Only users can update products"
ON public.product 
FOR UPDATE 
to authenticated
USING ( true )
WITH CHECK ( true );
-- . Solo usuarios autenticados pueden eliminar productos
CREATE POLICY "Only users can delete products"
ON public.product 
FOR DELETE 
to authenticated
using ( true );

-- . Todos los usuarios pueden ver  productos
CREATE POLICY "All users can view products"
ON public.product 
FOR SELECT 
using ( true );


-- Creates Views

-- CREATE VIEW products_view_flat AS
SELECT 
  p.*,
  bc.brand_id,
  b.name as brand_name,
  bc.category_id,
  c.name as category_name

FROM public.product as p
INNER JOIN public.brand_category bc ON p.brand_category_id = bc.id
INNER JOIN public.brand b ON bc.brand_id = b.id
INNER JOIN public.category c ON bc.category_id = c.id;





