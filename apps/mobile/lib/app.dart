import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_client/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session, AuthState;
import 'package:ui/ui.dart';

import 'core/cubit/locale_cubit.dart';
import 'core/router/app_router.dart';
import 'core/services/fcm_service.dart';
import 'features/auth/bloc/auth_bloc.dart';

class SpaceTimeApp extends StatelessWidget {
  const SpaceTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(client)),
        RepositoryProvider(create: (_) => SessionRepository(client)),
        RepositoryProvider(create: (_) => AttendanceRepository(client)),
        RepositoryProvider(create: (_) => AnnouncementRepository(client)),
        RepositoryProvider(create: (_) => NotificationRepository(client)),
        RepositoryProvider(create: (_) => CourseRepository(client)),
        RepositoryProvider(create: (_) => ProfileRepository(client)),
        RepositoryProvider(create: (_) => EnrollmentRepository(client)),
        RepositoryProvider(create: (_) => DeviceTokenRepository(client)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              context.read<AuthRepository>(),
            )..add(const AuthStarted()),
          ),
          BlocProvider(create: (_) => LocaleCubit()),
        ],
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          FcmService.saveTokenForUser(
            userId: state.profile.id,
            repository: context.read<DeviceTokenRepository>(),
          );
        }
      },
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return MaterialApp.router(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.dark,
            routerConfig: _router,
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }
}
