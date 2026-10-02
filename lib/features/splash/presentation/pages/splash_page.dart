import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/splash/widgets/center_content.dart';
import 'package:hollandkompas/features/splash/widgets/dutch_flag_bar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _masterController;
  late final AnimationController _pulseController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _brandOpacity;
  late final Animation<double> _brandSlide;
  late final Animation<double> _subtitleOpacity;
  late final Animation<double> _descriptionOpacity;
  late final Animation<double> _progress;
  late final Animation<double> _finishGlow;

  @override
  void initState() {
    super.initState();

    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2700),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _logoOpacity = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.00, 0.28, curve: Curves.easeOut),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.00, 0.34, curve: Curves.easeOutBack),
      ),
    );

    _brandOpacity = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.18, 0.48, curve: Curves.easeOut),
    );

    _brandSlide = Tween<double>(begin: 18, end: 0).animate(
      CurvedAnimation(
        parent: _masterController,
        curve: const Interval(0.18, 0.48, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleOpacity = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.36, 0.60, curve: Curves.easeOut),
    );

    _descriptionOpacity = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.46, 0.70, curve: Curves.easeOut),
    );

    _progress = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.34, 0.88, curve: Curves.easeInOutCubic),
    );

    _finishGlow = CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.84, 1.00, curve: Curves.easeOut),
    );

    _masterController.forward();

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future<void>.delayed(const Duration(milliseconds: 2700));

    if (!mounted) {
      return;
    }

    final uri = Uri.base;

    if (uri.queryParameters.containsKey('code')) {
      context.go('/reset-password');
      return;
    }

    widget.onDone();
  }

  @override
  void dispose() {
    _masterController.dispose();
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
            animation: Listenable.merge([_masterController, _pulseController]),
            builder: (context, child) {
              return CenterContent(
                logoOpacity: _logoOpacity.value,
                logoScale: _logoScale.value,
                brandOpacity: _brandOpacity.value,
                brandSlide: _brandSlide.value,
                subtitleOpacity: _subtitleOpacity.value,
                descriptionOpacity: _descriptionOpacity.value,
                progress: _progress.value * 100,
                finishGlow: _finishGlow.value,
                pulseValue: _pulseController.value,
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
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
            AppColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _BackgroundCircle(size: 380, top: -120, right: -120, opacity: 0.15),
          _BackgroundCircle(size: 320, bottom: -160, left: -80, opacity: 0.10),
          _BackgroundCircle(size: 220, top: 180, left: 90, opacity: 0.08),
        ],
      ),
    );
  }
}

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle({
    required this.size,
    required this.opacity,
    this.top,
    this.right,
    this.bottom,
    this.left,
  });

  final double size;
  final double opacity;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      children: [
        const DutchFlagBar(alignment: Alignment.topCenter),
        const DutchFlagBar(alignment: Alignment.bottomCenter),
        Positioned(
          left: 0,
          right: 0,
          bottom: 40,
          child: Text(
            'من A1 إلى B2 — خطوة بخطوة',
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
