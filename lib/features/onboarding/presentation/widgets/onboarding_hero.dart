import 'package:flutter/material.dart';
import 'package:hollandkompas/features/onboarding/models/onboarding_slide.dart';

class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key, required this.slide, this.height});

  final OnboardingSlide slide;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: slide.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: slide.image == null
            ? null
            : Opacity(
                opacity: 0.35,
                child: Image.network(
                  slide.image!,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              ),
      ),
    );
  }
}
