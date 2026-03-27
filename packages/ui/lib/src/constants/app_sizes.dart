import 'package:flutter/widgets.dart';

/// Centralised spacing, padding, and radius constants.
/// Use these everywhere instead of magic numbers.
abstract final class Sizes {
  static const double p4 = 4;
  static const double p8 = 8;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p20 = 20;
  static const double p24 = 24;
  static const double p32 = 32;
  static const double p40 = 40;
  static const double p48 = 48;
  static const double p64 = 64;
  static const double p80 = 80;

  static const double radiusCard = 16;
  static const double radiusButton = 12;
  static const double radiusBadge = 6;
}

// Vertical gap widgets
const gapH4 = SizedBox(height: Sizes.p4);
const gapH8 = SizedBox(height: Sizes.p8);
const gapH12 = SizedBox(height: Sizes.p12);
const gapH16 = SizedBox(height: Sizes.p16);
const gapH20 = SizedBox(height: Sizes.p20);
const gapH24 = SizedBox(height: Sizes.p24);
const gapH32 = SizedBox(height: Sizes.p32);

// Horizontal gap widgets
const gapW4 = SizedBox(width: Sizes.p4);
const gapW8 = SizedBox(width: Sizes.p8);
const gapW12 = SizedBox(width: Sizes.p12);
const gapW16 = SizedBox(width: Sizes.p16);
const gapW20 = SizedBox(width: Sizes.p20);
const gapW24 = SizedBox(width: Sizes.p24);
const gapW32 = SizedBox(width: Sizes.p32);
