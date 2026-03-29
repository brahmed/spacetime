import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import 'package:ui/ui.dart';

import 'core/router/app_router.dart';
import 'features/auth/bloc/auth_bloc.dart';

class SpaceTimeBackofficeApp extends StatelessWidget {
  const SpaceTimeBackofficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(client)),
        RepositoryProvider(create: (_) => ProfileRepository(client)),
        RepositoryProvider(create: (_) => CourseRepository(client)),
        RepositoryProvider(create: (_) => SessionRepository(client)),
        RepositoryProvider(create: (_) => EnrollmentRepository(client)),
        RepositoryProvider(create: (_) => AnnouncementRepository(client)),
        RepositoryProvider(create: (_) => AttendanceRepository(client)),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          context.read<AuthRepository>(),
        )..add(const AuthStarted()),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  late final _router = AppRouter.router(context.read<AuthBloc>());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appNameBackoffice,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: _router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
