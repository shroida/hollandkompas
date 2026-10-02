import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/onboarding/models/onboarding_slide.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_device_type.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_hero.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    super.key,
    required this.slide,
    required this.deviceType,
  });

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _pageFade;
  late final Animation<double> _pageScale;
  late final Animation<Offset> _pageSlide;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _descriptionFade;
  late final Animation<Offset> _descriptionSlide;

  late final Animation<double> _tagsFade;
  late final Animation<Offset> _tagsSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _pageFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.55, curve: Curves.easeOut),
    );

    _pageScale = Tween<double>(begin: 0.96, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    _pageSlide = Tween<Offset>(begin: const Offset(0, 0.025), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0, 0.65, curve: Curves.easeOutCubic),
          ),
        );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.48, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.18, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _descriptionFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.32, 0.68, curve: Curves.easeOut),
    );

    _descriptionSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.32, 0.72, curve: Curves.easeOutCubic),
          ),
        );

    _tagsFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.48, 0.86, curve: Curves.easeOut),
    );

    _tagsSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.48, 0.90, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _pageFade,
            child: SlideTransition(
              position: _pageSlide,
              child: ScaleTransition(scale: _pageScale, child: child),
            ),
          );
        },
        child: widget.deviceType.isDesktop
            ? _DesktopLayout(
                slide: widget.slide,
                deviceType: widget.deviceType,
                titleFade: _titleFade,
                titleSlide: _titleSlide,
                descriptionFade: _descriptionFade,
                descriptionSlide: _descriptionSlide,
                tagsFade: _tagsFade,
                tagsSlide: _tagsSlide,
              )
            : _MobileLayout(
                slide: widget.slide,
                deviceType: widget.deviceType,
                titleFade: _titleFade,
                titleSlide: _titleSlide,
                descriptionFade: _descriptionFade,
                descriptionSlide: _descriptionSlide,
                tagsFade: _tagsFade,
                tagsSlide: _tagsSlide,
              ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.slide,
    required this.deviceType,
    required this.titleFade,
    required this.titleSlide,
    required this.descriptionFade,
    required this.descriptionSlide,
    required this.tagsFade,
    required this.tagsSlide,
  });

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;
  final Animation<double> descriptionFade;
  final Animation<Offset> descriptionSlide;
  final Animation<double> tagsFade;
  final Animation<Offset> tagsSlide;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: OnboardingHero(slide: slide),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _ContentSection(
                slide: slide,
                deviceType: deviceType,
                titleFade: titleFade,
                titleSlide: titleSlide,
                descriptionFade: descriptionFade,
                descriptionSlide: descriptionSlide,
                tagsFade: tagsFade,
                tagsSlide: tagsSlide,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.slide,
    required this.deviceType,
    required this.titleFade,
    required this.titleSlide,
    required this.descriptionFade,
    required this.descriptionSlide,
    required this.tagsFade,
    required this.tagsSlide,
  });

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;
  final Animation<double> descriptionFade;
  final Animation<Offset> descriptionSlide;
  final Animation<double> tagsFade;
  final Animation<Offset> tagsSlide;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          OnboardingHero(slide: slide, height: deviceType.heroHeight),
          _ContentSection(
            slide: slide,
            deviceType: deviceType,
            titleFade: titleFade,
            titleSlide: titleSlide,
            descriptionFade: descriptionFade,
            descriptionSlide: descriptionSlide,
            tagsFade: tagsFade,
            tagsSlide: tagsSlide,
          ),
        ],
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.slide,
    required this.deviceType,
    required this.titleFade,
    required this.titleSlide,
    required this.descriptionFade,
    required this.descriptionSlide,
    required this.tagsFade,
    required this.tagsSlide,
  });

  final OnboardingSlide slide;
  final OnboardingDeviceType deviceType;

  final Animation<double> titleFade;
  final Animation<Offset> titleSlide;
  final Animation<double> descriptionFade;
  final Animation<Offset> descriptionSlide;
  final Animation<double> tagsFade;
  final Animation<Offset> tagsSlide;

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
          FadeTransition(
            opacity: titleFade,
            child: SlideTransition(
              position: titleSlide,
              child: _DutchTitle(text: slide.titleNl),
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: titleFade,
            child: SlideTransition(
              position: titleSlide,
              child: Text(
                slide.titleAr,
                style: textTheme.headlineLarge?.copyWith(
                  fontSize: deviceType.titleSize,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          FadeTransition(
            opacity: descriptionFade,
            child: SlideTransition(
              position: descriptionSlide,
              child: Text(
                slide.descAr,
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: deviceType.descriptionSize,
                  height: 1.8,
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          FadeTransition(
            opacity: tagsFade,
            child: SlideTransition(
              position: tagsSlide,
              child: _TagList(tags: slide.tags),
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            textDirection: TextDirection.ltr,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
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
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_rounded,
                  size: 15,
                  color: AppColors.primary.withValues(alpha: 0.85),
                ),
                const SizedBox(width: 5),
                Text(
                  tag,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
