import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({
    super.key,
    required this.logoOpacity,
    required this.logoScale,
    required this.brandOpacity,
    required this.brandSlide,
    required this.subtitleOpacity,
    required this.descriptionOpacity,
    required this.progress,
    required this.finishGlow,
    required this.pulseValue,
  });

  final double logoOpacity;
  final double logoScale;
  final double brandOpacity;
  final double brandSlide;
  final double subtitleOpacity;
  final double descriptionOpacity;
  final double progress;
  final double finishGlow;
  final double pulseValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Transform.translate(
        offset: Offset(0, brandSlide),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: logoOpacity,
              child: Transform.scale(
                scale: logoScale,
                child: _Logo(pulseValue: pulseValue, finishGlow: finishGlow),
              ),
            ),
            const SizedBox(height: 28),
            Opacity(
              opacity: brandOpacity,
              child: Text(
                'HollandKompas',
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Opacity(
              opacity: subtitleOpacity,
              child: _AnimatedText(
                text: 'بوصلتك نحو اللغة الهولندية',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Opacity(
              opacity: descriptionOpacity,
              child: _AnimatedText(
                text: 'تعلم الهولندية بطريقة ذكية وممتعة',
                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ),
            const SizedBox(height: 36),
            _ProgressIndicator(progress: progress, finishGlow: finishGlow),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.pulseValue, required this.finishGlow});

  final double pulseValue;
  final double finishGlow;

  @override
  Widget build(BuildContext context) {
    final pulse = (math.sin(pulseValue * math.pi * 2) + 1) / 2;

    final glow = 0.10 + (pulse * 0.10) + (finishGlow * 0.12);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: glow),
                blurRadius: 24 + (pulse * 12),
                spreadRadius: 2 + (pulse * 2),
              ),
              const BoxShadow(color: Colors.black26, blurRadius: 30),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/logo.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox.shrink();
            },
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Transform.scale(
            scale: 1 + (pulse * 0.08),
            child: const _LogoBadge(),
          ),
        ),
      ],
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'HK',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedText extends StatelessWidget {
  const _AnimatedText({required this.text, required this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(text, textDirection: TextDirection.rtl, style: style);
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress, required this.finishGlow});

  final double progress;
  final double finishGlow;

  @override
  Widget build(BuildContext context) {
    final value = (progress / 100).clamp(0.0, 1.0);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 260,
      child: Column(
        children: [
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: finishGlow * 0.25),
                  blurRadius: 12,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: const _ProgressFill(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${progress.toInt()}%',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                progress >= 98 ? 'جاهز للانطلاق...' : 'جاري التحميل...',
                textDirection: TextDirection.rtl,
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressFill extends StatelessWidget {
  const _ProgressFill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Color(0xFFFFF3E8)]),
        boxShadow: [BoxShadow(color: Colors.white54, blurRadius: 12)],
      ),
    );
  }
}
