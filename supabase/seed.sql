-- ─── SpaceTime seed data ──────────────────────────────────────────────────────
-- All data is entirely fictional. No real users or personal data.
-- Passwords are all: SpaceTime2024!
-- UUIDs are fixed so seed is idempotent when re-applied.

-- ─── Auth users ───────────────────────────────────────────────────────────────
-- Insert auth users using Supabase's admin API in production.
-- For local dev, the Supabase CLI seeds auth.users directly.

insert into auth.users (
  id, instance_id, aud, role, email, encrypted_password,
  email_confirmed_at, created_at, updated_at,
  raw_app_meta_data, raw_user_meta_data, is_super_admin
)
values
  -- Admins
  (
    '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'admin@spacetime.art',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  -- Teachers
  (
    '00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'marie.dupont@spacetime.art',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000012', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'carlos.ruiz@spacetime.art',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000013', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'aiko.tanaka@spacetime.art',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  -- Students
  (
    '00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'sofia.martin@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'luca.ferrari@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'amara.ndiaye@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'noah.schmidt@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000025', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'isabela.costa@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000026', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'yusuf.ali@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000027', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'chloe.bernard@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  ),
  (
    '00000000-0000-0000-0000-000000000028', '00000000-0000-0000-0000-000000000000',
    'authenticated', 'authenticated', 'daniel.kim@example.com',
    crypt('SpaceTime2024!', gen_salt('bf')),
    now(), now(), now(),
    '{"provider":"email","providers":["email"]}'::jsonb, '{}'::jsonb, false
  )
on conflict (id) do nothing;

-- ─── Profiles ─────────────────────────────────────────────────────────────────
insert into public.profiles (id, full_name, role, created_at)
values
  -- Admin
  ('00000000-0000-0000-0000-000000000001', 'Admin SpaceTime',   'admin',   now() - interval '6 months'),
  -- Teachers
  ('00000000-0000-0000-0000-000000000011', 'Marie Dupont',      'teacher', now() - interval '5 months'),
  ('00000000-0000-0000-0000-000000000012', 'Carlos Ruiz',       'teacher', now() - interval '5 months'),
  ('00000000-0000-0000-0000-000000000013', 'Aiko Tanaka',       'teacher', now() - interval '4 months'),
  -- Students
  ('00000000-0000-0000-0000-000000000021', 'Sofia Martin',      'student', now() - interval '3 months'),
  ('00000000-0000-0000-0000-000000000022', 'Luca Ferrari',      'student', now() - interval '3 months'),
  ('00000000-0000-0000-0000-000000000023', 'Amara Ndiaye',      'student', now() - interval '2 months'),
  ('00000000-0000-0000-0000-000000000024', 'Noah Schmidt',      'student', now() - interval '2 months'),
  ('00000000-0000-0000-0000-000000000025', 'Isabela Costa',     'student', now() - interval '2 months'),
  ('00000000-0000-0000-0000-000000000026', 'Yusuf Ali',         'student', now() - interval '1 month'),
  ('00000000-0000-0000-0000-000000000027', 'Chloé Bernard',     'student', now() - interval '1 month'),
  ('00000000-0000-0000-0000-000000000028', 'Daniel Kim',        'student', now() - interval '3 weeks')
on conflict (id) do nothing;

-- ─── Courses ──────────────────────────────────────────────────────────────────
insert into public.courses (id, name, discipline, room, teacher_id, recurrence_days, recurrence_time, created_at)
values
  (
    '10000000-0000-0000-0000-000000000001',
    'Contemporary Dance — Beginners',
    'Dance', 'Studio A',
    '00000000-0000-0000-0000-000000000011',  -- Marie Dupont
    array[1, 3],   -- Monday + Wednesday
    '18:30',
    now() - interval '3 months'
  ),
  (
    '10000000-0000-0000-0000-000000000002',
    'Contemporary Dance — Advanced',
    'Dance', 'Studio A',
    '00000000-0000-0000-0000-000000000011',  -- Marie Dupont
    array[2, 4],   -- Tuesday + Thursday
    '19:00',
    now() - interval '3 months'
  ),
  (
    '10000000-0000-0000-0000-000000000003',
    'Classical Guitar — Level 1',
    'Music', 'Room 3',
    '00000000-0000-0000-0000-000000000012',  -- Carlos Ruiz
    array[2, 5],   -- Tuesday + Friday
    '17:00',
    now() - interval '2 months'
  ),
  (
    '10000000-0000-0000-0000-000000000004',
    'Classical Guitar — Level 2',
    'Music', 'Room 3',
    '00000000-0000-0000-0000-000000000012',  -- Carlos Ruiz
    array[3],      -- Wednesday only
    '18:00',
    now() - interval '2 months'
  ),
  (
    '10000000-0000-0000-0000-000000000005',
    'Ikebana & Floral Arts',
    'Visual Arts', 'Workshop',
    '00000000-0000-0000-0000-000000000013',  -- Aiko Tanaka
    array[6],      -- Saturday
    '10:00',
    now() - interval '1 month'
  )
on conflict (id) do nothing;

-- ─── Sessions (next 4 weeks from today, approximated) ─────────────────────────
-- Course 1: Contemporary Dance Beginners — Mon + Wed 18:30 (1h30)
insert into public.sessions (id, course_id, starts_at, ends_at, status, created_at)
values
  ('20000000-0000-0000-0000-000000000101', '10000000-0000-0000-0000-000000000001', now() + interval '0 days 18 hours 30 minutes', now() + interval '0 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000102', '10000000-0000-0000-0000-000000000001', now() + interval '2 days 18 hours 30 minutes', now() + interval '2 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000103', '10000000-0000-0000-0000-000000000001', now() + interval '7 days 18 hours 30 minutes', now() + interval '7 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000104', '10000000-0000-0000-0000-000000000001', now() + interval '9 days 18 hours 30 minutes', now() + interval '9 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000105', '10000000-0000-0000-0000-000000000001', now() + interval '14 days 18 hours 30 minutes', now() + interval '14 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000106', '10000000-0000-0000-0000-000000000001', now() + interval '16 days 18 hours 30 minutes', now() + interval '16 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000107', '10000000-0000-0000-0000-000000000001', now() + interval '21 days 18 hours 30 minutes', now() + interval '21 days 20 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000108', '10000000-0000-0000-0000-000000000001', now() + interval '23 days 18 hours 30 minutes', now() + interval '23 days 20 hours', 'scheduled', now()),
  -- one past session
  ('20000000-0000-0000-0000-000000000109', '10000000-0000-0000-0000-000000000001', now() - interval '5 days 5 hours 30 minutes', now() - interval '5 days 4 hours', 'scheduled', now() - interval '5 days')
on conflict (id) do nothing;

-- Course 2: Contemporary Dance Advanced — Tue + Thu 19:00 (1h30)
insert into public.sessions (id, course_id, starts_at, ends_at, status, created_at)
values
  ('20000000-0000-0000-0000-000000000201', '10000000-0000-0000-0000-000000000002', now() + interval '1 days 19 hours', now() + interval '1 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000202', '10000000-0000-0000-0000-000000000002', now() + interval '3 days 19 hours', now() + interval '3 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000203', '10000000-0000-0000-0000-000000000002', now() + interval '8 days 19 hours', now() + interval '8 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000204', '10000000-0000-0000-0000-000000000002', now() + interval '10 days 19 hours', now() + interval '10 days 20 hours 30 minutes', 'cancelled', now()),
  ('20000000-0000-0000-0000-000000000205', '10000000-0000-0000-0000-000000000002', now() + interval '15 days 19 hours', now() + interval '15 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000206', '10000000-0000-0000-0000-000000000002', now() + interval '17 days 19 hours', now() + interval '17 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000207', '10000000-0000-0000-0000-000000000002', now() + interval '22 days 19 hours', now() + interval '22 days 20 hours 30 minutes', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000208', '10000000-0000-0000-0000-000000000002', now() + interval '24 days 19 hours', now() + interval '24 days 20 hours 30 minutes', 'scheduled', now())
on conflict (id) do nothing;

-- Course 3: Classical Guitar Level 1 — Tue + Fri 17:00 (1h)
insert into public.sessions (id, course_id, starts_at, ends_at, status, created_at)
values
  ('20000000-0000-0000-0000-000000000301', '10000000-0000-0000-0000-000000000003', now() + interval '1 days 17 hours', now() + interval '1 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000302', '10000000-0000-0000-0000-000000000003', now() + interval '4 days 17 hours', now() + interval '4 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000303', '10000000-0000-0000-0000-000000000003', now() + interval '8 days 17 hours', now() + interval '8 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000304', '10000000-0000-0000-0000-000000000003', now() + interval '11 days 17 hours', now() + interval '11 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000305', '10000000-0000-0000-0000-000000000003', now() + interval '15 days 17 hours', now() + interval '15 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000306', '10000000-0000-0000-0000-000000000003', now() + interval '18 days 17 hours', now() + interval '18 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000307', '10000000-0000-0000-0000-000000000003', now() + interval '22 days 17 hours', now() + interval '22 days 18 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000308', '10000000-0000-0000-0000-000000000003', now() + interval '25 days 17 hours', now() + interval '25 days 18 hours', 'scheduled', now())
on conflict (id) do nothing;

-- Course 5: Ikebana — Saturday 10:00 (2h)
insert into public.sessions (id, course_id, starts_at, ends_at, status, created_at)
values
  ('20000000-0000-0000-0000-000000000501', '10000000-0000-0000-0000-000000000005', now() + interval '5 days 10 hours', now() + interval '5 days 12 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000502', '10000000-0000-0000-0000-000000000005', now() + interval '12 days 10 hours', now() + interval '12 days 12 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000503', '10000000-0000-0000-0000-000000000005', now() + interval '19 days 10 hours', now() + interval '19 days 12 hours', 'scheduled', now()),
  ('20000000-0000-0000-0000-000000000504', '10000000-0000-0000-0000-000000000005', now() + interval '26 days 10 hours', now() + interval '26 days 12 hours', 'scheduled', now())
on conflict (id) do nothing;

-- ─── Enrollments ──────────────────────────────────────────────────────────────
insert into public.enrollments (course_id, student_id)
values
  -- Contemporary Dance Beginners (course 1)
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000021'),  -- Sofia
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000022'),  -- Luca
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000023'),  -- Amara
  ('10000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000027'),  -- Chloé
  -- Contemporary Dance Advanced (course 2)
  ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000024'),  -- Noah
  ('10000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000025'),  -- Isabela
  -- Classical Guitar Level 1 (course 3)
  ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000022'),  -- Luca
  ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000026'),  -- Yusuf
  ('10000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000028'),  -- Daniel
  -- Ikebana (course 5)
  ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000021'),  -- Sofia
  ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000023'),  -- Amara
  ('10000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-000000000027')   -- Chloé
on conflict (course_id, student_id) do nothing;

-- ─── Attendance (for sessions of course 1) ────────────────────────────────────
-- Past session — varied statuses
insert into public.attendance (session_id, student_id, status, updated_at)
values
  ('20000000-0000-0000-0000-000000000109', '00000000-0000-0000-0000-000000000021', 'confirmed', now() - interval '5 days'),
  ('20000000-0000-0000-0000-000000000109', '00000000-0000-0000-0000-000000000022', 'cancelled',  now() - interval '5 days'),
  ('20000000-0000-0000-0000-000000000109', '00000000-0000-0000-0000-000000000023', 'confirmed', now() - interval '5 days'),
  ('20000000-0000-0000-0000-000000000109', '00000000-0000-0000-0000-000000000027', 'pending',   now() - interval '5 days'),
  -- Upcoming sessions — all pending
  ('20000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000021', 'pending', now()),
  ('20000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000022', 'pending', now()),
  ('20000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000023', 'pending', now()),
  ('20000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000027', 'pending', now())
on conflict (session_id, student_id) do nothing;

-- ─── Announcements ────────────────────────────────────────────────────────────
insert into public.announcements (id, title, body, sent_by, target_role, created_at)
values
  (
    'a0000000-0000-0000-0000-000000000001',
    'Welcome to SpaceTime!',
    'We are excited to launch our new class management platform. You can now view your schedule, confirm attendance, and receive reminders directly on your phone.',
    '00000000-0000-0000-0000-000000000001',
    'all',
    now() - interval '2 months'
  ),
  (
    'a0000000-0000-0000-0000-000000000002',
    'Spring term begins April 7',
    'All courses resume after the spring break. Please confirm your attendance for the first week of sessions.',
    '00000000-0000-0000-0000-000000000001',
    'student',
    now() - interval '1 week'
  ),
  (
    'a0000000-0000-0000-0000-000000000003',
    'Teacher meeting — Friday 17:00',
    'Reminder: mandatory end-of-term review meeting this Friday at 17:00 in the main hall.',
    '00000000-0000-0000-0000-000000000001',
    'teacher',
    now() - interval '2 days'
  )
on conflict (id) do nothing;

-- ─── Notifications ────────────────────────────────────────────────────────────
insert into public.notifications (user_id, title, body, type, read, created_at)
values
  (
    '00000000-0000-0000-0000-000000000021',  -- Sofia
    'Class reminder',
    'Contemporary Dance — Beginners starts in 2 hours.',
    'reminder', false, now() - interval '2 hours'
  ),
  (
    '00000000-0000-0000-0000-000000000021',  -- Sofia
    'Welcome to SpaceTime!',
    'We are excited to launch our new class management platform.',
    'announcement', true, now() - interval '2 months'
  ),
  (
    '00000000-0000-0000-0000-000000000024',  -- Noah
    'Session cancelled',
    'Contemporary Dance — Advanced on Thursday has been cancelled.',
    'cancellation', false, now() - interval '1 day'
  )
on conflict do nothing;
