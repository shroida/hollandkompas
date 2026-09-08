import 'package:flutter/material.dart';

class CenterContent extends StatelessWidget {
  final AnimationController logoController;
  final AnimationController pulseController;
  final double progress;

  const CenterContent({
    super.key,
    required this.logoController,
    required this.pulseController,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
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

              const Text(
                'HollandKompas',
                style: TextStyle(
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
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),

              const SizedBox(height: 4),

              _AnimatedText(
                visible: progress > 20,
                text: 'تعلم الهولندية بطريقة ذكية وممتعة',
                fontSize: 13,
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
  final AnimationController pulseController;

  const _Logo({required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, _) {
        final pulse = Curves.easeInOut.transform(pulseController.value);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .95),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: .12 + pulse * .18),
                    blurRadius: 30 + pulse * 20,
                    spreadRadius: 2 + pulse * 3,
                  ),
                  const BoxShadow(color: Colors.black26, blurRadius: 30),
                ],
              ),
              child: const Center(
                child: Text('🇳🇱', style: TextStyle(fontSize: 48)),
              ),
            ),

            Positioned(
              top: -4,
              right: -4,
              child: Transform.scale(
                scale: 1 + pulse * .15,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6B00),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'HK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AnimatedText extends StatelessWidget {
  final bool visible;
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;

  const _AnimatedText({
    required this.visible,
    required this.text,
    required this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: visible ? 1 : 0,
      duration: const Duration(milliseconds: 600),
      child: Text(
        text,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          color: Colors.white70,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final double progress;

  const _ProgressIndicator({required this.progress});

  @override
  Widget build(BuildContext context) {
    final value = (progress / 100).clamp(0.0, 1.0);

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
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFFFF3E8)],
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.white54, blurRadius: 12),
                      ],
                    ),
                  ),
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
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Text(
                'جاري التحميل...',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
