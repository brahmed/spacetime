create table public.sessions (
  id             uuid primary key default gen_random_uuid(),
  course_id      uuid not null references public.courses (id) on delete cascade,
  starts_at      timestamptz not null,
  ends_at        timestamptz not null,
  status         text not null check (status in ('scheduled', 'cancelled')) default 'scheduled',
  reminder_sent  boolean not null default false,
  created_at     timestamptz not null default now()
);

create index sessions_course_id_idx   on public.sessions (course_id);
create index sessions_starts_at_idx   on public.sessions (starts_at);
create index sessions_status_idx      on public.sessions (status);

comment on table public.sessions is 'Individual class occurrences generated from a course recurrence rule.';
comment on column public.sessions.reminder_sent is 'Flipped to true by send-reminders Edge Function to prevent duplicate notifications.';
