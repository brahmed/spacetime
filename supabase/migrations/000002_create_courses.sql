create table public.courses (
  id                  uuid primary key default gen_random_uuid(),
  name                text not null,
  discipline          text,
  room                text,
  teacher_id          uuid references public.profiles (id) on delete set null,
  recurrence_days     int[] not null,       -- ISO weekday: 1=Mon … 7=Sun
  recurrence_time     time not null,        -- local time, e.g. 18:00
  recurrence_ends_at  date,                 -- null = open-ended
  created_at          timestamptz not null default now()
);

comment on table public.courses is 'Recurring class definitions. Sessions are generated from recurrence fields.';
comment on column public.courses.recurrence_days is 'Array of ISO weekday numbers (1=Monday, 7=Sunday).';
comment on column public.courses.recurrence_time is 'Time of day for each session.';
