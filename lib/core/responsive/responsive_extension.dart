import 'package:flutter/material.dart';

import 'breakpoints.dart';

extension ResponsiveExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  bool get isMobile =>
      width < Breakpoints.mobile;

  bool get isTablet =>
      width >= Breakpoints.mobile &&
      width < Breakpoints.tablet;

  bool get isDesktop =>
      width >= Breakpoints.tablet;
}