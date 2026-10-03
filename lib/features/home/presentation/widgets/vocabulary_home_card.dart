import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/localization/app_strings.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

class VocabularyHomeCard extends ConsumerStatefulWidget {
  const VocabularyHomeCard({super.key});

  static const _borderRadius = 24.0;
  static const _contentPadding = 18.0;
  static const _iconSize = 58.0;
  static const _arrowSize = 42.0;

  @override
  ConsumerState<VocabularyHomeCard> createState() => _VocabularyHomeCardState();
}

class _VocabularyHomeCardState extends ConsumerState<VocabularyHomeCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

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
        onTap: () => context.push(RoutePaths.vocabulary),
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
              borderRadius: BorderRadius.circular(
                VocabularyHomeCard._borderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark
                        ? (_hovered ? 0.24 : 0.15)
                        : (_hovered ? 0.11 : 0.045),
                  ),
                  blurRadius: _hovered ? 28 : 18,
                  spreadRadius: _hovered ? 1 : 0,
                  offset: Offset(0, _hovered ? 10 : 7),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.push(RoutePaths.vocabulary),
                borderRadius: BorderRadius.circular(
                  VocabularyHomeCard._borderRadius,
                ),
                splashColor: AppColors.primary.withValues(alpha: 0.08),
                highlightColor: AppColors.primary.withValues(alpha: 0.04),
                child: Ink(
                  width: double.infinity,
                  padding: const EdgeInsets.all(
                    VocabularyHomeCard._contentPadding,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      VocabularyHomeCard._borderRadius,
                    ),
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
                  ),
                  child: Row(
                    children: [
                      _VocabularyIcon(hovered: _hovered),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _VocabularyContent(
                          textTheme: theme.textTheme,
                          subtitleColor: AppColors.subtitleColor(context),
                          isDark: isDark,
                          strings: strings,
                          hovered: _hovered,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _VocabularyArrow(
                        hovered: _hovered,
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
            ),
          ),
        ),
      ),
    );
  }
}

class _VocabularyIcon extends StatelessWidget {
  const _VocabularyIcon({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: hovered
          ? VocabularyHomeCard._iconSize + 2
          : VocabularyHomeCard._iconSize,
      height: hovered
          ? VocabularyHomeCard._iconSize + 2
          : VocabularyHomeCard._iconSize,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            AppColors.primary.withValues(alpha: hovered ? 0.22 : 0.18),
            AppColors.primary.withValues(alpha: hovered ? 0.10 : 0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: hovered ? 0.20 : 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: hovered ? 0.16 : 0.0),
            blurRadius: hovered ? 16 : 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            end: hovered ? 6 : 7,
            top: hovered ? 6 : 7,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: hovered ? 8 : 7,
              height: hovered ? 8 : 7,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          AnimatedScale(
            scale: hovered ? 1.08 : 1,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutBack,
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppColors.primary,
              size: 29,
            ),
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
    required this.strings,
    required this.hovered,
  });

  final TextTheme textTheme;
  final Color subtitleColor;
  final bool isDark;
  final AppStrings strings;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                strings.vocabulary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const SizedBox(width: 7),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(
                  alpha: hovered ? 0.14 : 0.10,
                ),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                strings.words,
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
          strings.learnAndReviewDutchWords,
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
            AnimatedScale(
              scale: hovered ? 1.12 : 1,
              duration: const Duration(milliseconds: 180),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 13,
                color: AppColors.primary.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                strings.buildYourVocabulary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.58)
                      : subtitleColor,
                  fontWeight: FontWeight.w600,
                ),
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
    required this.hovered,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final bool hovered;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: hovered
          ? VocabularyHomeCard._arrowSize + 2
          : VocabularyHomeCard._arrowSize,
      height: hovered
          ? VocabularyHomeCard._arrowSize + 2
          : VocabularyHomeCard._arrowSize,
      decoration: BoxDecoration(
        color: hovered
            ? AppColors.primary.withValues(alpha: 0.12)
            : backgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hovered
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.borderColor(context),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: hovered ? 0.10 : 0),
            blurRadius: hovered ? 12 : 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: AnimatedSlide(
        offset: hovered ? const Offset(0.08, 0) : Offset.zero,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Icon(
          Icons.arrow_forward_rounded,
          size: 19,
          color: hovered ? AppColors.primary : foregroundColor,
        ),
      ),
    );
  }
}
