import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';

enum OnboardingDeviceType {
  mobile,
  tablet,
  desktop;

  factory OnboardingDeviceType.fromContext(BuildContext context) {
    if (context.isDesktop) {
      return desktop;
    }

    if (context.isTablet) {
      return tablet;
    }

    return mobile;
  }

  bool get isDesktop => this == desktop;

  double get maxContentWidth {
    return switch (this) {
      mobile => double.infinity,
      tablet => 1000,
      desktop => 1440,
    };
  }

  double get horizontalPadding {
    return switch (this) {
      mobile => 24,
      tablet => 40,
      desktop => 80,
    };
  }

  double get buttonPadding {
    return switch (this) {
      mobile => 24,
      tablet => 32,
      desktop => 40,
    };
  }

  double get buttonWidth {
    return switch (this) {
      mobile => double.infinity,
      tablet => double.infinity,
      desktop => 500,
    };
  }

  double get buttonHeight {
    return switch (this) {
      mobile => 56,
      tablet => 62,
      desktop => 68,
    };
  }

  double get buttonFontSize {
    return switch (this) {
      mobile => 16,
      tablet => 18,
      desktop => 20,
    };
  }

  double get heroHeight {
    return switch (this) {
      mobile => 270,
      tablet => 370,
      desktop => 0,
    };
  }

  double get titleSize {
    return switch (this) {
      mobile => 30,
      tablet => 40,
      desktop => 44,
    };
  }

  double get descriptionSize {
    return switch (this) {
      mobile => 15,
      tablet => 18,
      desktop => 20,
    };
  }

  double get contentPadding {
    return switch (this) {
      mobile => 24,
      tablet => 32,
      desktop => 56,
    };
  }

  double get heroRadius {
    return switch (this) {
      mobile => 0,
      tablet => 28,
      desktop => 32,
    };
  }
}
