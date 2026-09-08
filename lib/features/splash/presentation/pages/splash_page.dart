import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/splash/widgets/center_content.dart';
import 'package:hollandkompas/features/splash/widgets/dutch_flag_bar.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onDone;

  const SplashPage({super.key, required this.onDone});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _pulseController;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progress = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 2400));

    if (!mounted) return;

    final uri = Uri.base;

    if (uri.queryParameters.containsKey('code')) {
      context.go('/reset-password');
      return;
    }

    widget.onDone();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _SplashBackground(),

          AnimatedBuilder(
            animation: _progress,
            builder: (context, _) {
              return CenterContent(
                logoController: _logoController,
                pulseController: _pulseController,
                progress: _progress.value,
              );
            },
          ),

          const _SplashFooter(),
        ],
      ),
    );
  }
}

class _SplashBackground extends StatelessWidget {
  const _SplashBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFFE55A00), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Stack(
        children: [
          _BackgroundCircle(size: 380, top: -120, right: -120, opacity: .15),
          _BackgroundCircle(size: 320, bottom: -160, left: -80, opacity: .10),
          _BackgroundCircle(size: 220, top: 180, left: 90, opacity: .08),
        ],
      ),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  final double size;
  final double opacity;

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  const _BackgroundCircle({
    required this.size,
    required this.opacity,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        DutchFlagBar(alignment: Alignment.topCenter),
        DutchFlagBar(alignment: Alignment.bottomCenter),

        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'من A1 إلى B2 — خطوة بخطوة',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
