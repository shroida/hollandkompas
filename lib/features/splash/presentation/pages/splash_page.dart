import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/splash/providers/splash_provider.dart';


class SplashPage extends ConsumerStatefulWidget {
  final VoidCallback onDone;

  const SplashPage({
    super.key,
    required this.onDone,
  });

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _logoController.forward();

    Future.microtask(() {
      ref.read(splashProvider.notifier).start(widget.onDone);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(splashProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFF6B00),
              Color(0xFFE55A00),
              Color(0xFF1E3A8A),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [

            /// Background Circles
            Positioned(
              top: -120,
              right: -120,
              child: _circle(380, .15),
            ),

            Positioned(
              bottom: -160,
              left: -80,
              child: _circle(320, .10),
            ),

            Positioned(
              top: 180,
              left: 90,
              child: _circle(220, .08),
            ),

            /// Top Dutch Flag
            const Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: Color(0xFFAE1C28),
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Color(0xFF21468B),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Center(
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
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .95),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 30,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "🇳🇱",
                                style: TextStyle(fontSize: 48),
                              ),
                            ),
                          ),

                          Positioned(
                            top: -4,
                            right: -4,
                            child: ScaleTransition(
                              scale: Tween(
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

                      const SizedBox(height: 24),

                      const Text(
                        'HollandKompas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'بوصلتك نحو اللغة الهولندية',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        'تعلم الهولندية بطريقة ذكية وممتعة',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: 240,
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: progress / 100,
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(100),
                              backgroundColor:
                                  Colors.white.withValues(alpha: .20),
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'من A1 إلى B2 — خطوة بخطوة',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            /// Bottom Dutch Flag
            const Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: Color(0xFFAE1C28),
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Color(0xFF21468B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}