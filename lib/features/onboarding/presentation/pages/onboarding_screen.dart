import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/onboarding/data/onboarding_data.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/dots_indicator.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/level_selection_screen.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_device_type.dart';
import 'package:hollandkompas/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageTransitionDuration = Duration(milliseconds: 500);

  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await HiveService.settingsBox.put('onboarding_completed', true);

    if (!mounted) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      context.go('/home');
      return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, animation, secondaryAnimation) {
          return const LevelSelectionScreen();
        },
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleNext() async {
    final isLastPage = _currentPage == onboardingSlides.length - 1;

    if (isLastPage) {
      await _finishOnboarding();
      return;
    }

    await _pageController.nextPage(
      duration: _pageTransitionDuration,
      curve: Curves.easeOutCubic,
    );
  }

  void _handlePageChanged(int index) {
    if (_currentPage == index) {
      return;
    }

    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = OnboardingDeviceType.fromContext(context);
    final theme = Theme.of(context);
    final isLastPage = _currentPage == onboardingSlides.length - 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: deviceType.maxContentWidth),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingSlides.length,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    onPageChanged: _handlePageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingPage(
                        key: ValueKey(index),
                        slide: onboardingSlides[index],
                        deviceType: deviceType,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceType.horizontalPadding,
                  ),
                  child: DotsIndicator(
                    count: onboardingSlides.length,
                    currentIndex: _currentPage,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    deviceType.buttonPadding,
                    18,
                    deviceType.buttonPadding,
                    deviceType.buttonPadding,
                  ),
                  child: _ContinueButton(
                    width: deviceType.buttonWidth,
                    height: deviceType.buttonHeight,
                    fontSize: deviceType.buttonFontSize,
                    isLastPage: isLastPage,
                    onPressed: _handleNext,
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

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.width,
    required this.height,
    required this.fontSize,
    required this.isLastPage,
    required this.onPressed,
  });

  final double width;
  final double height;
  final double fontSize;
  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.22),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(
                        begin: 0.92,
                        end: 1,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Row(
                  key: ValueKey(isLastPage),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastPage ? 'ابدأ الآن' : 'التالي',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedRotation(
                      turns: isLastPage ? 0.5 : 0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutBack,
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
