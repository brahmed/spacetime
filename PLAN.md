# SpaceTime — Implementation Plan

## Overview

SpaceTime is a class management platform for arts & culture centers. It replaces WhatsApp-based coordination with a structured mobile app (students + teachers) and a web back office (admin).

**Portfolio project · Open source · Fictional seed data only**

---

## Stack

| Concern | Decision |
|---|---|
| Apps | Flutter mobile (iOS/Android) + Flutter Web backoffice |
| Backend | Supabase (Auth, DB, Realtime, Storage, Edge Functions) |
| State | BLoC — calls repositories directly, no use cases |
| Navigation | go_router with role-based redirect |
| Notifications | FCM — fully wired up |
| Serialization | json_serializable, fieldRename: FieldRename.snake |
| Architecture | Clean Architecture + feature-first |
| Repo | Monorepo — one GitHub repo |

---

## Target Directory Structure

```
spacetime/
├── apps/
│   ├── mobile/                  # Flutter iOS/Android
│   └── backoffice/              # Flutter Web
├── packages/
│   ├── core/                    # Pure Dart: models, enums, exceptions
│   ├── ui/                      # Flutter: design system, shared widgets
│   └── supabase/                # Dart: Supabase client + repositories
├── supabase/
│   ├── migrations/              # SQL migration files
│   ├── functions/               # Edge Functions (Deno TypeScript)
│   │   ├── _shared/
│   │   ├── create-user/
│   │   ├── generate-sessions/
│   │   ├── on-session-created/
│   │   ├── on-session-cancelled/
│   │   ├── send-reminders/
│   │   └── send-announcement/
│   └── seed.sql
├── PLAN.md
├── PROGRESS.md
├── .gitignore
└── README.md
```

---

## Phase 1 — Monorepo Scaffold & Shared Packages

**Goal:** Full directory tree, three shared packages, two Flutter apps — all wired together and analyzing clean.

### Steps

- 1.1 Create monorepo directory tree
- 1.2 Create `packages/core` — pure Dart: models, enums, exceptions, utils
- 1.3 Create `packages/supabase` — Supabase client + all repositories
- 1.4 Create `packages/ui` — design system: AppColors, AppTheme, Sizes, shared widgets
- 1.5 Create `apps/mobile` and `apps/backoffice` with feature folder structure
- 1.6 Create root `.gitignore` and `README.md`

### Deliverables
- `packages/core` — Profile, Course, Session, Enrollment, Attendance, Announcement, AppNotification models + all enums
- `packages/supabase` — 9 repositories (auth, course, session, enrollment, attendance, announcement, notification, device_token, profile)
- `packages/ui` — AppColors ThemeExtension, AppTheme.dark, Sizes constants, 5 shared widgets
- `apps/mobile` + `apps/backoffice` — skeleton with feature folders, main.dart, app.dart, app_router.dart
- `flutter analyze` passes with zero errors on all packages and apps

---

## Phase 2 — Supabase Backend

**Goal:** All migrations applied, all Edge Functions deployed, seed data in place. Backend fully operational before any UI is built.

### Steps

- 2.1 Write 11 SQL migration files
- 2.2 Write `supabase/seed.sql` with fictional data
- 2.3 Implement 6 Edge Functions in Deno TypeScript
- 2.4 Deploy via Supabase CLI

### Migration Files

| File | Contents |
|---|---|
| `000001_create_profiles.sql` | profiles table |
| `000002_create_courses.sql` | courses table with recurrence fields |
| `000003_create_sessions.sql` | sessions table + indexes |
| `000004_create_enrollments.sql` | enrollments table |
| `000005_create_attendance.sql` | attendance table + indexes |
| `000006_create_announcements.sql` | announcements table |
| `000007_create_notifications.sql` | notifications table + index |
| `000008_create_device_tokens.sql` | device_tokens table |
| `000009_rls_policies.sql` | RLS enable + all policies + helper function |
| `000010_db_webhooks.sql` | Webhook documentation (configured in Dashboard) |
| `000011_cron_jobs.sql` | pg_cron for send-reminders at 8:00 + 14:00 UTC |

### Edge Functions

