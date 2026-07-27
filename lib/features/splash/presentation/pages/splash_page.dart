import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/splash/providers/splash_provider.dart';
import 'package:hollandkompas/features/splash/widgets/bottom_dutch_flag.dart';
import 'package:hollandkompas/features/splash/widgets/center_content.dart';
import 'package:hollandkompas/features/splash/widgets/top_dutch_flag.dart';


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
            TopDutchFlag(),

            CenterContent(logoController: _logoController, pulseController: _pulseController, progress: progress),

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
            BottomDutchFlag(),
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