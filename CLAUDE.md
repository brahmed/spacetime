# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

SpaceTime is a class management platform for arts & culture centers. It replaces WhatsApp-based coordination with a structured mobile app (students + teachers) and a web back office (admin). Portfolio project — fictional seed data only, no real user data.

## Monorepo Structure

```
spacetime/
├── apps/
│   ├── mobile/       # Flutter iOS/Android — students & teachers
│   └── backoffice/   # Flutter Web — admin only
├── packages/
│   ├── core/         # Pure Dart — models, enums, exceptions, utils
│   ├── ui/           # Flutter — AppTheme, AppColors, Sizes, shared widgets
│   └── supabase/     # Dart — SupabaseConfig + 9 repositories
└── supabase/
    ├── migrations/   # SQL migration files
    └── functions/    # Edge Functions (Deno TypeScript)
```

## Commands

All commands must be run from the relevant app or package directory.

```bash
# Mobile app
cd apps/mobile
flutter run --dart-define-from-file=.env.json
flutter analyze lib/
flutter test

# Backoffice
cd apps/backoffice
flutter run -d chrome --dart-define-from-file=.env.json
flutter analyze lib/

# packages/core — after editing models
cd packages/core
dart run build_runner build --delete-conflicting-outputs
dart analyze lib/

# packages/ui
cd packages/ui
flutter analyze lib/

# packages/supabase
cd packages/supabase
dart analyze lib/

# Supabase backend
supabase db push                          # apply migrations
supabase functions deploy <name>          # deploy a single Edge Function
supabase functions serve                  # serve Edge Functions locally
supabase secrets set FCM_SERVER_KEY=<key>
```

## Environment Variables

Both apps use `--dart-define-from-file=.env.json` (gitignored). Create the file before running:

```json
{
  "SUPABASE_URL": "...",
  "SUPABASE_ANON_KEY": "...",
  "SUPABASE_EDGE_BASE_URL": "..."
}
```

Values accessed in code via `SupabaseConfig` in `packages/supabase/lib/src/supabase_config.dart`.

## Architecture

**Clean Architecture + feature-first.** Each feature has three layers:
- `data/` — repository implementation, Supabase calls
- `domain/` — entities (from `packages/core`), repository interface
- `presentation/` — BLoC, screens, widgets

**BLoC calls repositories directly** — no use case classes.

**Shared code lives in packages:**
- Models and enums → `packages/core`
- UI components and theme → `packages/ui`
- Supabase queries → `packages/supabase`

Only move code to `packages/` when it is used by both apps.

## Key Decisions

| Concern | Decision |
|---|---|
| State management | BLoC (`flutter_bloc`) |
| Navigation | `go_router` with role-based redirect |
| Serialization | `json_serializable`, `fieldRename: FieldRename.snake` |
| Notifications | FCM fully wired — `firebase_messaging` |
| Colors | `AppColors` ThemeExtension — never hardcode colors |
| Spacing | `Sizes` constants + `gapH*`/`gapW*` — never hardcode sizes |
| Logging | `dart:developer` `log()` — never `print()` |

## User Roles & Routing

- `student` → mobile app, routes under `/student/`
- `teacher` → mobile app, routes under `/teacher/`
- `admin` → backoffice web app only

After login, `go_router` redirects based on `profiles.role` fetched from Supabase.

## Data Layer

All Supabase access goes through repositories in `packages/supabase/lib/src/repositories/`. The `Session` type clashes with `supabase_flutter` — always import with `hide Session` in the supabase package:

```dart
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
```

Generated `.g.dart` files are committed — run `build_runner` after editing any model in `packages/core/lib/src/models/`.

## Commit Messages

Never reference Claude, Claude Code, or Anthropic in commit messages. No co-authored-by lines.

## Further Reference

- `rules/rules.md` — full coding standards, patterns, TDD discipline, checklist
- `PLAN.md` — phased implementation plan (local only, not in git)
- `PROGRESS.md` — task-by-task progress tracker (local only, not in git)
