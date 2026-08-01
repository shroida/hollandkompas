import 'package:flutter/material.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onBack;

  const ForgotPasswordScreen({
    super.key,
    required this.onLogin,
    this.onBack,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: context.isMobile ? _buildMobileAppBar(context) : null,
      body: SafeArea(
        top: context.isMobile,
        child: context.isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopTabletLayout(context),
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
  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.pagePadding,
          vertical: 16,
        ),
        child: _buildAnimatedContent(context),
      ),
    );
  }

  /// Tablet & Desktop Layout
  Widget _buildDesktopTabletLayout(BuildContext context) {
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
                                  () => Navigator.maybePop(context),
                            ),
                          ),
                        _buildAnimatedContent(context),
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
  Widget _buildAnimatedContent(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: !isSent
          ? _buildFormState(context)
          : _buildSuccessState(context),
    );
  }

  /// Form View State
  Widget _buildFormState(BuildContext context) {
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
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                "إرسال رابط الاستعادة 🚀",
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