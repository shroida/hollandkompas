import 'dart:ui';

class OnboardingSlide {
  final String titleAr;
  final String titleNl;
  final String descAr;
  final List<String> tags;
  final List<Color> gradient;
  final String? image;

  const OnboardingSlide({
    required this.titleAr,
    required this.titleNl,
    required this.descAr,
    required this.tags,
    required this.gradient,
    this.image,
  });
}