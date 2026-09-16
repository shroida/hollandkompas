import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_list_providers.dart';
import '../../providers/vocabulary_user_providers.dart';
import '../widgets/pronunciation_button.dart';
import '../widgets/vocabulary_labels.dart';

class WordDetailsScreen extends ConsumerWidget {
  const WordDetailsScreen({super.key, required this.wordId, this.initialWord});

  final String wordId;
  final VocabularyWord? initialWord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveAsync = ref.watch(vocabularyWordByIdProvider(wordId));

    return liveAsync.when(
      data: (liveWord) {
        return _DetailsBody(word: liveWord);
      },
      loading: () {
        if (initialWord != null) {
          return _DetailsBody(word: initialWord!);
        }

        return Scaffold(
          appBar: AppBar(),
          body: Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) {
        if (initialWord != null) {
          return _DetailsBody(word: initialWord!);
        }

        return Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('حصل خطأ: $error')),
        );
      },
    );
  }
}

class _DetailsBody extends ConsumerWidget {
  const _DetailsBody({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(word.category.labelAr),
        actions: [
          IconButton(
            tooltip: 'حفظ الكلمة',
            onPressed: () => ref
                .read(vocabularyActionsProvider.notifier)
                .toggleFavorite(word.id, !word.isFavorite),
            icon: Icon(
              word.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              color: word.isFavorite ? AppColors.primary : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  word.dutchWord,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              PronunciationButton(text: word.dutchWord, size: 30),
            ],
          ),
          if (word.pronunciation != null) ...[
            const SizedBox(height: 4),
            Text(
              word.pronunciation!,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(word.level.label)),
              Chip(
                avatar: Icon(word.category.icon, size: 16),
                label: Text(word.category.labelAr),
              ),
            ],
          ),
          const Divider(height: 32),
          _MeaningRow(label: 'المعنى بالعربي', value: word.arabicMeaning),
          if (word.germanMeaning != null)
            _MeaningRow(label: 'بالألماني', value: word.germanMeaning!),
          if (word.exampleSentenceDutch != null) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          word.exampleSentenceDutch!,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      PronunciationButton(text: word.exampleSentenceDutch!),
                    ],
                  ),
                  if (word.exampleSentenceArabic != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      word.exampleSentenceArabic!,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: AppColors.subtitleColor(context)),
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (word.synonyms.isNotEmpty) ...[
            const SizedBox(height: 18),
            _WordChipsSection(title: 'مرادفات', words: word.synonyms),
          ],
          if (word.antonyms.isNotEmpty) ...[
            const SizedBox(height: 14),
            _WordChipsSection(title: 'أضداد', words: word.antonyms),
          ],
          const SizedBox(height: 26),
          Text(
            'تقدمك في الكلمة دي',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          _ProgressSelector(word: word),
        ],
      ),
    );
  }
}

class _MeaningRow extends StatelessWidget {
  const _MeaningRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.subtitleColor(context),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _WordChipsSection extends StatelessWidget {
  const _WordChipsSection({required this.title, required this.words});

  final String title;
  final List<String> words;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final w in words) Chip(label: Text(w))],
        ),
      ],
    );
  }
}

class _ProgressSelector extends ConsumerWidget {
  const _ProgressSelector({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        for (final status in VocabularyProgressStatus.values)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: OutlinedButton(
                onPressed: () => ref
                    .read(vocabularyActionsProvider.notifier)
                    .updateProgress(word.id, status),
                style: OutlinedButton.styleFrom(
                  backgroundColor: word.progressStatus == status
                      ? status.color()
                      : null,
                  side: BorderSide(color: status.color()),
                ),
                child: Text(
                  status.labelAr,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: word.progressStatus == status
                        ? Colors.white
                        : status.color(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
