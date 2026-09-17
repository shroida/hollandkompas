import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../providers/vocabulary_user_providers.dart';
import '../widgets/word_card.dart';

class FavoriteWordsScreen extends ConsumerWidget {
  const FavoriteWordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteVocabularyWordsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        title: const Text('المفضلة'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.cardColor(context),
        onRefresh: () {
          return ref
              .read(vocabularyActionsProvider.notifier)
              .refreshVocabulary();
        },
        child: favoritesAsync.when(
          data: (words) {
            if (words.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.all(32),
                children: const [
                  SizedBox(height: 120),
                  Center(
                    child: Text(
                      'لسه معملتش حفظ لأي كلمة.\n'
                      'دوس على أيقونة الحفظ جنب أي كلمة.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RepaintBoundary(
                    child: WordCard(
                      word: word,
                      onTap: () {
                        context.push(RoutePaths.vocabularyWord, extra: word);
                      },
                    ),
                  ),
                );
              },
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          },
          error: (error, _) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Text('حصل خطأ: $error', textAlign: TextAlign.center),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
