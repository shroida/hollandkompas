import 'package:flutter/material.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_hero.dart';
import '../../models/onboarding_slide.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.slide,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  final OnboardingSlide slide;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: OnboardingHero(
                slide: slide,
                emojiSize: 140,
              ),
            ),

            Expanded(
              flex: 4,
              child: _ContentSection(
                slide: slide,
                titleSize: 42,
                descSize: 20,
                padding: 56,
              ),
            ),
          ],
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Column(
          children: [
            OnboardingHero(
              slide: slide,
              emojiSize: isTablet ? 120 : 80,
              height: isTablet ? 360 : 260,
            ),

            _ContentSection(
              slide: slide,
              titleSize: isTablet ? 40 : 30,
              descSize: isTablet ? 18 : 15,
              padding: isTablet ? 32 : 24,
            ),
          ],
        ),
      ),
    );
  }
}
class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.slide,
    required this.titleSize,
    required this.descSize,
    required this.padding,
  });

  final OnboardingSlide slide;
  final double titleSize;
  final double descSize;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            slide.titleNl,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Color(0xFFFF6B00),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            slide.titleAr,
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            slide.descAr,
            style: TextStyle(
              fontSize: descSize,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 32),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: slide.tags.map((tag) {
              return Chip(
                label: Text(tag),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}