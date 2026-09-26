import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class VocabularyHomeCard extends StatelessWidget {
  const VocabularyHomeCard({super.key});

  static const _borderRadius = 24.0;
  static const _contentPadding = 18.0;
  static const _iconSize = 58.0;
  static const _arrowSize = 42.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RoutePaths.vocabulary),
        borderRadius: BorderRadius.circular(_borderRadius),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(_contentPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: isDark
                  ? [
                      colorScheme.surface,
                      AppColors.darkMuted.withValues(alpha: 0.85),
                    ]
                  : [
                      colorScheme.surface,
                      AppColors.accent.withValues(alpha: 0.72),
                    ],
            ),
            border: Border.all(color: AppColors.borderColor(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.045),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              const _VocabularyIcon(),
              const SizedBox(width: 15),
              Expanded(
                child: _VocabularyContent(
                  textTheme: theme.textTheme,
                  subtitleColor: AppColors.subtitleColor(context),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              _VocabularyArrow(
                backgroundColor: isDark
                    ? AppColors.primary.withValues(alpha: 0.16)
                    : colorScheme.surface,
                foregroundColor: isDark
                    ? AppColors.primary
                    : AppColors.subtitleColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VocabularyIcon extends StatelessWidget {
  const _VocabularyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: VocabularyHomeCard._iconSize,
      height: VocabularyHomeCard._iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            AppColors.primary.withValues(alpha: 0.18),
            AppColors.primary.withValues(alpha: 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 7,
            top: 7,
            child: Container(
              width: 7,
              height: 7,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Icon(
            Icons.menu_book_rounded,
            color: AppColors.primary,
            size: 29,
          ),
        ],
      ),
    );
  }
}

class _VocabularyContent extends StatelessWidget {
  const _VocabularyContent({
    required this.textTheme,
    required this.subtitleColor,
    required this.isDark,
  });

  final TextTheme textTheme;
  final Color subtitleColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Vocabulary',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                'WORDS',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          'Learn and review Dutch words',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: subtitleColor,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 13,
              color: AppColors.primary.withValues(alpha: 0.85),
            ),
            const SizedBox(width: 5),
            Text(
              'Build your vocabulary',
              style: textTheme.labelSmall?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.58)
                    : subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VocabularyArrow extends StatelessWidget {
  const _VocabularyArrow({
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: VocabularyHomeCard._arrowSize,
      height: VocabularyHomeCard._arrowSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.arrow_forward_rounded,
        size: 19,
        color: foregroundColor,
      ),
    );
  }
}
