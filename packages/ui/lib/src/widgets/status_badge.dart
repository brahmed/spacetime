import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import '../theme/attendance_status_colors.dart';

/// A small badge displaying an [AttendanceStatus] with matching
/// neon border and dark background fill.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final AttendanceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p8,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: status.bgColor,
        borderRadius: BorderRadius.circular(Sizes.radiusBadge),
        border: Border.all(color: status.borderColor),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.borderColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
