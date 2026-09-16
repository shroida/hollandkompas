import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_list_providers.dart';
import '../../providers/vocabulary_user_providers.dart';
import '../widgets/pronunciation_button.dart';

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
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'حصل خطأ أثناء تحميل الكلمة:\n$error',
                textAlign: TextAlign.center,
              ),
            ),
          ),
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
        title: Text(_categoryLabel(word.category)),
        actions: [
          IconButton(
            tooltip: word.isFavorite ? 'إزالة من المحفوظات' : 'حفظ الكلمة',
            onPressed: () {
              ref
                  .read(vocabularyActionsProvider.notifier)
                  .toggleFavorite(word.id, !word.isFavorite);
            },
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
          _WordHeader(word: word),

          const SizedBox(height: 20),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (word.level.isNotEmpty)
                Chip(
                  avatar: const Icon(Icons.school_outlined, size: 16),
                  label: Text(word.level.toUpperCase()),
                ),
              if (word.category.isNotEmpty)
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 16),
                  label: Text(_categoryLabel(word.category)),
                ),
            ],
          ),

          const Divider(height: 32),

          _MeaningRow(
            label: 'المعنى بالعربي',
            value: word.arabicMeaning,
            textDirection: TextDirection.rtl,
          ),

          if (word.englishMeaning != null &&
              word.englishMeaning!.trim().isNotEmpty)
            _MeaningRow(
              label: 'المعنى بالإنجليزية',
              value: word.englishMeaning!,
              textDirection: TextDirection.ltr,
            ),

          const SizedBox(height: 26),

          Text('تقدمك في الكلمة', style: Theme.of(context).textTheme.bodyLarge),

          const SizedBox(height: 10),

          _ProgressSelector(word: word),
        ],
      ),
    );
  }
}

class _WordHeader extends StatelessWidget {
  const _WordHeader({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            word.dutchWord,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        const SizedBox(width: 12),
        PronunciationButton(text: word.dutchWord, size: 30),
      ],
    );
  }
}

class _MeaningRow extends StatelessWidget {
  const _MeaningRow({
    required this.label,
    required this.value,
    required this.textDirection,
  });

  final String label;
  final String value;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
          const SizedBox(height: 4),
          Text(
            value,
            textDirection: textDirection,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
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
                onPressed: () {
                  ref
                      .read(vocabularyActionsProvider.notifier)
                      .updateProgress(word.id, status);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: word.progressStatus == status
                      ? _progressColor(status)
                      : null,
                  side: BorderSide(color: _progressColor(status)),
                ),
                child: Text(
                  _progressLabel(status),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: word.progressStatus == status
                        ? Colors.white
                        : _progressColor(status),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

Color _progressColor(VocabularyProgressStatus status) {
  switch (status) {
    case VocabularyProgressStatus.newWord:
      return Colors.grey;

    case VocabularyProgressStatus.learning:
      return Colors.orange;

    case VocabularyProgressStatus.mastered:
      return Colors.green;
  }
}

String _progressLabel(VocabularyProgressStatus status) {
  switch (status) {
    case VocabularyProgressStatus.newWord:
      return 'جديدة';

    case VocabularyProgressStatus.learning:
      return 'بتعلمها';

    case VocabularyProgressStatus.mastered:
      return 'متقنها';
  }
}

String _categoryLabel(String category) {
  switch (category.toLowerCase()) {
    case 'verb':
      return 'فعل';

    case 'expression':
      return 'تعبير';

    case 'phone':
      return 'هاتف';

    case 'grammar':
      return 'قواعد';

    case 'location':
      return 'مكان';

    case 'food':
      return 'طعام';

    case 'money':
      return 'مال';

    case 'drink':
      return 'مشروبات';

    case 'question':
      return 'سؤال';

    case 'pronoun':
      return 'ضمير';

    case 'family':
      return 'العائلة';

    case 'weather':
      return 'الطقس';

    case 'time':
      return 'الوقت';

    default:
      return category;
  }
}
