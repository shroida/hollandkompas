import 'package:flutter/material.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({
    super.key,
    required AnimationController logoController,
    required AnimationController pulseController,
    required this.progress,
  })  : _logoController = logoController,
        _pulseController = pulseController;

  final AnimationController _logoController;
  final AnimationController _pulseController;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _logoController,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _logoController,
            curve: Curves.elasticOut,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Logo
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .95),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(
                                alpha: 0.12 +
                                    (_pulseController.value * 0.18),
                              ),
                              blurRadius:
                                  30 + (_pulseController.value * 20),
                              spreadRadius:
                                  2 + (_pulseController.value * 3),
                            ),
                            const BoxShadow(
                              blurRadius: 30,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        child: child,
                      );
                    },
                    child: const Center(
                      child: Text(
                        "🇳🇱",
                        style: TextStyle(
                          fontSize: 48,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: -4,
                    right: -4,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 1.0,
                        end: 1.15,
                      ).animate(
                        CurvedAnimation(
                          parent: _pulseController,
                          curve: Curves.easeInOut,
                        ),
                      ),
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
              ),

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

              AnimatedOpacity(
                opacity: progress > 10 ? 1 : 0,
                duration: const Duration(milliseconds: 800),
                child: const Text(
                  'بوصلتك نحو اللغة الهولندية',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 4),

              AnimatedOpacity(
                opacity: progress > 20 ? 1 : 0,
                duration: const Duration(milliseconds: 1000),
                child: const Text(
                  'تعلم الهولندية بطريقة ذكية وممتعة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: 260,
                child: Column(
                  children: [
                    TweenAnimationBuilder<double>(
                      duration:
                          const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      tween: Tween(
                        begin: 0,
                        end: progress / 100,
                      ),
                      builder: (context, value, _) {
                        return Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: .15,
                            ),
                            borderRadius:
                                BorderRadius.circular(100),
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FractionallySizedBox(
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(
                                    100,
                                  ),
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Color(0xFFFFF3E8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.white.withValues(
                                        alpha: .5,
                                      ),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${progress.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Text(
                          'جاري التحميل...',
                          textDirection:
                              TextDirection.rtl,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}