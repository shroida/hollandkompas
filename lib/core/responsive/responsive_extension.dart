import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  // Screen Size
  Size get size => MediaQuery.sizeOf(this);

  double get width => size.width;
  double get height => size.height;

  // Device Types
  bool get isMobile => width < 600;

  bool get isTablet =>
      width >= 600 && width < 1024;

  bool get isDesktop => width >= 1024;

  // Responsive Padding
  double get pagePadding {
    if (isDesktop) return 48;
    if (isTablet) return 24;
    return 16;
  }

  // Responsive Max Width
  double get contentWidth {
    if (isDesktop) return 1400;
    if (isTablet) return 900;
    return width;
  }

  // Responsive Font Scale
  double get fontScale {
    if (width >= 1440) return 1.3;
    if (width >= 1024) return 1.15;
    return 1.0;
  }
}