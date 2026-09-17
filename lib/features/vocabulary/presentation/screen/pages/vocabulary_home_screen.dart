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

  void _log(String message) {
    debugPrint('[VOCAB-HOME] $message');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _log('BUILD');

    final wordsAsync = ref.watch(vocabularyWordsProvider);

    final dailyWordAsync = ref.watch(dailyVocabularyWordProvider);

    _log('wordsAsync=$wordsAsync');

    _log('dailyWordAsync=$dailyWordAsync');

    return Scaffold(
      appBar: AppBar(
        title: const Text('قاعدة كلمات'),
        actions: [
          IconButton(
            tooltip: 'المفضلة',
            onPressed: () {
              context.push(RoutePaths.vocabularyFavorites);
            },
            icon: const Icon(Icons.bookmark_border),
          ),
          IconButton(
            tooltip: 'التقدم',
            onPressed: () {
              context.push(RoutePaths.vocabularyProgress);
            },
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RoutePaths.vocabularySearch);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _log('MANUAL REFRESH START');

          ref.invalidate(vocabularyWordsProvider);
          ref.invalidate(dailyVocabularyWordProvider);

          try {
            await ref.read(vocabularyWordsProvider.future);

            _log('MANUAL REFRESH SUCCESS');
          } catch (error, stackTrace) {
            _log('MANUAL REFRESH FAILED: $error');

            debugPrintStack(stackTrace: stackTrace);

            rethrow;
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: dailyWordAsync.when(
                  data: (word) {
                    return DailyWordCard(
                      word: word,
                      onTap: () {
                        context.push(RoutePaths.vocabularyWord, extra: word);
                      },
                    );
                  },
                  loading: () {
                    return const SizedBox(
                      height: 110,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  error: (error, stackTrace) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, size: 40),
                          const SizedBox(height: 8),
                          const Text(
                            'خطأ في تحميل كلمة اليوم',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text('$error', textAlign: TextAlign.center),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            const SliverToBoxAdapter(
              child: LevelFilterTabs(
                levels: ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'],
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            const SliverToBoxAdapter(
              child: CategoryFilterChips(
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

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            wordsAsync.when(
              data: (words) {
                if (words.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: Text('مفيش كلمات في القسم ده لسه')),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverList.builder(
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: WordCard(
                          word: word,
                          onTap: () {
                            context.push(
                              '/vocabulary/word/${word.id}',
                              extra: word,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },

              loading: () {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },

              error: (error, stackTrace) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 12),
                        const Text(
                          'خطأ في تحميل الكلمات',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        SelectableText('$error', textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            ref.invalidate(vocabularyWordsProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
