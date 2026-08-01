import 'package:flutter/material.dart';
import 'package:hollandkompas/core/localization/app_direction.dart';

import 'package:hollandkompas/core/theme/app_colors.dart';

import '../widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    this.onRegister,
    this.onForgot,
  });

  final VoidCallback onLogin;
  final VoidCallback? onRegister;
  final VoidCallback? onForgot;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final isRtl =
        AppDirection.isRtl(Localizations.localeOf(context));

    return Directionality(
      textDirection:
          isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [

              /// Header
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "🇳🇱",
                              style: TextStyle(fontSize: 34),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "HollandKompas",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "بوصلتك نحو اللغة الهولندية",
                            style: TextStyle(
                              color: Colors.white.withOpacity(.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      24, 8, 24, 32),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      Text(
                        "مرحباً بعودتك 👋",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "سجّل الدخول لمتابعة تعلمك",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color:
                                  AppColors.mutedForeground,
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

                      const SizedBox(height: 18),

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
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      AuthTextField(
                      controller: emailController,
                      label: "البريد الإلكتروني",
                      hint: "example@email.com",
                      icon: Icons.mail_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 18),

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
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                  ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgot,
                          child: const Text(
                            "نسيت كلمة المرور؟",
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient:
                                const LinearGradient(
                              colors: [
                                AppColors.primary,
                                Color(0xffE55A00),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(18),
                          ),
                          child: ElevatedButton(
                            onPressed: widget.onLogin,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.transparent,
                              shadowColor:
                                  Colors.transparent,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        18),
                              ),
                            ),
                            child: const Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Text(
                              "أو",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors
                                        .mutedForeground,
                                  ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Text("🔵"),
                              label: const Text("Google"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Text("🍎"),
                              label: const Text("Apple"),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      Center(
                        child: Wrap(
                          crossAxisAlignment:
                              WrapCrossAlignment.center,
                          children: [
                            Text(
                              "ليس لديك حساب؟",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors
                                        .mutedForeground,
                                  ),
                            ),
                            TextButton(
                              onPressed:
                                  widget.onRegister,
                              child: const Text(
                                "إنشاء حساب جديد",
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}