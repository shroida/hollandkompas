import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/features/onboarding/data/onboarding_data.dart';
import 'package:hollandkompas/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/dots_indicator.dart';

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
  final isMobile = context.isMobile;
  final isTablet = context.isTablet;
  final isDesktop = context.isDesktop;
  return Scaffold(
  body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isDesktop
              ? 1400
              : isTablet
                  ? 900
                  : double.infinity,
        ),
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
                itemCount: onboardingSlides.length,
                itemBuilder: (_, index) {
                  return OnboardingPage(
                    slide: onboardingSlides[index],
                    isMobile: isMobile,
                    isTablet: isTablet,
                    isDesktop: isDesktop,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop
                    ? 80
                    : isTablet
                        ? 40
                        : 24,
              ),
              child: DotsIndicator(
                count: onboardingSlides.length,
                currentIndex: currentPage,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(
                isDesktop
                    ? 40
                    : isTablet
                        ? 32
                        : 24,
              ),
              child: SizedBox(
                width: isDesktop ? 500 : double.infinity,
                height: isDesktop
                    ? 68
                    : isTablet
                        ? 64
                        : 56,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentPage <
                        onboardingSlides.length - 1) {
                      controller.nextPage(
                        duration: const Duration(
                          milliseconds: 350,
                        ),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  child: Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: isDesktop
                          ? 20
                          : isTablet
                              ? 18
                              : 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
 
  }
}