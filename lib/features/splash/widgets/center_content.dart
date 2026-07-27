
import 'package:flutter/material.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({
    super.key,
    required AnimationController logoController,
    required AnimationController pulseController,
    required this.progress,
  }) : _logoController = logoController, _pulseController = pulseController;

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
    );
  }
}
