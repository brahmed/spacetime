create table public.announcements (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  body         text not null,
  sent_by      uuid references public.profiles (id) on delete set null,
  target_role  text not null check (target_role in ('all', 'student', 'teacher')),
  created_at   timestamptz not null default now()
);

comment on table public.announcements is 'Admin-authored broadcast messages sent via FCM to a target role group.';
