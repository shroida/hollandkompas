import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class VocabularyHomeCard extends StatelessWidget {
  const VocabularyHomeCard({super.key});

  static const _borderRadius = 22.0;
  static const _contentPadding = 18.0;
  static const _iconSize = 52.0;
  static const _arrowSize = 38.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RoutePaths.vocabulary),
        borderRadius: BorderRadius.circular(_borderRadius),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.all(_contentPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                colorScheme.surface,
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkMuted
                    : AppColors.accent,
              ],
            ),
            border: Border.all(color: AppColors.borderColor(context)),
          ),
          child: Row(
            children: [
              const _VocabularyIcon(),
              const SizedBox(width: 14),
              Expanded(
                child: _VocabularyContent(
                  textTheme: textTheme,
                  subtitleColor: AppColors.subtitleColor(context),
                ),
              ),
              const SizedBox(width: 12),
              _VocabularyArrow(
                backgroundColor: colorScheme.surface,
                foregroundColor: AppColors.subtitleColor(context),
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
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Icon(
        Icons.menu_book_rounded,
        color: AppColors.primary,
        size: 27,
      ),
    );
  }
}

class _VocabularyContent extends StatelessWidget {
  const _VocabularyContent({
    required this.textTheme,
    required this.subtitleColor,
  });

  final TextTheme textTheme;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vocabulary',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 3),
        Text(
          'Learn and review Dutch words',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: subtitleColor),
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
        borderRadius: BorderRadius.circular(13),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 15,
        color: foregroundColor,
      ),
    );
  }
}
