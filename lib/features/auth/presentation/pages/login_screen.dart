import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
class LoginScreen extends StatefulWidget {
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            HeaderAuth(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "مرحباً بعودتك 👋",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textForeground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "سجّل الدخول لمتابعة تعلمك",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                    ),
                    const SizedBox(height: 24),

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
                        onPressed: () => setState(() => showPassword = !showPassword),
                        icon: Icon(
                          showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AppColors.mutedForeground,
                          size: 20,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
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
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Main Login Button
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
                              color: AppColors.primary.withOpacity(0.3),
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
                            "تسجيل الدخول",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// Divider
                    const Row(
                      children: [
                        Expanded(child: Divider(color: AppColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            "أو",
                            style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.border)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                            ),
                            icon: const Text("🔵", style: TextStyle(fontSize: 16)),
                            label: const Text("Google", style: TextStyle(color: AppColors.textForeground)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              backgroundColor: Colors.white,
                            ),
                            icon: const Text("🍎", style: TextStyle(fontSize: 16)),
                            label: const Text("Apple", style: TextStyle(color: AppColors.textForeground)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// Footer Register Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "ليس لديك حساب؟ ",
                            style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                          ),
                          GestureDetector(
                            onTap: widget.onRegister,
                            child: const Text(
                              "إنشاء حساب جديد",
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}// =============================================================================
// REGISTER SCREEN
// =============================================================================
class RegisterScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback? onBack;

  const RegisterScreen({
    super.key,
    required this.onLogin,
    this.onBack,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;
  String selectedLevel = 'A1';
  bool agreed = false;

  final levels = ['A1', 'A2', 'B1', 'B2'];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textForeground, size: 20),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "إنشاء حساب جديد",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textForeground),
              ),
              Text(
                "ابدأ رحلتك التعليمية اليوم",
                style: TextStyle(fontSize: 12, color: AppColors.mutedForeground),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AuthTextField(
                controller: nameController,
                label: "الاسم الكامل",
                hint: "أدخل اسمك",
                icon: Icons.person_outline,
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
                controller: passwordController,
                label: "كلمة المرور",
                hint: "••••••••",
                icon: Icons.lock_outline,
                obscureText: !showPassword,
                suffix: IconButton(
                  onPressed: () => setState(() => showPassword = !showPassword),
                  icon: Icon(
                    showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: AppColors.mutedForeground,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Level Selection
              const Text(
                "مستواك في الهولندية",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textForeground),
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
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            lvl,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : AppColors.mutedForeground,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              /// Terms Checkbox
              GestureDetector(
                onTap: () => setState(() => agreed = !agreed),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
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
                          style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
                          children: [
                            TextSpan(
                              text: "شروط الاستخدام",
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: " و "),
                            TextSpan(
                              text: "سياسة الخصوصية",
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Register Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Opacity(
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
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: agreed ? widget.onLogin : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text(
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

              /// Footer Login Link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "لديك حساب بالفعل؟ ",
                      style: TextStyle(color: AppColors.mutedForeground, fontSize: 13),
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
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// FORGOT PASSWORD SCREEN
// =============================================================================
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.textForeground, size: 20),
            onPressed: widget.onBack ?? () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: !isSent
                  ? Column(
                      key: const ValueKey("FormState"),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.mail_outline, size: 32, color: AppColors.primary),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "نسيت كلمة المرور؟",
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
                          style: TextStyle(fontSize: 14, color: AppColors.mutedForeground, height: 1.4),
                        ),
                        const SizedBox(height: 24),

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
                            ),
                            child: ElevatedButton(
                              onPressed: () => setState(() => isSent = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: const Text(
                                "إرسال رابط الاستعادة",
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
                    )
                  : Column(
                      key: const ValueKey("SuccessState"),
                      mainAxisSize: MainAxisSize.min,
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
                          style: TextStyle(fontSize: 14, color: AppColors.mutedForeground, height: 1.4),
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
                            ),
                            child: ElevatedButton(
                              onPressed: widget.onLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    ),
            ),
          ),
        ),
      ),
    );
  }
}