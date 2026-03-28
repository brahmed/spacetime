create table public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  title       text not null,
  body        text not null,
  type        text not null check (type in ('reminder', 'cancellation', 'announcement')),
  read        boolean not null default false,
  created_at  timestamptz not null default now()
);

create index notifications_user_id_idx    on public.notifications (user_id);
create index notifications_read_idx       on public.notifications (user_id, read) where read = false;

comment on table public.notifications is 'In-app notification inbox. Each FCM push also creates one row here.';
