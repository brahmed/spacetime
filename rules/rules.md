# Flutter Rules & Guidelines — SpaceTime

Coding standards, patterns, and conventions for all Flutter/Dart code in this project.

---

## Core Philosophy

- **YAGNI / KISS** — Only build what is needed now. Three similar lines is better
  than a premature abstraction. Wait for 3+ uses before abstracting.
- **Make it work → make it right → make it fast** — In that order. Never optimise
  before proving it works.
- **Keep it consistent** — One pattern/library per task across the codebase.
- **Errors must be visible** — No silent failures. Always log with context and
  stack trace. Fail fast, fail loudly.
- **Derive state, don't synchronise it** — Single source of truth. Derive
  everywhere else.

---

## Project Architecture

### Clean Architecture + Feature-First

Organise by feature. Inside each feature, use three layers:

```
lib/
├── features/
│   ├── auth/
│   │   ├── data/           # Supabase calls, DTOs, repository impl
│   │   ├── domain/         # Entities, repository interfaces
│   │   └── presentation/   # BLoC, screens, widgets
│   ├── courses/
│   ├── sessions/
│   ├── attendance/
│   └── announcements/
├── common/
│   ├── widgets/            # Shared widgets (used by 2+ features)
│   └── utils/              # Shared utilities
└── constants/              # App-wide constants (sizes, strings, etc.)
```

- BLoC sits in `presentation/`
- Repository implementations sit in `data/`
- Models/entities sit in `domain/`
- Only put code in `common/` if it is used by 2+ features

### BLoC Rules

- BLoC calls repositories directly — no use case classes unless logic warrants it
- Keep events and states in separate files if they grow large
- Never put business logic in widgets — delegate to BLoC
- Do not emit new states from `build()` — use listeners for side effects

---

## Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Classes | `PascalCase` | `AttendanceBloc` |
| Files | `snake_case` | `attendance_bloc.dart` |
| Variables / functions | `camelCase` | `confirmedAt` |
| Enums | `camelCase` values | `AttendanceStatus.confirmed` |

- Prefer named arguments for functions with 2+ parameters
- No abbreviations (`ctx`, `mgr`, `prefs`) — use full descriptive names
- No vague names (`data`, `info`, `helper`)

---

## Modern Dart (3.7+ / 3.10+)

### Wildcard variables (Dart 3.7+)
```dart
// Use _ multiple times — it's now a true wildcard
itemBuilder: (_, _, _) { ... }
```

### Dot shorthand (Dart 3.10+)
```dart
// When type is inferred, use dot shorthand
final padding = const .all(16.0);
final alignment = .center;
// Do NOT use for Icons: use Icons.info, not .info
```

### Switch expressions
```dart
final label = switch (status) {
  AttendanceStatus.confirmed => 'Confirmed',
  AttendanceStatus.cancelled => 'Cancelled',
  AttendanceStatus.pending   => 'Pending',
};
```

### Records for multiple returns
```dart
({String title, Color color}) statusDisplay() =>
    (title: 'Confirmed', color: AppColors.success);

final (:title, :color) = statusDisplay();
```

### Enhanced enums
```dart
enum AttendanceStatus {
  confirmed('Confirmed', Color(0xFF39FF14)),
  pending('Pending', Color(0xFFFF9500)),
  cancelled('Cancelled', Color(0xFFFF3131));

  const AttendanceStatus(this.label, this.color);
  final String label;
  final Color color;
}
```

---

## Widgets

### Widget classes over build helpers
```dart
// GOOD
class SessionCard extends StatelessWidget { ... }

// BAD
Widget _buildSessionCard() { ... }
```

### Pure build methods
- `build()` is a UI projection from state — no side effects
- No navigation, dialogs, I/O, or logging directly inside `build()`
- Trigger imperative effects from BlocListener, not from build

### Column / Row spacing (Flutter 3.27+)
```dart
Column(
  spacing: 16.0,
  children: [widget1, widget2],
)
```

### Const constructors
- Always use `const` where possible — reduces rebuilds
- Mark widget instantiations as `const` in build methods

### List performance
- Use `ListView.builder` for lists with more than 20 items
- Use `ListView.separated` when separators are needed
- Specify `itemExtent` when items have uniform height

---

## Color API (Flutter 3.27+)

```dart
// DEPRECATED — do not use
color.withOpacity(0.5);
color.opacity;
color.alpha;
color.red / .green / .blue;

// CORRECT
color.withValues(alpha: 0.5);
color.a; // 0.0–1.0
color.r; // 0.0–1.0
color.g; // 0.0–1.0
color.b; // 0.0–1.0
```

---

## Theming

### Use ThemeExtension for custom tokens

SpaceTime's neon palette lives in a `ThemeExtension` — never hardcode colors
directly in widgets.

