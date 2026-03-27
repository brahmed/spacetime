import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Flutter [Color] accessors for [AttendanceStatus] color tokens.
extension AttendanceStatusColors on AttendanceStatus {
  Color get borderColor => Color(borderArgb);
  Color get bgColor => Color(bgArgb);
}
