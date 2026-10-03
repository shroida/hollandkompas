import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/app_strings.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../presentation/providers/flashcards_controller.dart';

class FlashcardsHomeCard extends ConsumerStatefulWidget {
  const FlashcardsHomeCard({super.key});

  @override
  ConsumerState<FlashcardsHomeCard> createState() => _FlashcardsHomeCardState();
}

class _FlashcardsHomeCardState extends ConsumerState<FlashcardsHomeCard> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardsControllerProvider);

    final locale = ref.watch(appLocaleProvider);
    final strings = AppStrings(locale);

    final dueToday = state.stats?.dueToday ?? 0;
    final weakWords = state.stats?.weakWords ?? 0;
    final total = state.stats?.total ?? 0;

    final isActive = _hovered || _pressed;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _pressed
            ? 0.985
            : _hovered
            ? 1.008
            : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isActive ? 0.09 : 0.045),
                blurRadius: isActive ? 24 : 14,
                offset: Offset(0, isActive ? 10 : 5),
              ),
            ],
          ),
          child: Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(22),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => context.push(RoutePaths.flashcards),
              onHighlightChanged: (pressed) {
                setState(() => _pressed = pressed);
              },
              borderRadius: BorderRadius.circular(22),
              splashColor: AppColors.primary.withValues(alpha: 0.06),
              highlightColor: AppColors.primary.withValues(alpha: 0.025),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _FlashcardsIcon(hovered: isActive),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _FlashcardsHeader(
                            strings: strings,
                            total: total,
                            isLoading: state.isLoading,
                            hovered: isActive,
                          ),
                        ),
                        _FlashcardsArrow(hovered: isActive),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axisAlignment: -1,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: state.isLoading
                          ? const SizedBox.shrink(key: ValueKey('loading'))
                          : Padding(
                              key: const ValueKey('stats'),
                              padding: const EdgeInsets.only(top: 18),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _StatItem(
                                      icon: Icons.today_rounded,
                                      value: '$dueToday',
                                      label: strings.dueToday,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _StatItem(
                                      icon: Icons.warning_amber_rounded,
                                      value: '$weakWords',
                                      label: strings.weakWords,
                                      color: AppColors.destructive,
                                    ),
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
      ),
    );
  }
}

class _FlashcardsIcon extends StatelessWidget {
  const _FlashcardsIcon({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentColor(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: hovered ? 58 : 54,
      height: hovered ? 58 : 54,
      decoration: BoxDecoration(
        color: accent,
        borderRadius: BorderRadius.circular(17),
      ),
      child: AnimatedScale(
        scale: hovered ? 1.08 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        child: const Icon(
          Icons.style_rounded,
          color: AppColors.primary,
          size: 29,
        ),
      ),
    );
  }
}

class _FlashcardsHeader extends StatelessWidget {
  const _FlashcardsHeader({
    required this.strings,
    required this.total,
    required this.isLoading,
    required this.hovered,
  });

  final AppStrings strings;
  final int total;
  final bool isLoading;
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          style:
              textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800) ??
              const TextStyle(fontWeight: FontWeight.w800),
          child: Text(
            strings.flashcards,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 5),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          switchInCurve: Curves.easeOutCubic,
          child: Text(
            isLoading
                ? strings.loadingYourWords
                : strings.wordsReadyForReview(total),
            key: ValueKey(isLoading ? 'loading' : 'total-$total'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ),
      ],
    );
  }
}

class _FlashcardsArrow extends StatelessWidget {
  const _FlashcardsArrow({required this.hovered});

  final bool hovered;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: hovered ? 41 : 38,
      height: hovered ? 41 : 38,
      decoration: BoxDecoration(
        color: hovered
            ? AppColors.primary.withValues(alpha: 0.10)
            : AppColors.mutedColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hovered
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
        ),
      ),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        offset: hovered ? const Offset(0.08, 0) : Offset.zero,
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: hovered
              ? AppColors.primary
              : Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.mutedColor(context),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 19, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
