import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final controller = PageController();

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: slides.length,
                itemBuilder: (_, index) {
                  return OnboardingPage(
                    slide: slides[index],
                    tablet: tablet,
                  );
                },
              ),
            ),

            DotsIndicator(
              count: slides.length,
              currentIndex: currentPage,
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: tablet ? 64 : 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage <
                        slides.length - 1) {
                      controller.nextPage(
                        duration:
                            const Duration(
                              milliseconds: 350,
                            ),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: const Text(
                    'التالي',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}