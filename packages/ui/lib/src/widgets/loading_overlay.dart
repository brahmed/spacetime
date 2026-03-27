import 'package:flutter/material.dart';

/// Full-screen loading overlay with a neon accent spinner.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Color(0xCC080808),
      child: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFFE500),
        ),
      ),
    );
  }
}
