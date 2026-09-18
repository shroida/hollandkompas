import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/onboarding/models/onboarding_slide.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_device_type.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_hero.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.slide,
    required this.deviceType,
  });

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: deviceType.isDesktop
          ? _DesktopLayout(slide: slide, deviceType: deviceType)
          : _MobileLayout(slide: slide, deviceType: deviceType),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.slide, required this.deviceType});

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: OnboardingHero(slide: slide),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _ContentSection(slide: slide, deviceType: deviceType),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.slide, required this.deviceType});

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          OnboardingHero(slide: slide, height: deviceType.heroHeight),
          _ContentSection(slide: slide, deviceType: deviceType),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({required this.slide, required this.deviceType});

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        deviceType.contentPadding,
        deviceType.contentPadding,
        deviceType.contentPadding,
        12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DutchTitle(text: slide.titleNl),
          const SizedBox(height: 10),
          Text(
            slide.titleAr,
            style: textTheme.headlineLarge?.copyWith(
              fontSize: deviceType.titleSize,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            slide.descAr,
            style: textTheme.bodyLarge?.copyWith(
              fontSize: deviceType.descriptionSize,
              height: 1.8,
              color: AppColors.subtitleColor(context),
            ),
          ),
          const SizedBox(height: 26),
          _TagList(tags: slide.tags),
        ],
      ),
    );
  }
}

class _DutchTitle extends StatelessWidget {
  const _DutchTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textDirection: TextDirection.ltr,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TagList extends StatelessWidget {
  const _TagList({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final tag in tags)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Text(
              tag,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
