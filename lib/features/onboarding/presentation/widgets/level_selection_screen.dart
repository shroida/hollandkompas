import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen>
    with SingleTickerProviderStateMixin {
  static const _levels = [
    ('A1', 'مبتدئ', 'ابدأ من الأساسيات'),
    ('A2', 'أساسي', 'طوّر مهاراتك'),
    ('B1', 'متوسط', 'تحدث بثقة أكبر'),
    ('B2', 'متقدم', 'طلاقة وممارسة'),
  ];

  late final AnimationController _controller;

  String _selectedLevel = 'A1';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectLevel(String level) {
    if (_selectedLevel == level) {
      return;
    }

    setState(() {
      _selectedLevel = level;
    });
  }

  void _startJourney() {
    context.go(RoutePaths.register);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOut,
                    ),
                    child: SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'اختر مستواك الحالي',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سنستخدم اختيارك لتخصيص رحلة تعلم الهولندية لك.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitleColor(context),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _levels.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.35,
                          ),
                      itemBuilder: (context, index) {
                        final level = _levels[index];

                        return _LevelCard(
                          code: level.$1,
                          label: level.$2,
                          description: level.$3,
                          selected: _selectedLevel == level.$1,
                          onTap: () => _selectLevel(level.$1),
                        );
                      },
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.20),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _startJourney,
                            borderRadius: BorderRadius.circular(18),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'ابدأ رحلتك',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 21,
                                  ),
                                ],
                              ),
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
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({
    required this.code,
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = selected
        ? (isDark
              ? AppColors.primary.withValues(alpha: 0.16)
              : AppColors.primary.withValues(alpha: 0.08))
        : AppColors.cardColor(context);

    final codeColor = selected
        ? (isDark ? AppColors.background : AppColors.primary)
        : AppColors.textColor(context);

    final labelColor = selected
        ? AppColors.textColor(context)
        : AppColors.textColor(context);

    final descriptionColor = selected
        ? AppColors.subtitleColor(context)
        : AppColors.subtitleColor(context);

    final borderColor = selected
        ? AppColors.primary
        : AppColors.borderColor(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedScale(
          scale: selected ? 1.025 : 1,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: selected ? 2 : 1),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: isDark ? 0.18 : 0.14,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ]
                  : null,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: AnimatedScale(
                    scale: selected ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutBack,
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style:
                          textTheme.headlineMedium?.copyWith(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: codeColor,
                          ) ??
                          TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: codeColor,
                          ),
                      child: Text(code),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style:
                          textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: labelColor,
                          ) ??
                          TextStyle(
                            fontWeight: FontWeight.w700,
                            color: labelColor,
                          ),
                      child: Text(label),
                    ),
                    const SizedBox(height: 3),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 250),
                      style:
                          textTheme.bodySmall?.copyWith(
                            color: descriptionColor,
                          ) ??
                          TextStyle(color: descriptionColor),
                      child: Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
