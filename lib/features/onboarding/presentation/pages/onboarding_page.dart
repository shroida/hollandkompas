import 'package:flutter/material.dart';

import '../../models/onboarding_slide.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.slide,
    required this.tablet,
  });

  final OnboardingSlide slide;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        child: Column(
          children: [
            /// Hero Section
            Container(
              height: tablet ? 360 : 260,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: slide.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  slide.emoji,
                  style: TextStyle(
                    fontSize: tablet ? 120 : 80,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    slide.titleNl,
                    textDirection:
                        TextDirection.ltr,
                    style: const TextStyle(
                      color: Color(0xFFFF6B00),
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    slide.titleAr,
                    style: TextStyle(
                      fontSize:
                          tablet ? 40 : 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    slide.descAr,
                    style: TextStyle(
                      fontSize:
                          tablet ? 18 : 15,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: slide.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}