| Function | Trigger | Purpose |
|---|---|---|
| `create-user` | HTTP POST from backoffice | Create auth user + profile via Admin API |
| `generate-sessions` | HTTP POST (on course create or manual) | Bulk-insert 4 weeks of sessions from recurrence rule |
| `on-session-created` | DB Webhook — sessions INSERT | Create pending attendance rows for enrolled students |
| `on-session-cancelled` | DB Webhook — sessions UPDATE (status→cancelled) | Send FCM cancellation notification to affected students |
| `send-reminders` | Cron 8:00 + 14:00 UTC | Notify pending students for today's sessions, flip reminder_sent |
| `send-announcement` | HTTP POST from backoffice | Fan out FCM notification to users by target_role |

### Deliverables
- All migrations applied to Supabase project
- Seed data visible in Supabase Dashboard
- All 6 Edge Functions deployed and testable via curl
- FCM_SERVER_KEY secret set

---

## Phase 2.5 — Localisation

**Goal:** Full i18n support in both apps — English, French, Arabic (RTL). No hardcoded strings anywhere in the UI.

### Steps

- 2.5.1 Add `flutter_localizations` + `intl` to `packages/ui` and both apps
- 2.5.2 Write ARB files for `en`, `fr`, `ar` in `packages/ui/lib/l10n/`
- 2.5.3 Configure `flutter gen-l10n` via `l10n.yaml` in `packages/ui`
- 2.5.4 Export `AppLocalizations` and `L10nExtension` (`context.l10n`) from `packages/ui`
- 2.5.5 Wire `localizationsDelegates` + `supportedLocales` into both `MaterialApp.router`s
- 2.5.6 Replace all hardcoded UI strings with `context.l10n.*`

### Conventions

- All ARB files live in `packages/ui/lib/l10n/` — single source for both apps
- Generated files go to `packages/ui/lib/src/l10n/` — never edit manually
- Access via `context.l10n` extension — never `AppLocalizations.of(context)` directly
- BLoC error strings stay in English (no BuildContext in BLoC) — map to l10n in UI listeners
- Add new strings to all three ARB files simultaneously
- RTL layout handled automatically by Flutter for `ar` locale

### Deliverables
- Both apps switch language/RTL automatically based on device locale
- All visible strings translated in all 3 languages
- `flutter analyze` clean

---

## Phase 3 — Design System & Navigation Shell

**Goal:** Full theme applied in both apps, routing skeleton working, Supabase auth initialized, blank authenticated screen per role.

### Steps

- 3.1 Verify AppColors, AppTheme, Sizes in `packages/ui`
- 3.2 Implement AuthBloc in both apps (listens to Supabase auth stream)
- 3.3 Wire go_router with full role-based redirect logic
- 3.4 Login screen (shared layout used by both apps)
- 3.5 Skeleton home screen per role (student, teacher, admin)

### AuthBloc

```
Events: AuthStarted | AuthLoggedIn | AuthLoggedOut
States: AuthInitial | AuthAuthenticated(profile) | AuthUnauthenticated
```

### Router Redirect Logic (mobile)

```
Not logged in → /login
Logged in as student → /student/home
Logged in as teacher → /teacher/home
```

### Deliverables
- Both apps launch to login screen with correct dark neon theme
- After login, role-based redirect works
- `Theme.of(context).appColors.accent` resolves correctly

---

## Phase 4 — Mobile App: Student Flows

**Goal:** Fully working student experience end to end.

### Screens & Features

| Screen | Key functionality |
|---|---|
| Login | Email + password, AuthBloc, error handling |
| Home | Next session card, weekly schedule strip, announcements |
| Schedule | Full list of enrolled sessions grouped by week |
| Session Detail | Session info, confirm / cancel attendance |
| Notifications | List of notifications, mark as read |
| Profile | Avatar, name, logout |

### FCM Setup

- `flutterfire configure` → generates `firebase_options.dart`
- Request notification permission on first launch
- Save device token to `device_tokens` table via DeviceTokenRepository
- `flutter_local_notifications` for foreground display
- Background message handler in `main.dart`

### Deliverables
- Student can log in, view schedule, confirm/cancel attendance
- Student receives push notifications (cancellation, reminder, announcement)
- All BLoC states handled (loading, success, error)

---

## Phase 5 — Mobile App: Teacher Flows

**Goal:** Fully working teacher experience.

### Screens & Features

| Screen | Key functionality |
|---|---|
| Home | Today's sessions, attendance count per session |
| Schedule | Full session list |
| Session Detail | Live attendance list (Supabase Realtime), cancel session, edit session |
| Profile | Settings, logout |

