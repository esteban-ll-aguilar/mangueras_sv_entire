-- Security hardening for the OWASP review. Apply after the restore/roles migrations.

-- A01: public registration can never choose a privileged role.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, full_name, role)
  values (new.id, new.email, coalesce(new.raw_user_meta_data ->> 'full_name', ''), 'cliente')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop policy if exists "Users update own profile" on public.profiles;
drop policy if exists "Admin update profiles" on public.profiles;
create policy "Admin update profiles"
on public.profiles for update to authenticated
using (public.is_admin())
with check (public.is_admin());

-- A01/A06: only admins can mutate catalog/order administrative state.
drop policy if exists "Only users can insert brands" on public.brand;
drop policy if exists "Only users can update brands" on public.brand;
drop policy if exists "Only users can delete brands" on public.brand;
create policy "Admins insert brands" on public.brand for insert to authenticated with check (public.is_admin());
create policy "Admins update brands" on public.brand for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Admins delete brands" on public.brand for delete to authenticated using (public.is_admin());

drop policy if exists "Only users can insert categories" on public.category;
drop policy if exists "Only users can update categories" on public.category;
drop policy if exists "Only users can delete categories" on public.category;
create policy "Admins insert categories" on public.category for insert to authenticated with check (public.is_admin());
create policy "Admins update categories" on public.category for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Admins delete categories" on public.category for delete to authenticated using (public.is_admin());

drop policy if exists "Auth can insert brand_category" on public.brand_category;
drop policy if exists "Auth can update brand_category" on public.brand_category;
drop policy if exists "Auth can delete brand_category" on public.brand_category;
create policy "Admins insert brand_category" on public.brand_category for insert to authenticated with check (public.is_admin());
create policy "Admins update brand_category" on public.brand_category for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Admins delete brand_category" on public.brand_category for delete to authenticated using (public.is_admin());

drop policy if exists "Only users can insert products" on public.product;
drop policy if exists "Only users can update products" on public.product;
drop policy if exists "Only users can delete products" on public.product;
create policy "Admins insert products" on public.product for insert to authenticated with check (public.is_admin());
create policy "Admins update products" on public.product for update to authenticated using (public.is_admin()) with check (public.is_admin());
create policy "Admins delete products" on public.product for delete to authenticated using (public.is_admin());

-- A08: private bucket, authenticated reads, and owner/admin object controls.
insert into storage.buckets (id, name, public)
values ('inventory-images', 'inventory-images', false)
on conflict (id) do update set public = false;

drop policy if exists "Public read inventory-images" on storage.objects;
drop policy if exists "Auth upload inventory-images" on storage.objects;
drop policy if exists "Auth delete inventory-images" on storage.objects;
drop policy if exists "Authenticated read inventory-images" on storage.objects;
drop policy if exists "Admins upload inventory-images" on storage.objects;
drop policy if exists "Admins delete inventory-images" on storage.objects;

create policy "Authenticated read inventory-images"
on storage.objects for select to authenticated
using (bucket_id = 'inventory-images');
create policy "Admins upload inventory-images"
on storage.objects for insert to authenticated
with check (bucket_id = 'inventory-images' and public.is_admin());
create policy "Admins delete inventory-images"
on storage.objects for delete to authenticated
using (bucket_id = 'inventory-images' and public.is_admin());
