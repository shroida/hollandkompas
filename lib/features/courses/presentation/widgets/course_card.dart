import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/course_image.dart';

class CourseCard extends ConsumerStatefulWidget {
  const CourseCard({
    super.key,
    required this.course,
    this.isEnrolled = false,
    this.onTap,
  });

  final Course course;
  final bool isEnrolled;
  final VoidCallback? onTap;

  static const _radius = 18.0;

  @override
  ConsumerState<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends ConsumerState<CourseCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(
      appLocaleProvider.select((locale) => locale.languageCode),
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subtitleColor = AppColors.subtitleColor(context);
    final description = widget.course.getDescription(languageCode);

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
        onTap: widget.onTap,
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
              borderRadius: BorderRadius.circular(CourseCard._radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark
                        ? (_hovered ? 0.28 : 0.18)
                        : (_hovered ? 0.14 : 0.08),
                  ),
                  blurRadius: _hovered ? 26 : 18,
                  spreadRadius: _hovered ? 1 : 0,
                  offset: Offset(0, _hovered ? 10 : 6),
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              color: theme.cardColor,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CourseCard._radius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CourseImageHeader(
                    course: widget.course,
                    hovered: _hovered,
                    isEnrolled: widget.isEnrolled,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              LevelBadge(level: widget.course.level),
                              const Spacer(),
                              if (widget.isEnrolled) _EnrolledBadge(),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.course.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: Text(
                              description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.45,
                                color: subtitleColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _CourseBottomBar(
                            course: widget.course,
                            isEnrolled: widget.isEnrolled,
                            subtitleColor: subtitleColor,
                            onTap: widget.onTap,
                          ),
                        ],
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

class _CourseImageHeader extends StatelessWidget {
  const _CourseImageHeader({
    required this.course,
    required this.hovered,
    required this.isEnrolled,
  });

  final Course course;
  final bool hovered;
  final bool isEnrolled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRect(
            child: AnimatedScale(
              scale: hovered ? 1.035 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: CourseImage(course: course),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.45, 1],
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.52),
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Row(
              children: [
                _CourseTypePill(
                  icon: isEnrolled
                      ? Icons.play_circle_fill_rounded
                      : Icons.menu_book_rounded,
                  label: isEnrolled ? 'Continue' : 'Course',
                ),
                const Spacer(),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: hovered ? 0.22 : 0.16,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Text(
                    course.level.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                    ),
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

class _CourseTypePill extends StatelessWidget {
  const _CourseTypePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnrolledBadge extends StatelessWidget {
  const _EnrolledBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
          SizedBox(width: 4),
          Text(
            'Enrolled',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseBottomBar extends StatelessWidget {
  const _CourseBottomBar({
    required this.course,
    required this.isEnrolled,
    required this.subtitleColor,
    required this.onTap,
  });

  final Course course;
  final bool isEnrolled;
  final Color subtitleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          isEnrolled ? Icons.play_lesson_rounded : Icons.menu_book_rounded,
          size: 18,
          color: AppColors.primary,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            isEnrolled ? 'Continue learning' : 'Dutch course',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtitleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${course.price} EGP',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 10),
        _CourseCardAction(onTap: onTap, isEnrolled: isEnrolled),
      ],
    );
  }
}

class _CourseCardAction extends StatefulWidget {
  const _CourseCardAction({required this.onTap, required this.isEnrolled});

  final VoidCallback? onTap;
  final bool isEnrolled;

  @override
  State<_CourseCardAction> createState() => _CourseCardActionState();
}

class _CourseCardActionState extends State<_CourseCardAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
      },
      onExit: (_) {
        setState(() => _hovered = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        width: _hovered ? 44 : 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(
                alpha: _hovered ? 0.28 : 0.12,
              ),
              blurRadius: _hovered ? 12 : 7,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Center(
              child: AnimatedRotation(
                turns: _hovered ? 0.02 : 0,
                duration: const Duration(milliseconds: 180),
                child: Icon(
                  widget.isEnrolled
                      ? Icons.play_arrow_rounded
                      : Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelBadge extends StatelessWidget {
  const LevelBadge({super.key, required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
