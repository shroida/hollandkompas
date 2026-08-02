import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onBack;

  const ForgotPasswordScreen({
    super.key,
    required this.onLogin,
    this.onBack,
  });

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isSent = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (emailController.text.trim().isNotEmpty) {
      setState(() => isSent = true);
    }
  }
@override
void initState() {
  super.initState();

  ref.listenManual(
    authControllerProvider,
    (previous, next) {
      if (!mounted) return;

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      } else if (!next.isLoading) {
        setState(() {
          isSent = true;
        });
      }
    },
  );
}
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: context.isMobile ? _buildMobileAppBar(context) : null,
      body: SafeArea(
        top: context.isMobile,
        child: context.isMobile
            ? _buildMobileLayout(context, state)
            : _buildDesktopTabletLayout(context, state),
      ),
    );
  }

  /// Mobile App Bar
  PreferredSizeWidget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppColors.textForeground,
          size: 20,
        ),
        onPressed: widget.onBack ?? () => Navigator.maybePop(context),
      ),
    );
  }

  /// Mobile Layout
  Widget _buildMobileLayout(BuildContext context,AuthState state) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.pagePadding,
          vertical: 16,
        ),
        child: _buildAnimatedContent(context, state),
      ),
    );
  }

  /// Tablet & Desktop Layout
  Widget _buildDesktopTabletLayout(BuildContext context,AuthState state) {
    return Row(
      children: [
        // Side Branding Banner
        Expanded(
          flex: context.isDesktop ? 5 : 4,
          child: const SizedBox.expand(
            child: HeaderAuth(),
          ),
        ),

        // Content Area Card
        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: context.isDesktop ? 2 : 0,
                  color: context.isDesktop ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(context.isDesktop ? 32 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.onBack != null || Navigator.canPop(context))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.textForeground,
                                size: 20,
                              ),
                              onPressed: widget.onBack ??
                                  () =>context.pop(),
                            ),
                          ),
                        _buildAnimatedContent(context, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Smooth State Switcher
  Widget _buildAnimatedContent(BuildContext context,AuthState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: !isSent
          ? _buildFormState(context, state)
          : _buildSuccessState(context),
    );
  }

  /// Form View State
  Widget _buildFormState(BuildContext context, AuthState state) {
    return Column(
      key: const ValueKey("FormState"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.mail_outline,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          "نسيت كلمة المرور؟",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textForeground,
          ),
        ),
        const SizedBox(height: 8),

        const Text(
          "أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedForeground,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),

        AuthTextField(
          controller: emailController,
          label: "البريد الإلكتروني",
          hint: "example@email.com",
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 24),

       SizedBox(
        width: double.infinity,
        height: 52,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Please enter your email.",
                          ),
                        ),
                      );
                      return;
                    }

                    ref
                        .read(authControllerProvider.notifier)
                        .forgotPassword(
                          email: emailController.text.trim(),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: state.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "إرسال رابط الاستعادة 🚀",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      )                        
      ],
    );
  }

  /// Success View State
  Widget _buildSuccessState(BuildContext context) {
    return Column(
      key: const ValueKey("SuccessState"),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text("✅", style: TextStyle(fontSize: 36)),
        ),
        const SizedBox(height: 20),

        const Text(
          "تم إرسال الرابط!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textForeground,
          ),
        ),
        const SizedBox(height: 8),

        const Text(
          "تفقد بريدك الإلكتروني واتبع التعليمات لإعادة تعيين كلمة المرور.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedForeground,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: widget.onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "العودة لتسجيل الدخول",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}