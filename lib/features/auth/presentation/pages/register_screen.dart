import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onBack;

  const RegisterScreen({super.key, required this.onLogin, this.onBack});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool showPassword = false;
  String selectedLevel = 'A1';
  bool agreed = false;

  final levels = ['A1', 'A2', 'B1', 'B2'];

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(authControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }

      if (next.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account created successfully")),
        );

        widget.onLogin();
      }
    });
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
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "إنشاء حساب جديد",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textForeground,
            ),
          ),
          Text(
            "ابدأ رحلتك التعليمية اليوم",
            style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, AuthState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: context.pagePadding,
        vertical: 16,
      ),
      child: _buildFormContent(context, state),
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context, AuthState state) {
    return Row(
      children: [
        // Side Branding Banner
        Expanded(
          flex: context.isDesktop ? 5 : 4,
          child: const SizedBox.expand(child: HeaderAuth()),
        ),
        // Auth Form Side Card
        Expanded(
          flex: 6,
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.pagePadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Card(
                  elevation: context.isDesktop ? 2 : 0,
                  color: context.isDesktop ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(context.isDesktop ? 32 : 16),
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
                              onPressed:
                                  widget.onBack ??
                                  () => Navigator.maybePop(context),
                            ),
                          ),
                        const Text(
                          "إنشاء حساب جديد 🚀",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textForeground,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "ابدأ رحلتك التعليمية اليوم معنا",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildFormContent(context, state),
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

  Widget _buildFormContent(BuildContext context, AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: AuthTextField(
                controller: firstNameController,
                label: "الاسم الأول",
                hint: "Ahmed",
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AuthTextField(
                controller: lastNameController,
                label: "اسم العائلة",
                hint: "Kareem",
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        AuthTextField(
          controller: emailController,
          label: "البريد الإلكتروني",
          hint: "example@email.com",
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        AuthTextField(
          controller: phoneController,
          label: "رقم الهاتف",
          hint: "+20xxxxxxxxxx",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),

        AuthTextField(
          controller: passwordController,
          label: "كلمة المرور",
          hint: "••••••••",
          icon: Icons.lock_outline,
          obscureText: !showPassword,
          suffix: IconButton(
            onPressed: () => setState(() => showPassword = !showPassword),
            icon: Icon(
              showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.mutedForeground,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          "مستواك في الهولندية",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textForeground,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: levels.map((lvl) {
            final isSelected = selectedLevel == lvl;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => setState(() => selectedLevel = lvl),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      lvl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.mutedForeground,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),

        /// Terms Checkbox Row
        GestureDetector(
          onTap: () => setState(() => agreed = !agreed),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: agreed ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: agreed ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: agreed
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text.rich(
                  TextSpan(
                    text: "أوافق على ",
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontSize: 13,
                    ),
                    children: [
                      TextSpan(
                        text: "شروط الاستخدام",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: " و "),
                      TextSpan(
                        text: "سياسة الخصوصية",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        /// Register Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: agreed ? 1.0 : 0.5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: agreed
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: ElevatedButton(
                onPressed: !agreed || state.isLoading
                    ? null
                    : () async {
                        await ref
                            .read(authControllerProvider.notifier)
                            .register(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              level: DutchLevel.values.byName(
                                selectedLevel.toLowerCase(),
                              ),
                              phoneNumber: phoneController.text.trim(),
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
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "إنشاء الحساب 🚀",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        /// Footer Navigation Back to Login
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "لديك حساب بالفعل؟ ",
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 13,
                ),
              ),
              GestureDetector(
                onTap: widget.onLogin,
                child: const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
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
}
