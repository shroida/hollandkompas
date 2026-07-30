import 'package:flutter/material.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(
                  maxWidth: 500,
                ),
            child: Padding(
              padding:
                  const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    height: 200,
                    decoration:
                        const BoxDecoration(
                      gradient:
                          LinearGradient(
                        colors: [
                          Color(
                            0xFFFF6B00,
                          ),
                          Color(
                            0xFF1E3A8A,
                          ),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min,
                        children: [
                          Text(
                            '🇳🇱',
                            style: TextStyle(
                              fontSize: 48,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'HollandKompas',
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 24,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AuthTextField(
                    label:
                        'البريد الإلكتروني',
                    hint:
                        'example@email.com',
                    icon: Icons.mail,
                    controller:
                        emailController,
                  ),

                  const SizedBox(height: 16),

                  AuthTextField(
                    label: 'كلمة المرور',
                    icon: Icons.lock,
                    controller:
                        passwordController,
                    obscureText:
                        !showPassword,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword =
                              !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword
                            ? Icons
                                .visibility_off
                            : Icons
                                .visibility,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        'تسجيل الدخول',
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