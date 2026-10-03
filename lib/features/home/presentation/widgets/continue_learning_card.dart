import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/continue_learning.dart';
import 'package:hollandkompas/features/home/presentation/providers/continue_learning_provider.dart';

class ContinueLearningCard extends ConsumerStatefulWidget {
  const ContinueLearningCard({super.key, required this.data});

  final ContinueLearning data;

  @override
  ConsumerState<ContinueLearningCard> createState() =>
      _ContinueLearningCardState();
}

class _ContinueLearningCardState extends ConsumerState<ContinueLearningCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final progress = widget.data.progress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _pressed = true);
        },
        onTapUp: (_) {
          setState(() => _pressed = false);
        },
        onTapCancel: () {
          setState(() => _pressed = false);
        },
        onTap: () => _openLesson(context),
        child: AnimatedScale(
          scale: _pressed
              ? 0.985
              : _hovered
              ? 1.008
              : 1,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark
                        ? (_hovered ? 0.25 : 0.16)
                        : (_hovered ? 0.12 : 0.07),
                  ),
                  blurRadius: _hovered ? 28 : 18,
                  spreadRadius: _hovered ? 1 : 0,
                  offset: Offset(0, _hovered ? 10 : 6),
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              color: theme.cardColor,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContinueLearningHeader(
                      data: widget.data,
                      strings: strings,
                      hovered: _hovered,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.data.lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.25,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      strings.lessonNumber(
                        widget.data.currentIndex + 1,
                        widget.data.lessons.length,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.subtitleColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _ProgressIndicator(progress: progress, percent: percent),
                    const SizedBox(height: 18),
                    _ContinueButton(
                      label: strings.continueButton,
                      hovered: _hovered,
                      onTap: () => _openLesson(context),
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

  void _openLesson(BuildContext context) {
    context.push(
      RoutePaths.lessonViewer,
      extra: {
        'course': widget.data.course,
        'lesson': widget.data.lesson,
        'lessons': widget.data.lessons,
        'currentIndex': widget.data.currentIndex,
        'isEnrolled': true,
        'totalLessons': widget.data.lessons.length,
      },
    );
  }
}

class _ContinueLearningHeader extends StatelessWidget {
  const _ContinueLearningHeader({
    required this.data,
    required this.strings,
    required this.hovered,
  });

  final ContinueLearning data;
  final AppStrings strings;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        _ContinueLearningIcon(hovered: hovered),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.continueLearning,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                data.course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _CourseLevelBadge(level: data.course.level),
      ],
    );
  }
}

class _ContinueLearningIcon extends StatelessWidget {
  const _ContinueLearningIcon({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: hovered ? 54 : 50,
      height: hovered ? 54 : 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: hovered ? 0.25 : 0.14),
            blurRadius: hovered ? 14 : 8,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: AnimatedRotation(
        turns: hovered ? 0.015 : 0,
        duration: const Duration(milliseconds: 220),
        child: const Icon(
          Icons.play_lesson_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class _CourseLevelBadge extends StatelessWidget {
  const _CourseLevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({required this.progress, required this.percent});

  final double progress;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 9,
                  backgroundColor: AppColors.muted,
                  color: AppColors.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            '$percent%',
            key: ValueKey(percent),
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({
    required this.label,
    required this.hovered,
    required this.onTap,
  });

  final String label;
  final bool hovered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: AnimatedSlide(
          offset: hovered ? const Offset(0.08, 0) : Offset.zero,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: const Icon(Icons.play_arrow_rounded, size: 20),
        ),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        style: FilledButton.styleFrom(
          elevation: hovered ? 3 : 0,
          shadowColor: AppColors.primary.withValues(alpha: 0.25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
        ),
      ),
    );
  }
}

class ContinueLearningSection extends ConsumerWidget {
  const ContinueLearningSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(continueLearningProvider);

    return state.when(
      loading: () => const _ContinueLearningLoading(),
      error: (error, _) => _ContinueLearningError(message: error.toString()),
      data: (data) => data == null
          ? const _NoContinueLearning()
          : ContinueLearningCard(data: data),
    );
  }
}

class _ContinueLearningLoading extends StatelessWidget {
  const _ContinueLearningLoading();

  @override
  Widget build(BuildContext context) {
    return const _ContinueLearningContainer(
      child: SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _NoContinueLearning extends ConsumerWidget {
  const _NoContinueLearning();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);
    final theme = Theme.of(context);

    return _ContinueLearningContainer(
      child: Row(
        children: [
          const _EmptyLearningIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  strings.noLessonToContinue,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  strings.startOrCompleteLesson,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLearningIcon extends StatelessWidget {
  const _EmptyLearningIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.play_lesson_rounded, color: AppColors.primary),
    );
  }
}

class _ContinueLearningError extends ConsumerWidget {
  const _ContinueLearningError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);
    final theme = Theme.of(context);

    return _ContinueLearningContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.destructive,
            size: 32,
          ),
          const SizedBox(height: 10),
          Text(
            strings.unableToLoadContinueLearning,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContinueLearningContainer extends StatelessWidget {
  const _ContinueLearningContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }
}
