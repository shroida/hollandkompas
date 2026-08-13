import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(authControllerProvider, (previous, next) {
      if (!mounted) return;

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }

      if (!next.isLoading &&
          next.error == null &&
          previous?.isLoading == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password updated successfully."),
            backgroundColor: Colors.green,
          ),
        );

        context.go("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: context.isMobile
            ? _mobile(context, state)
            : _desktop(context, state),
      ),
    );
  }

  Widget _mobile(BuildContext context, AuthState state) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.pagePadding),
        child: _content(state),
      ),
    );
  }

  Widget _desktop(BuildContext context, AuthState state) {
    return Row(
      children: [
        const Expanded(flex: 5, child: HeaderAuth()),
        Expanded(
          flex: 6,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: _content(state),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _content(AuthState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.lock_reset, color: AppColors.primary, size: 70),
        const SizedBox(height: 20),

        const Text(
          "Reset Password",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        const Text(
          "Choose a new password for your account.",
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        AuthTextField(
          controller: passwordController,
          label: "New Password",
          hint: "********",
          obscureText: !showPassword,
          icon: Icons.lock_outline,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
          ),
        ),

        const SizedBox(height: 16),

        AuthTextField(
          controller: confirmController,
          label: "Confirm Password",
          hint: "********",
          obscureText: !showConfirmPassword,
          icon: Icons.lock_outline,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                showConfirmPassword = !showConfirmPassword;
              });
            },
            icon: Icon(
              showConfirmPassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: state.isLoading
                ? null
                : () async {
                    if (passwordController.text.isEmpty ||
                        confirmController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields."),
                        ),
                      );
                      return;
                    }

                    if (passwordController.text != confirmController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Passwords do not match."),
                        ),
                      );
                      return;
                    }

                    await ref
                        .read(authControllerProvider.notifier)
                        .updatePassword(passwordController.text.trim());
                  },
            child: state.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Update Password"),
          ),
        ),
      ],
    );
  }
}
