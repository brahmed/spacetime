create table public.attendance (
  id          uuid primary key default gen_random_uuid(),
  session_id  uuid not null references public.sessions (id) on delete cascade,
  student_id  uuid not null references public.profiles (id) on delete cascade,
  status      text not null check (status in ('confirmed', 'cancelled', 'pending')) default 'pending',
  updated_at  timestamptz not null default now(),
  unique (session_id, student_id)
);

create index attendance_session_id_idx  on public.attendance (session_id);
create index attendance_student_id_idx  on public.attendance (student_id);
create index attendance_status_idx      on public.attendance (status);

comment on table public.attendance is 'Per-session attendance record for each enrolled student. Created by on-session-created Edge Function.';