```dart
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.accent,
    required this.success,
    required this.warning,
    required this.danger,
    required this.surfaceDark,
    required this.borderSubtle,
  });

  final Color accent;       // #FFE500
  final Color success;      // #39FF14
  final Color warning;      // #FF9500
  final Color danger;       // #FF3131
  final Color surfaceDark;  // #111111
  final Color borderSubtle; // #222222

  @override
  AppColors copyWith({...}) { ... }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) { ... }
}

// Clean access via ThemeData extension
extension AppTheme on ThemeData {
  AppColors get appColors => extension<AppColors>()!;
}

// Usage in widget
Theme.of(context).appColors.accent
```

### Constant sizes
```dart
// Define once, use everywhere
abstract final class Sizes {
  static const double p4  = 4;
  static const double p8  = 8;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p24 = 24;
  static const double p32 = 32;

  static const double radiusCard   = 16;
  static const double radiusButton = 12;
}

// Gap widgets
const gapH8  = SizedBox(height: Sizes.p8);
const gapH16 = SizedBox(height: Sizes.p16);
const gapW8  = SizedBox(width: Sizes.p8);
const gapW16 = SizedBox(width: Sizes.p16);
```

---

## State Management (BLoC)

- Use `flutter_bloc` package
- Prefer `BlocBuilder` for rebuilding UI, `BlocListener` for side effects,
  `BlocConsumer` when both are needed
- Dispose BLoC via `BlocProvider` (auto-disposed) — do not dispose manually
  unless created outside the widget tree
- States should be immutable — use `copyWith` pattern
- Use `Equatable` on events and states to prevent duplicate rebuilds

---

## Navigation

- Use `go_router` for all routing
- Configure `redirect` for auth guards (unauthenticated → login, role mismatch
  → correct app flow)
- Use `Navigator.push` only for short-lived, non-deep-linkable screens (dialogs,
  bottom sheets)

---

## Data / Serialization

- Use `json_serializable` + `json_annotation` for all models
- Always set `fieldRename: FieldRename.snake` to match Supabase column names
- Run code generation after model changes:
  ```shell
  dart run build_runner build --delete-conflicting-outputs
  ```

---

## Error Handling

```dart
// GOOD
try {
  await repository.confirmAttendance(sessionId);
} catch (e, st) {
  log('Failed to confirm attendance', error: e, stackTrace: st, name: 'attendance');
  rethrow;
}

// BAD — silent failure
try {
  await repository.confirmAttendance(sessionId);
} catch (_) {}
```

- Catch specific exceptions first, generic last
- Custom exceptions extend a base `AppException`
- Never swallow exceptions — handle or rethrow
- Use meaningful error messages with context, not `'Error occurred'`

---

## Logging

```dart
import 'dart:developer';

// Simple message
log('Session cancelled', name: 'sessions');

// With error
log(
  'Failed to fetch courses',
  name: 'courses.data',
  level: 1000, // SEVERE
  error: e,
  stackTrace: st,
);
```

Log levels: `500` debug · `800` info · `900` warning · `1000` error

Never use `print()`.

---

## Resource Disposal

- Always dispose: controllers, `StreamSubscription`, `Timer`,
  `AnimationController`
- Call `super.dispose()` last
- Use `late final` for resources created in `initState`

```dart
@override
void dispose() {
  _scrollController.dispose();
  _subscription.cancel();
  super.dispose();
}
```

---

## Performance

- Never run network calls or heavy computation inside `build()`
- Use `compute()` for operations > 16ms (JSON parsing, image processing)
- Use `MediaQuery.sizeOf(context)` not `MediaQuery.of(context).size`
- Use `LayoutBuilder` for widget-specific responsive logic

---

## Responsive Design

```dart
// Breakpoints
// mobile  < 600
// tablet  < 1200
// desktop >= 1200

final width = MediaQuery.sizeOf(context).width;
final isDesktop = width >= 1200;
```

---

## Testing

- Follow **Arrange → Act → Assert** (Given → When → Then)
- Unit tests: domain logic, repositories, BLoC
- Widget tests: UI components in isolation
- Integration tests: end-to-end user flows
- Prefer fakes/stubs over mocks
- If mocks are needed, use `mocktail`
- Test behaviour, not implementation details

---

## Composable Widgets

Build features as small, self-contained widgets. Each widget that fetches data or performs mutations owns its own BLoC — a vertical slice through all layers.

### Anti-Pattern: Monolithic Screen

```dart
// ❌ AVOID — one screen owns all data and all state
class SessionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        return BlocBuilder<AttendanceBloc, AttendanceState>(
          builder: (context, attendanceState) {
            // 300+ lines mixing session info, attendance actions — entangled
          },
        );
      },
    );
  }
}
```

### Correct Pattern: Compose from Self-Contained Widgets

```dart
// ✅ GOOD — screen composes small widgets, each owns its own BLoC
class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SessionInfoCard(sessionId: sessionId),
          AttendanceActions(sessionId: sessionId),
        ],
      ),
    );
  }
}

// Each child widget provides its own BLoC
class AttendanceActions extends StatelessWidget {
  const AttendanceActions({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AttendanceBloc(
        repository: context.read<AttendanceRepository>(),
      )..add(LoadAttendance(sessionId)),
      child: _AttendanceActionsView(sessionId: sessionId),
    );
  }
}
```

