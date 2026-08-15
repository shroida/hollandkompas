import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/core/shared/widget/theme_toggle_button.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/theme/theme_provider.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onRegister;
  final VoidCallback? onForgot;

  const LoginScreen({
    super.key,
    required this.onLogin,
    this.onRegister,
    this.onForgot,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (!mounted) return;

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.error!,
              style: const TextStyle(fontFamily: 'Cairo'),
            ),
            backgroundColor: AppColors.destructive,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      if (!next.isLoading && next.error == null && next.user != null) {
        widget.onLogin();
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),

      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            context.isMobile
                ? _buildMobileLayout(context, state)
                : _buildDesktopTabletLayout(context, state),

            ThemeToggle(ref: ref, context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthState state) {
    return Column(
      children: [
        const HeaderAuth(),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.pagePadding,
              vertical: 16,
            ),
            child: _buildFormContent(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context, AuthState state) {
    return Row(
      children: [
        Expanded(
          flex: context.isDesktop ? 5 : 4,
          child: const SizedBox.expand(child: HeaderAuth()),
        ),

        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: context.isDesktop ? 2 : 0,
                  color: AppColors.cardColor(context),
                  surfaceTintColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: AppColors.borderColor(context)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(context.isDesktop ? 32 : 16),
                    child: _buildFormContent(context, state),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context, AuthState state) {
    final textColor = AppColors.textColor(context);
    final subtitleColor = AppColors.subtitleColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "مرحباً بعودتك 👋",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "سجّل الدخول لمتابعة تعلمك",
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: subtitleColor,
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

        const SizedBox(height: 16),

        AuthTextField(
          controller: passwordController,
          label: "كلمة المرور",
          hint: "••••••••",
          icon: Icons.lock_outline,
          obscureText: !showPassword,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(
              showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: subtitleColor,
              size: 20,
            ),
          ),
        ),

        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: widget.onForgot,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "نسيت كلمة المرور؟",
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
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
                  color: AppColors.primary.withValues(alpha: 0.30),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
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
                      "تسجيل الدخول",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),

        if (state.error != null) ...[
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.destructive.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.destructive.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.destructive,
                  size: 20,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.destructive,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(child: Divider(color: AppColors.borderColor(context))),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "أو",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.subtitleColor(context),
                  fontSize: 12,
                ),
              ),
            ),

            Expanded(child: Divider(color: AppColors.borderColor(context))),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: AppColors.borderColor(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: AppColors.cardColor(context),
                ),
                icon: const Text("🔵", style: TextStyle(fontSize: 16)),
                label: Text(
                  "Google",
                  style: TextStyle(fontFamily: 'Cairo', color: textColor),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: AppColors.borderColor(context)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: AppColors.cardColor(context),
                ),
                icon: const Text("🍎", style: TextStyle(fontSize: 16)),
                label: Text(
                  "Apple",
                  style: TextStyle(fontFamily: 'Cairo', color: textColor),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "ليس لديك حساب؟ ",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: subtitleColor,
                  fontSize: 13,
                ),
              ),

              GestureDetector(
                onTap: widget.onRegister,
                child: const Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      _showError("من فضلك أدخل البريد الإلكتروني");
      return;
    }

    if (password.isEmpty) {
      _showError("من فضلك أدخل كلمة المرور");
      return;
    }

    ref
        .read(authControllerProvider.notifier)
        .login(email: email, password: password);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Cairo')),
        backgroundColor: AppColors.destructive,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
