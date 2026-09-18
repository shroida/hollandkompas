import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({
    super.key,
    required this.logoController,
    required this.pulseController,
    required this.progress,
  });

  final AnimationController logoController;
  final AnimationController pulseController;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: FadeTransition(
        opacity: logoController,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: logoController,
            curve: Curves.elasticOut,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Logo(pulseController: pulseController),
              const SizedBox(height: 28),
              Text(
                'HollandKompas',
                style: textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              _AnimatedText(
                visible: progress > 10,
                text: 'بوصلتك نحو اللغة الهولندية',
                style: textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              _AnimatedText(
                visible: progress > 20,
                text: 'تعلم الهولندية بطريقة ذكية وممتعة',
                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 36),
              _ProgressIndicator(progress: progress),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.pulseController});

  final AnimationController pulseController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        final pulse = Curves.easeInOut.transform(pulseController.value);

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
                    color: Colors.white.withValues(alpha: 0.12 + pulse * 0.18),
                    blurRadius: 30 + pulse * 20,
                    spreadRadius: 2 + pulse * 3,
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
                scale: 1 + pulse * 0.15,
                child: const _LogoBadge(),
              ),
            ),
          ],
        );
      },
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
  const _AnimatedText({
    required this.visible,
    required this.text,
    required this.style,
  });

  final bool visible;
  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      child: Text(text, textDirection: TextDirection.rtl, style: style),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final value = (progress / 100).clamp(0.0, 1.0);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 260,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: SizedBox(
              height: 8,
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
                'جاري التحميل...',
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