### Key Behaviours

- Realtime attendance updates via `supabase.from('attendance').stream(...)`
- Cancel session → DB Webhook → on-session-cancelled Edge Function → FCM to students
- Edit session → bottom sheet → update room/time on single session row

### Deliverables
- Teacher can view and manage sessions
- Attendance list updates in realtime without refresh
- Cancel session triggers FCM notification to enrolled students

---

## Phase 6 — Backoffice Web App

**Goal:** Fully working admin experience.

### Screens & Features

| Screen | Key functionality |
|---|---|
| Login | Same auth flow as mobile |
| Dashboard | Stats cards (students, teachers, courses, today's sessions) |
| Courses | DataTable list, create/edit drawer, "Generate next 4 weeks" button |
| Sessions | Per-course session list, edit single, cancel single, cancel all future |
| Students | DataTable, create account (calls create-user Edge Function), enroll/unenroll |
| Teachers | DataTable, create account, assign to course |
| Announcements | Compose form, target role selector, send, history list |
| Settings | Admin profile |

### Layout

- Persistent left sidebar navigation
- Main content area
- Responsive — adapts to different web window sizes

### Deliverables
- Admin can create user accounts (student + teacher)
- Admin can create courses and generate sessions
- Admin can send announcements with FCM fan-out
- All CRUD operations for courses, sessions, students, teachers

---

## Data Model (Final)

### profiles
```sql
id          uuid PRIMARY KEY REFERENCES auth.users
full_name   text
avatar_url  text
role        text CHECK (role IN ('student', 'teacher', 'admin'))
created_at  timestamptz DEFAULT now()
```

### courses
```sql
id                 uuid PRIMARY KEY DEFAULT gen_random_uuid()
name               text NOT NULL
discipline         text
room               text
teacher_id         uuid REFERENCES profiles(id)
recurrence_days    int[]        -- [1, 3] = Mon + Wed (ISO weekday)
recurrence_time    time         -- 18:00
recurrence_ends_at date         -- null = open-ended
created_at         timestamptz DEFAULT now()
```

### sessions
```sql
id            uuid PRIMARY KEY DEFAULT gen_random_uuid()
course_id     uuid REFERENCES courses(id)
starts_at     timestamptz NOT NULL
ends_at       timestamptz NOT NULL
status        text CHECK (status IN ('scheduled', 'cancelled')) DEFAULT 'scheduled'
reminder_sent boolean DEFAULT false
created_at    timestamptz DEFAULT now()
```

### enrollments
```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
course_id   uuid REFERENCES courses(id)
student_id  uuid REFERENCES profiles(id)
created_at  timestamptz DEFAULT now()
UNIQUE (course_id, student_id)
```

### attendance
```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
session_id  uuid REFERENCES sessions(id)
student_id  uuid REFERENCES profiles(id)
status      text CHECK (status IN ('confirmed', 'cancelled', 'pending')) DEFAULT 'pending'
updated_at  timestamptz DEFAULT now()
UNIQUE (session_id, student_id)
```

### announcements
```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
title       text NOT NULL
body        text NOT NULL
sent_by     uuid REFERENCES profiles(id)
target_role text CHECK (target_role IN ('all', 'student', 'teacher'))
created_at  timestamptz DEFAULT now()
```

### notifications
```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
user_id     uuid REFERENCES profiles(id)
title       text
body        text
type        text CHECK (type IN ('reminder', 'cancellation', 'announcement'))
read        boolean DEFAULT false
created_at  timestamptz DEFAULT now()
```

### device_tokens
```sql
id          uuid PRIMARY KEY DEFAULT gen_random_uuid()
user_id     uuid REFERENCES profiles(id)
token       text NOT NULL
platform    text CHECK (platform IN ('ios', 'android'))
created_at  timestamptz DEFAULT now()
UNIQUE (user_id, token)
```

---

## Key Business Rules

- Admin creates all user accounts — no self-signup
- Sessions auto-generated for first 4 weeks on course creation
- Admin manually generates next 4 weeks via back office button
- Session editing: edit single · cancel single · cancel all future (no edit-all-future)
- Reminder cron runs at 8:00 and 14:00 UTC daily
- `reminder_sent = true` prevents duplicate notifications
- DB Webhooks trigger Edge Functions for session create/cancel events
- Supabase Realtime used only for teacher's live attendance view
