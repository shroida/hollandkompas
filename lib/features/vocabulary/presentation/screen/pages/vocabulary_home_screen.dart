import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../providers/vocabulary_list_providers.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/daily_word_card.dart';
import '../widgets/level_filter_tabs.dart';
import '../widgets/word_card.dart';

class VocabularyHomeScreen extends ConsumerWidget {
  const VocabularyHomeScreen({super.key});

  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 1024;

  static const double _tabletMaxWidth = 900;
  static const double _desktopMaxWidth = 1400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(vocabularyWordsProvider);
    final dailyWordAsync = ref.watch(dailyVocabularyWordProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: _buildAppBar(context),
      floatingActionButton: _SearchButton(
        onTap: () {
          context.push(RoutePaths.vocabularySearch);
        },
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.cardColor(context),
        onRefresh: () async {
          ref.invalidate(vocabularyWordsProvider);
          ref.invalidate(dailyVocabularyWordProvider);

          await ref.read(vocabularyWordsProvider.future);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            final isTablet =
                width >= _mobileBreakpoint && width < _tabletBreakpoint;

            final isDesktop = width >= _tabletBreakpoint;

            final horizontalPadding = isDesktop
                ? 32.0
                : isTablet
                ? 28.0
                : 16.0;

            final maxContentWidth = isDesktop
                ? _desktopMaxWidth
                : isTablet
                ? _tabletMaxWidth
                : double.infinity;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontalPadding,
                          isDesktop ? 24 : 8,
                          horizontalPadding,
                          0,
                        ),
                        child: _DailyWordSection(
                          asyncValue: dailyWordAsync,
                          onWordTap: (word) {
                            context.push(
                              RoutePaths.vocabularyWord,
                              extra: word,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: isDesktop ? 32 : 22),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: const _SectionHeader(
                          icon: Icons.school_rounded,
                          title: 'اختر مستواك',
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: const LevelFilterTabs(
                          levels: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: isDesktop ? 28 : 22),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: const _SectionHeader(
                          icon: Icons.category_rounded,
                          title: 'التصنيفات',
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: const CategoryFilterChips(
                          categories: [
                            'verb',
                            'expression',
                            'phone',
                            'grammar',
                            'location',
                            'food',
                            'money',
                            'drink',
                            'question',
                            'pronoun',
                            'family',
                            'weather',
                            'time',
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: isDesktop ? 32 : 24),
                ),

                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: _WordsHeader(
                          count: wordsAsync.asData?.value.length,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                _buildWords(
                  context: context,
                  wordsAsync: wordsAsync,
                  maxContentWidth: maxContentWidth,
                  horizontalPadding: horizontalPadding,
                  isTablet: isTablet,
                  isDesktop: isDesktop,
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: isDesktop ? 120 : 100),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قاعدة كلمات',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'طوّر مفرداتك الهولندية',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
      actions: [
        _HeaderAction(
          icon: Icons.bookmark_border_rounded,
          tooltip: 'المفضلة',
          onTap: () {
            context.push(RoutePaths.vocabularyFavorites);
          },
        ),
        const SizedBox(width: 4),
        _HeaderAction(
          icon: Icons.insights_outlined,
          tooltip: 'التقدم',
          onTap: () {
            context.push(RoutePaths.vocabularyProgress);
          },
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildWords({
    required BuildContext context,
    required AsyncValue<List<dynamic>> wordsAsync,
    required double maxContentWidth,
    required double horizontalPadding,
    required bool isTablet,
    required bool isDesktop,
  }) {
    return wordsAsync.when(
      data: (words) {
        if (words.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: const _EmptyWordsState(),
                ),
              ),
            ),
          );
        }

        final crossAxisCount = isDesktop
            ? 3
            : isTablet
            ? 2
            : 1;

        if (crossAxisCount == 1) {
          return SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverList.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WordCard(
                    word: word,
                    onTap: () {
                      context.push('/vocabulary/word/${word.id}', extra: word);
                    },
                  ),
                );
              },
            ),
          );
        }

        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: words.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isDesktop ? 20 : 16,
                    mainAxisSpacing: isDesktop ? 20 : 16,
                    childAspectRatio: isDesktop ? 1.45 : 1.6,
                  ),
                  itemBuilder: (context, index) {
                    final word = words[index];

                    return WordCard(
                      word: word,
                      onTap: () {
                        context.push(
                          '/vocabulary/word/${word.id}',
                          extra: word,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(child: _WordsLoadingState());
      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _WordsErrorState(error: error, onRetry: () {}),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Icon(icon, size: 21, color: AppColors.textColor(context)),
          ),
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      elevation: 4,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      icon: const Icon(Icons.search_rounded),
      label: const Text(
        'بحث',
        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _DailyWordSection extends StatelessWidget {
  const _DailyWordSection({required this.asyncValue, required this.onWordTap});

  final AsyncValue<dynamic> asyncValue;
  final ValueChanged<dynamic> onWordTap;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: (word) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(
              icon: Icons.auto_awesome_rounded,
              title: 'كلمة اليوم',
              accent: true,
            ),
            const SizedBox(height: 10),
            DailyWordCard(word: word, onTap: () => onWordTap(word)),
          ],
        );
      },
      loading: () {
        return const _DailyWordLoading();
      },
      error: (error, stackTrace) {
        return _DailyWordError(
          onRetry: () {
            // RefreshIndicator handles the complete refresh.
          },
        );
      },
    );
  }
}

class _DailyWordLoading extends StatelessWidget {
  const _DailyWordLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _DailyWordError extends StatelessWidget {
  const _DailyWordError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'تعذر تحميل كلمة اليوم',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'اسحب الشاشة للأسفل للمحاولة مرة أخرى',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: accent ? AppColors.accent : AppColors.muted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: accent ? AppColors.primary : AppColors.secondary,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _WordsHeader extends StatelessWidget {
  const _WordsHeader({required this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _SectionHeader(icon: Icons.menu_book_rounded, title: 'الكلمات'),
        const Spacer(),
        if (count != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count كلمة',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}

class _WordsLoadingState extends StatelessWidget {
  const _WordsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          const SizedBox(
            width: 26,
            height: 26,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'جاري تحميل الكلمات...',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyWordsState extends StatelessWidget {
  const _EmptyWordsState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderColor(context)),
        ),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 28,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'مفيش كلمات هنا لسه',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'جرب تختار مستوى أو تصنيف مختلف.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WordsErrorState extends StatelessWidget {
  const _WordsErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardColor(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.destructive.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.destructive.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 28,
                color: AppColors.destructive,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'حصل خطأ في تحميل الكلمات',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '$error',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
