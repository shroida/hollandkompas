
import 'package:flutter/material.dart';
import 'package:hollandkompas/features/onboarding/models/onboarding_slide.dart';

class OnboardingHero extends StatelessWidget {
  const OnboardingHero({super.key, 
    required this.slide,
    required this.emojiSize,
    this.height,
  });

  final OnboardingSlide slide;
  final double emojiSize;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: slide.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (slide.image != null)
            Opacity(
              opacity: .35,
              child: Image.network(
                slide.image!,
                fit: BoxFit.cover,
              ),
            ),

          Center(
            child: TweenAnimationBuilder(
              duration: const Duration(
                milliseconds: 600,
              ),
              tween: Tween(
                begin: .8,
                end: 1.0,
              ),
              builder: (_, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Text(
                slide.emoji,
                style: TextStyle(
                  fontSize: emojiSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}