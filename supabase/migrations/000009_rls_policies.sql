-- ─── Helper: current user role ────────────────────────────────────────────────
create or replace function public.get_user_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select role from public.profiles where id = auth.uid();
$$;

-- ─── Enable RLS on every table ────────────────────────────────────────────────
alter table public.profiles       enable row level security;
alter table public.courses        enable row level security;
alter table public.sessions       enable row level security;
alter table public.enrollments    enable row level security;
alter table public.attendance     enable row level security;
alter table public.announcements  enable row level security;
alter table public.notifications  enable row level security;
alter table public.device_tokens  enable row level security;

-- ─── profiles ─────────────────────────────────────────────────────────────────
-- Any authenticated user can read any profile (needed for teacher name display)
create policy "profiles: authenticated read"
  on public.profiles for select
  to authenticated
  using (true);

-- User can update their own profile
create policy "profiles: self update"
  on public.profiles for update
  to authenticated
  using (id = auth.uid())
  with check (id = auth.uid());

-- Admin full access (insert done by Edge Function using service role, but policy for completeness)
create policy "profiles: admin full access"
  on public.profiles for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── courses ──────────────────────────────────────────────────────────────────
-- Students and teachers can read all courses
create policy "courses: authenticated read"
  on public.courses for select
  to authenticated
  using (true);

-- Admin full access
create policy "courses: admin full access"
  on public.courses for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── sessions ─────────────────────────────────────────────────────────────────
-- All authenticated users can read sessions
create policy "sessions: authenticated read"
  on public.sessions for select
  to authenticated
  using (true);

-- Teachers can update sessions of their courses
create policy "sessions: teacher update own courses"
  on public.sessions for update
  to authenticated
  using (
    public.get_user_role() = 'teacher'
    and exists (
      select 1 from public.courses c
      where c.id = sessions.course_id
        and c.teacher_id = auth.uid()
    )
  )
  with check (
    public.get_user_role() = 'teacher'
    and exists (
      select 1 from public.courses c
      where c.id = sessions.course_id
        and c.teacher_id = auth.uid()
    )
  );

-- Admin full access
create policy "sessions: admin full access"
  on public.sessions for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── enrollments ──────────────────────────────────────────────────────────────
-- Students read their own enrollments
create policy "enrollments: student read own"
  on public.enrollments for select
  to authenticated
  using (student_id = auth.uid());

-- Teachers read enrollments for their courses
create policy "enrollments: teacher read own courses"
  on public.enrollments for select
  to authenticated
  using (
    public.get_user_role() = 'teacher'
    and exists (
      select 1 from public.courses c
      where c.id = enrollments.course_id
        and c.teacher_id = auth.uid()
    )
  );

-- Admin full access
create policy "enrollments: admin full access"
  on public.enrollments for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── attendance ───────────────────────────────────────────────────────────────
-- Students read and update their own attendance
create policy "attendance: student read own"
  on public.attendance for select
  to authenticated
  using (student_id = auth.uid());

create policy "attendance: student update own"
  on public.attendance for update
  to authenticated
  using (student_id = auth.uid())
  with check (student_id = auth.uid());

-- Teachers read attendance for sessions of their courses
create policy "attendance: teacher read own sessions"
  on public.attendance for select
  to authenticated
  using (
    public.get_user_role() = 'teacher'
    and exists (
      select 1 from public.sessions s
      join public.courses c on c.id = s.course_id
      where s.id = attendance.session_id
        and c.teacher_id = auth.uid()
    )
  );

-- Admin full access
create policy "attendance: admin full access"
  on public.attendance for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── announcements ────────────────────────────────────────────────────────────
-- All authenticated users can read announcements targeted at them
create policy "announcements: read relevant"
  on public.announcements for select
  to authenticated
  using (
    target_role = 'all'
    or target_role = public.get_user_role()
    or public.get_user_role() = 'admin'
  );

-- Admin full access
create policy "announcements: admin full access"
  on public.announcements for all
  to authenticated
  using (public.get_user_role() = 'admin')
  with check (public.get_user_role() = 'admin');

-- ─── notifications ────────────────────────────────────────────────────────────
-- Users read and update their own notifications
create policy "notifications: user read own"
  on public.notifications for select
  to authenticated
  using (user_id = auth.uid());

create policy "notifications: user update own"
  on public.notifications for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

-- ─── device_tokens ────────────────────────────────────────────────────────────
-- Users manage their own device tokens
create policy "device_tokens: user manage own"
  on public.device_tokens for all
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());
