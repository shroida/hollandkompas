import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/vocabulary_user_providers.dart';
import '../widgets/word_card.dart';

class FavoriteWordsScreen extends ConsumerWidget {
  const FavoriteWordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoriteVocabularyWordsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة')),
      body: favoritesAsync.when(
        data: (words) {
          if (words.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('لسه معملتش حفظ لأي كلمة. دوس على أيقونة الحفظ جنب أي كلمة.'),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              for (final word in words)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: WordCard(
                    word: word,
                    onTap: () =>
                        context.push('/vocabulary/word/${word.id}', extra: word),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('حصل خطأ: $error')),
      ),
    );
  }
}
