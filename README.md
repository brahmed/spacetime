# SpaceTime

A class management and communication platform for arts & culture centers.

SpaceTime replaces WhatsApp-based coordination with a structured platform for students, teachers, and admins — built with Flutter and Supabase.

> Portfolio project · Open source · Fictional seed data only

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile App | Flutter (iOS & Android) |
| Back Office | Flutter Web |
| Backend | Supabase (Auth, DB, Realtime, Storage, Edge Functions) |
| State Management | BLoC |
| Navigation | go_router |
| Notifications | Firebase Cloud Messaging (FCM) |

---

## Project Structure

```
spacetime/
├── apps/
│   ├── mobile/          # Flutter mobile app (student & teacher)
│   └── backoffice/      # Flutter web app (admin)
├── packages/
│   ├── core/            # Shared models, enums, exceptions, utilities
│   ├── ui/              # Shared design system & components
│   └── supabase/        # Supabase client, repositories
├── supabase/
│   ├── migrations/      # SQL migration files
│   ├── functions/       # Supabase Edge Functions (Deno/TypeScript)
│   └── seed.sql         # Fictional seed data
└── README.md
```

---

## Setup

> Full setup instructions coming soon.

### Prerequisites

- Flutter SDK
- Supabase CLI
- Firebase project (for push notifications)

### Run mobile app

```bash
cd apps/mobile
flutter run --dart-define-from-file=.env.json
```

### Run back office

```bash
cd apps/backoffice
flutter run -d chrome --dart-define-from-file=.env.json
```

---

## User Roles

| Role | Platform |
|---|---|
| `student` | Mobile App |
| `teacher` | Mobile App |
| `admin` | Web Back Office |

---

## Design

Dark neon aesthetic — black canvas, electric yellow as the primary action color.

Inspired by Linear (precision) and Duolingo (playful feedback).
