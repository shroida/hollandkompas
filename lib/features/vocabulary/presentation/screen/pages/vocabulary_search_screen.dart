import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/vocabulary_list_providers.dart';
import '../widgets/word_card.dart';

class VocabularySearchScreen extends ConsumerStatefulWidget {
  const VocabularySearchScreen({super.key});

  @override
  ConsumerState<VocabularySearchScreen> createState() => _VocabularySearchScreenState();
}

class _VocabularySearchScreenState extends ConsumerState<VocabularySearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(vocabularySearchResultsProvider);
    final query = ref.watch(vocabularySearchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'دور بالهولندي أو بالعربي...',
            border: InputBorder.none,
          ),
          onChanged: (value) =>
              ref.read(vocabularySearchQueryProvider.notifier).set(value),
        ),
      ),
      body: query.trim().isEmpty
          ? const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('اكتب كلمة عشان تدور عليها')),
            )
          : resultsAsync.when(
              data: (words) {
                if (words.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('مفيش نتايج')),
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
                          onTap: () => context.push(
                            '/vocabulary/word/${word.id}',
                            extra: word,
                          ),
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
