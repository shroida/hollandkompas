import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/responsive/responsive_extension.dart';
import 'package:hollandkompas/core/shared/widget/course_terms_dialog.dart';
import 'package:hollandkompas/core/shared/widget/theme_toggle_button.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/domain/enums/dutch_level.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_state.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/header_auth.dart';
import 'package:hollandkompas/features/auth/presentation/widgets/level_selector.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key, required this.onLogin, this.onBack});

  final VoidCallback onLogin;
  final VoidCallback? onBack;

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static const _levels = ['A1', 'A2', 'B1', 'B2'];

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  String _selectedLevel = 'A1';
  bool _agreed = false;

  @override
  void initState() {
    super.initState();

    ref.listenManual<AuthState>(authControllerProvider, (previous, next) {
      if (!mounted) {
        return;
      }

      if (next.user != null && previous?.user == null) {
        widget.onLogin();
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((state) => state.isLoading),
    );

    final error = ref.watch(
      authControllerProvider.select((state) => state.error),
    );

    final form = _buildFormContent(context, isLoading: isLoading, error: error);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            context.isMobile
                ? _buildMobileLayout(context, form)
                : _buildDesktopTabletLayout(context, form),
            ThemeToggle(ref: ref, context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Widget form) {
    return Column(
      children: [
        const HeaderAuth(),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(
              horizontal: context.pagePadding,
              vertical: 16,
            ),
            child: form,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTabletLayout(BuildContext context, Widget form) {
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                    child: form,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFormContent(
    BuildContext context, {
    required bool isLoading,
    required String? error,
  }) {
    final textColor = AppColors.textColor(context);
    final subtitleColor = AppColors.subtitleColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'إنشاء حساب جديد 🚀',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'ابدأ رحلتك التعليمية اليوم معنا',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: subtitleColor,
          ),
        ),
        const SizedBox(height: 28),
        _buildNameFields(context),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _emailController,
          label: 'البريد الإلكتروني',
          hint: 'example@email.com',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _phoneController,
          label: 'رقم الهاتف',
          hint: '+20xxxxxxxxxx',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        AuthTextField(
          controller: _passwordController,
          label: 'كلمة المرور',
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscureText: !_showPassword,
          suffix: IconButton(
            onPressed: _togglePassword,
            icon: Icon(
              _showPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: subtitleColor,
              size: 20,
            ),
          ),
        ),
        const SizedBox(height: 22),
        _buildLevelSelector(context),
        const SizedBox(height: 20),
        _buildTermsAgreement(context),
        const SizedBox(height: 24),
        _buildRegisterButton(isLoading),
        if (error != null) ...[
          const SizedBox(height: 12),
          _buildErrorMessage(error),
        ],
        const SizedBox(height: 24),
        _buildDivider(context),
        const SizedBox(height: 24),
        _buildSocialButtons(context, textColor),
        const SizedBox(height: 28),
        _buildLoginFooter(context, subtitleColor),
      ],
    );
  }

  Widget _buildNameFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AuthTextField(
            controller: _firstNameController,
            label: 'الاسم الأول',
            hint: 'Ahmed',
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AuthTextField(
            controller: _lastNameController,
            label: 'اسم العائلة',
            hint: 'Kareem',
            icon: Icons.person_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelSelector(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مستواك في الهولندية',
          style: textTheme.bodyMedium?.copyWith(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        LevelSelector(
          levels: _levels,
          selectedLevel: _selectedLevel,
          onChanged: _handleLevelChanged,
        ),
      ],
    );
  }

  Widget _buildTermsAgreement(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subtitleColor = AppColors.subtitleColor(context);

    return InkWell(
      onTap: () {
        setState(() {
          _agreed = !_agreed;
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 21,
              height: 21,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: _agreed ? colorScheme.primary : colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _agreed
                      ? colorScheme.primary
                      : AppColors.borderColor(context),
                  width: _agreed ? 0 : 1.5,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _agreed
                    ? Icon(
                        Icons.check_rounded,
                        key: const ValueKey(true),
                        size: 15,
                        color: colorScheme.onPrimary,
                      )
                    : const SizedBox(key: ValueKey(false)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: 'أوافق على ',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: subtitleColor,
                    fontSize: 13,
                  ),
                  children: [
                    TextSpan(
                      text: 'شروط الاستخدام',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: colorScheme.primary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          showDialog<void>(
                            context: context,
                            builder: (_) => const CourseTermsDialog(),
                          );
                        },
                    ),
                    TextSpan(
                      text: ' و ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: subtitleColor,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: colorScheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: colorScheme.primary,
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

  Widget _buildRegisterButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (_agreed)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.30),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _agreed && !isLoading ? _register : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.white,
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'إنشاء الحساب 🚀',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String error) {
    return Container(
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
              error,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.destructive,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.borderColor(context))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'أو',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.subtitleColor(context),
              fontSize: 12,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.borderColor(context))),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context, Color textColor) {
    return Row(
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
            icon: const Text('🔵', style: TextStyle(fontSize: 16)),
            label: Text(
              'Google',
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
            icon: const Text('🍎', style: TextStyle(fontSize: 16)),
            label: Text(
              'Apple',
              style: TextStyle(fontFamily: 'Cairo', color: textColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginFooter(BuildContext context, Color subtitleColor) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            'لديك حساب بالفعل؟ ',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: subtitleColor,
              fontSize: 13,
            ),
          ),
          GestureDetector(
            onTap: widget.onLogin,
            child: const Text(
              'تسجيل الدخول',
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
    );
  }

  void _togglePassword() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _handleLevelChanged(String level) {
    if (_selectedLevel == level) {
      return;
    }

    setState(() {
      _selectedLevel = level;
    });
  }

  Future<void> _register() async {
    if (!_agreed) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .register(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          level: DutchLevel.values.byName(_selectedLevel.toLowerCase()),
          phoneNumber: _phoneController.text.trim(),
        );
  }
}
