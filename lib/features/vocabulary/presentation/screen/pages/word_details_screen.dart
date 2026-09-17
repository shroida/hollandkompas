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

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل الكلمة',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: _FavoriteButton(word: word),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _WordHeroCard(word: word),

            const SizedBox(height: 20),

            _SectionTitle(icon: Icons.translate_rounded, title: 'المعنى'),

            const SizedBox(height: 10),

            _MeaningCard(
              icon: Icons.language_rounded,
              label: 'المعنى بالعربي',
              value: word.arabicMeaning,
              textDirection: TextDirection.rtl,
            ),

            if (word.englishMeaning != null &&
                word.englishMeaning!.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              _MeaningCard(
                icon: Icons.public_rounded,
                label: 'English meaning',
                value: word.englishMeaning!,
                textDirection: TextDirection.ltr,
              ),
            ],

            const SizedBox(height: 24),

            _SectionTitle(icon: Icons.school_rounded, title: 'مستوى الكلمة'),

            const SizedBox(height: 10),

            _WordMetaCard(word: word),

            const SizedBox(height: 24),

            _SectionTitle(
              icon: Icons.auto_graph_rounded,
              title: 'تقدمك في الكلمة',
            ),

            const SizedBox(height: 10),

            _ProgressSelector(word: word),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends ConsumerWidget {
  const _FavoriteButton({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = word.isFavorite;

    return Material(
      color: isFavorite ? AppColors.accent : AppColors.cardColor(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ref
              .read(vocabularyActionsProvider.notifier)
              .toggleFavorite(word.id, !word.isFavorite);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isFavorite
                  ? AppColors.primary.withValues(alpha: 0.25)
                  : AppColors.borderColor(context),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isFavorite
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
              key: ValueKey(isFavorite),
              size: 22,
              color: isFavorite
                  ? AppColors.primary
                  : AppColors.subtitleColor(context),
            ),
          ),
        ),
      ),
    );
  }
}

class _WordHeroCard extends StatelessWidget {
  const _WordHeroCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.translate_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            word.dutchWord,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16),

          PronunciationButton(text: word.dutchWord, size: 42),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.muted,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppColors.secondary),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MeaningCard extends StatelessWidget {
  const _MeaningCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.textDirection,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.muted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.secondary),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  textDirection: textDirection,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.5,
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

class _WordMetaCard extends StatelessWidget {
  const _WordMetaCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          if (word.level.isNotEmpty)
            Expanded(
              child: _MetaItem(
                icon: Icons.school_outlined,
                label: 'المستوى',
                value: word.level.toUpperCase(),
              ),
            ),
          if (word.level.isNotEmpty && word.category.isNotEmpty)
            Container(
              width: 1,
              height: 42,
              color: AppColors.borderColor(context),
            ),
          if (word.category.isNotEmpty)
            Expanded(
              child: _MetaItem(
                icon: Icons.category_outlined,
                label: 'التصنيف',
                value: _categoryLabel(word.category),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressSelector extends ConsumerStatefulWidget {
  const _ProgressSelector({required this.word});

  final VocabularyWord word;

  @override
  ConsumerState<_ProgressSelector> createState() => _ProgressSelectorState();
}

class _ProgressSelectorState extends ConsumerState<_ProgressSelector> {
  late VocabularyProgressStatus _selectedStatus;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.word.progressStatus;
  }

  @override
  void didUpdateWidget(covariant _ProgressSelector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.word.progressStatus != widget.word.progressStatus &&
        !_isUpdating) {
      _selectedStatus = widget.word.progressStatus;
    }
  }

  Future<void> _updateProgress(VocabularyProgressStatus status) async {
    if (_isUpdating || _selectedStatus == status) return;

    final oldStatus = _selectedStatus;

    setState(() {
      _selectedStatus = status;
      _isUpdating = true;
    });

    try {
      await ref
          .read(vocabularyActionsProvider.notifier)
          .updateProgress(widget.word.id, status);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _selectedStatus = oldStatus;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: const Text('حصل خطأ أثناء حفظ التقدم'),
        ),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Row(
        children: [
          for (final status in VocabularyProgressStatus.values)
            Expanded(
              child: _ProgressOption(
                status: status,
                selected: _selectedStatus == status,
                enabled: !_isUpdating,
                onTap: () => _updateProgress(status),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressOption extends StatelessWidget {
  const _ProgressOption({
    required this.status,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final VocabularyProgressStatus status;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _progressColor(status);

    return Padding(
      padding: const EdgeInsets.all(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(14),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textColor(context),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 13,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 160),
                  child: _isLoadingFor(status)
                      ? const SizedBox(
                          key: ValueKey('loading'),
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          _progressLabel(status),
                          key: ValueKey(status),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isLoadingFor(VocabularyProgressStatus status) {
    return false;
  }
}

Color _progressColor(VocabularyProgressStatus status) {
  switch (status) {
    case VocabularyProgressStatus.newWord:
      return Colors.grey;

    case VocabularyProgressStatus.learning:
      return AppColors.warning;

    case VocabularyProgressStatus.mastered:
      return AppColors.success;
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