### When to Extract a Widget

- Reads data → provide its own BLoC
- Performs mutations (confirm, cancel, submit) → own BLoC with events
- Pure presentation (layout, formatting) → `StatelessWidget` with data passed in
- Keep together when two pieces always render from the same BLoC state

---

## Result Modeling: Enum vs Sealed Class

Choose the simplest model that clearly expresses the outcome.

- Use `enum` + optional payload for small, finite status sets (2–4 cases, mostly shared fields)
- Use `sealed class` only when cases carry different data shapes or behaviors

```dart
// ✅ GOOD — simple statuses, use enum + payload
enum SaveStatus { success, cancelled, error }

class SaveResult {
  const SaveResult({required this.status, this.message});
  final SaveStatus status;
  final String? message;
}

// ✅ GOOD — heterogeneous cases, use sealed class
sealed class AuthResult {}
class AuthSuccess extends AuthResult { final String userId; ... }
class AuthRequiresMfa extends AuthResult { final String challengeId; ... }
class AuthFailure extends AuthResult { final int code; ... }
```

**Smell:** if your `sealed class` subclasses only encode status names with no unique data — use `enum` instead.

**SpaceTime:** most BLoC states are simple enough for Equatable classes, not sealed hierarchies. Reserve sealed classes for auth results or flows where cases genuinely diverge.

---

## TDD Discipline

Vertical-slice TDD — one test at a time, strictly.

### Rules

1. One failing test at a time — never write a batch of tests before implementing
2. Tests exercise public interfaces only — no testing private methods
3. Minimal implementation — just enough to pass the current test
4. Refactor only after green — never restructure while tests are failing

### The Cycle

```
Write one failing test → run it (must fail) → write minimal code to pass
→ run it (must pass) → refactor → commit → repeat
```

### What to Test in SpaceTime

| Layer | Test type | What to test |
|---|---|---|
| BLoC | Unit test | Events → state transitions |
| Repository | Unit test | Correct Supabase queries, correct model returned |
| Widgets | Widget test | UI renders correct state for each BLoC state |
| Flows | Integration test | Login → home → confirm attendance end to end |

### BLoC Test Example

```dart
blocTest<AttendanceBloc, AttendanceState>(
  'emits AttendanceConfirmed when ConfirmAttendance succeeds',
  build: () => AttendanceBloc(repository: FakeAttendanceRepository()),
  act: (bloc) => bloc.add(ConfirmAttendance(sessionId: 'session-1')),
  expect: () => [isA<AttendanceLoading>(), isA<AttendanceConfirmed>()],
);
```

### Prefer Fakes Over Mocks

```dart
class FakeAttendanceRepository implements AttendanceRepository {
  AttendanceStatus? lastUpdatedStatus;

  @override
  Future<Attendance> updateAttendanceStatus({
    required String sessionId,
    required String studentId,
    required AttendanceStatus status,
  }) async {
    lastUpdatedStatus = status;
    return Attendance(/* ... */);
  }
}
```

---

## Adaptive Alert Dialog

Use for all destructive confirmations (cancel session, cancel all future sessions, etc.). Always call from `BlocListener`, never from `build()`.

```dart
// lib/src/common/widgets/show_alert_dialog.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  String? content,
  String? cancelActionText,
  required String defaultActionText,
  bool isDestructive = false,
}) async {
  return showAdaptiveDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: content != null ? Text(content) : null,
      actions: [
        if (cancelActionText != null)
          _adaptiveAction(
            context: context,
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelActionText),
          ),
        _adaptiveAction(
          context: context,
          isDefaultAction: true,
          isDestructiveAction: isDestructive,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defaultActionText),
        ),
      ],
    ),
  );
}

Widget _adaptiveAction({
  required BuildContext context,
  required VoidCallback onPressed,
  required Widget child,
  bool isDefaultAction = false,
  bool isDestructiveAction = false,
}) =>
    switch (Theme.of(context).platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => CupertinoDialogAction(
          isDefaultAction: isDefaultAction,
          isDestructiveAction: isDestructiveAction,
          onPressed: onPressed,
          child: child,
        ),
      _ => TextButton(onPressed: onPressed, child: child),
    };
```

---

## Code Quality Checklist

Before committing, verify:

- [ ] No `print()` calls — use `dart:developer` `log()`
- [ ] No hardcoded colors — use `AppColors` extension
- [ ] No hardcoded sizes — use `Sizes` constants
- [ ] No silent `catch` blocks
- [ ] No side effects in `build()` — moved to `BlocListener`
- [ ] `const` used wherever possible
- [ ] All resources disposed
- [ ] Models use `json_serializable` with `fieldRename: FieldRename.snake`
- [ ] New features follow feature-first folder structure
- [ ] No abbreviations in names
