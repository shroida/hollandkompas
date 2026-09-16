import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../providers/vocabulary_list_providers.dart';
import '../widgets/category_filter_chips.dart';
import '../widgets/daily_word_card.dart';
import '../widgets/level_filter_tabs.dart';
import '../widgets/word_card.dart';

class VocabularyHomeScreen extends ConsumerWidget {
  const VocabularyHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordsAsync = ref.watch(vocabularyWordsProvider);
    final dailyWordAsync = ref.watch(dailyVocabularyWordProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('قاعدة كلمات'),
        actions: [
          IconButton(
            tooltip: 'المفضلة',
            onPressed: () => context.push('/vocabulary/favorites'),
            icon: const Icon(Icons.bookmark_border),
          ),
          IconButton(
            tooltip: 'التقدم',
            onPressed: () => context.push('/vocabulary/progress'),
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/vocabulary/search'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.search, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(vocabularyWordsProvider);
          ref.invalidate(dailyVocabularyWordProvider);
          await ref.read(vocabularyWordsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: dailyWordAsync.when(
                data: (word) => DailyWordCard(
                  word: word,
                  onTap: () => context.push('/vocabulary/word/${word.id}', extra: word),
                ),
                loading: () => const SizedBox(
                  height: 110,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 14),
            const LevelFilterTabs(),
            const SizedBox(height: 10),
            const CategoryFilterChips(),
            const SizedBox(height: 14),
            wordsAsync.when(
              data: (words) {
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
                            onTap: () => context.push(
                              '/vocabulary/word/${word.id}',
                              extra: word,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('حصل خطأ: $error')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
