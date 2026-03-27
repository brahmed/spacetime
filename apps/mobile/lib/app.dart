import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'core/router/app_router.dart';

class SpaceTimeApp extends StatelessWidget {
  const SpaceTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpaceTime',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
