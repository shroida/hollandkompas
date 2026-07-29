import 'dart:ui';

class OnboardingSlide {
  final String emoji;
  final String titleAr;
  final String titleNl;
  final String descAr;
  final List<String> tags;
  final List<Color> gradient;

  const OnboardingSlide({
    required this.emoji,
    required this.titleAr,
    required this.titleNl,
    required this.descAr,
    required this.tags,
    required this.gradient,
  });
}