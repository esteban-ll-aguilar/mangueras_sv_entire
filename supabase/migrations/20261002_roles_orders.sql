-- Roles + carrito/pedidos en nube + vendido descuenta stock
-- Pegar en Dashboard > SQL Editor > Run (una sola vez, en orden)

-- 1. Perfiles con rol (cliente por defecto)
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade not null,
  email text,
  full_name text,
  role text default 'cliente' not null check (role in ('admin','cliente')),
  created_at timestamptz default now() not null
);

-- Trigger: al registrarse en auth.users se crea el profile como cliente
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    coalesce(new.raw_user_meta_data ->> 'role', 'cliente')
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Helper: ¿soy admin?
create or replace function public.is_admin()
returns boolean language sql security definer set search_path = public as $$
  select exists (select 1 from public.profiles where id = auth.uid() and role = 'admin');
$$;

-- 2. Pedidos (lo del carrito + lo comprado + historial)
create table if not exists public.orders (
  id uuid primary key default gen_random_uuid() not null,
  user_id uuid references public.profiles (id) on delete cascade not null,
  status text default 'pendiente' not null check (status in ('pendiente','vendido','cancelado')),
  total numeric(10,2) default 0 not null,
  created_at timestamptz default now() not null,
  sold_at timestamptz,
  sold_by uuid references public.profiles (id)
);
create index if not exists idx_orders_user on public.orders (user_id);
create index if not exists idx_orders_status on public.orders (status);

create table if not exists public.order_items (
  id uuid primary key default gen_random_uuid() not null,
  order_id uuid references public.orders (id) on delete cascade not null,
  product_code text references public.product (code) on delete restrict not null,
  quantity int not null check (quantity > 0),
  unit_price numeric(10,2) not null,
  subtotal numeric(10,2) generated always as (quantity * unit_price) stored
);
create index if not exists idx_order_items_order on public.order_items (order_id);

-- 3. RLS
alter table public.profiles enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "Users view own profile" on public.profiles;
drop policy if exists "Users update own profile" on public.profiles;
drop policy if exists "Admin view all profiles" on public.profiles;

create policy "Users view own profile"
on public.profiles for select to authenticated using (auth.uid() = id or public.is_admin());
create policy "Users update own profile"
on public.profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);
create policy "Admin view all profiles"
on public.profiles for select to authenticated using (public.is_admin());

drop policy if exists "Cliente crea su pedido" on public.orders;
drop policy if exists "Cliente ve sus pedidos" on public.orders;
drop policy if exists "Admin ve todo" on public.orders;
drop policy if exists "Admin actualiza pedidos" on public.orders;

create policy "Cliente crea su pedido"
on public.orders for insert to authenticated with check (auth.uid() = user_id);
create policy "Cliente ve sus pedidos"
on public.orders for select to authenticated using (auth.uid() = user_id or public.is_admin());
create policy "Admin ve todo"
on public.orders for select to authenticated using (public.is_admin());
create policy "Admin actualiza pedidos"
on public.orders for update to authenticated using (public.is_admin()) with check (public.is_admin());

drop policy if exists "Cliente inserta items propios" on public.order_items;
drop policy if exists "Ver items propios o admin" on public.order_items;

create policy "Cliente inserta items propios"
on public.order_items for insert to authenticated with check (
  exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
);
create policy "Ver items propios o admin"
on public.order_items for select to authenticated using (
  public.is_admin() or exists (select 1 from public.orders o where o.id = order_id and o.user_id = auth.uid())
);

-- 4. RPC: admin marca vendido y descuenta stock (transaccional)
create or replace function public.sell_order(p_order_id uuid)
returns void language plpgsql security definer set search_path = public as $$
declare
  v_status text;
  r record;
  v_stock int;
begin
  if not public.is_admin() then
    raise exception 'Solo admin puede vender';
  end if;

  select status into v_status from public.orders where id = p_order_id;
  if not found then raise exception 'Pedido no existe'; end if;
  if v_status <> 'pendiente' then raise exception 'Pedido ya procesado: %', v_status; end if;

  -- Bloquea filas y valida stock
  for r in select product_code, quantity from public.order_items where order_id = p_order_id loop
    select stock_quantity into v_stock from public.product where code = r.product_code for update;
    if not found then raise exception 'Producto % no existe', r.product_code; end if;
    if v_stock < r.quantity then
      raise exception 'Stock insuficiente %: hay %, piden %', r.product_code, v_stock, r.quantity;
    end if;
  end loop;

  -- Descuenta
  for r in select product_code, quantity from public.order_items where order_id = p_order_id loop
    update public.product set stock_quantity = stock_quantity - r.quantity where code = r.product_code;
  end loop;

  update public.orders set status = 'vendido', sold_at = now(), sold_by = auth.uid()
  where id = p_order_id;
end;
$$;

-- Para que el primer admin exista: corre esto a mano tras crear tu usuario:
-- update public.profiles set role = 'admin' where email = 'tu-correo@admin.com';
