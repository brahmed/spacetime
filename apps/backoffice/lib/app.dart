import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import 'core/router/app_router.dart';

class SpaceTimeBackofficeApp extends StatelessWidget {
  const SpaceTimeBackofficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpaceTime — Back Office',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
    );
  }
}
