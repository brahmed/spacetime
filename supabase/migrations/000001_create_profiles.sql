create table public.profiles (
  id         uuid primary key references auth.users on delete cascade,
  full_name  text not null,
  avatar_url text,
  role       text not null check (role in ('student', 'teacher', 'admin')),
  created_at timestamptz not null default now()
);

comment on table public.profiles is 'One row per auth user — stores display name and role.';
