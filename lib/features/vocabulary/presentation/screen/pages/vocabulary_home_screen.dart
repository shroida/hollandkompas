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
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: dailyWordAsync.when(
                data: (word) {
                  _log('DAILY WORD DATA: ${word.dutchWord}');

                  return DailyWordCard(
                    word: word,
                    onTap: () {
                      context.push(RoutePaths.vocabularyWord, extra: word);
                    },
                  );
                },
                loading: () {
                  _log('DAILY WORD LOADING');

                  return const SizedBox(
                    height: 110,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                error: (error, stackTrace) {
                  _log('DAILY WORD ERROR: $error');

                  debugPrintStack(stackTrace: stackTrace);

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

            const SizedBox(height: 14),

            LevelFilterTabs(levels: const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']),

            const SizedBox(height: 10),

            CategoryFilterChips(
              categories: const [
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

            const SizedBox(height: 14),

            wordsAsync.when(
              data: (words) {
                _log('WORDS DATA: ${words.length} words');

                if (words.isNotEmpty) {
                  _log(
                    'FIRST WORD: '
                    '${words.first.dutchWord} | '
                    'level=${words.first.level} | '
                    'category=${words.first.category}',
                  );
                }

                if (words.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('مفيش كلمات في القسم ده لسه')),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      for (final word in words)
                        Padding(
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
                        ),
                    ],
                  ),
                );
              },
              loading: () {
                _log('WORDS LOADING');

                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              error: (error, stackTrace) {
                _log('WORDS ERROR: $error');

                debugPrintStack(stackTrace: stackTrace);

                return Padding(
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
