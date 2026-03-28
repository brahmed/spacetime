create table public.device_tokens (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  token       text not null,
  platform    text not null check (platform in ('ios', 'android')),
  created_at  timestamptz not null default now(),
  unique (user_id, token)
);

create index device_tokens_user_id_idx on public.device_tokens (user_id);

comment on table public.device_tokens is 'FCM device tokens registered by the mobile app. Unique per (user, token) pair.';
