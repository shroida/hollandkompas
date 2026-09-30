import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';

import '../../../domain/entities/vocabulary_word.dart';
import '../../providers/vocabulary_user_providers.dart';
import '../widgets/pronunciation_button.dart';

class FavoriteWordsScreen extends ConsumerStatefulWidget {
  const FavoriteWordsScreen({super.key});

  @override
  ConsumerState<FavoriteWordsScreen> createState() =>
      _FavoriteWordsScreenState();
}

class _FavoriteWordsScreenState extends ConsumerState<FavoriteWordsScreen> {
  final Random _random = Random();
  final TextEditingController _answerController = TextEditingController();

  List<VocabularyWord> _words = [];

  int _currentIndex = 0;
  int _score = 0;

  RecapQuestionType _questionType = RecapQuestionType.multipleChoice;

  List<String> _answers = [];

  String? _selectedAnswer;
  String? _typedAnswer;

  bool _showResult = false;
  bool _isCorrect = false;
  bool _isInitializing = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  VocabularyWord? get _currentWord {
    if (_words.isEmpty || _currentIndex >= _words.length) {
      return null;
    }

    return _words[_currentIndex];
  }

  void _initializeReview(List<VocabularyWord> words) {
    if (_isInitializing || words.isEmpty) {
      return;
    }

    _isInitializing = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final shuffledWords = [...words]..shuffle(_random);

      setState(() {
        _words = shuffledWords;
        _currentIndex = 0;
        _score = 0;

        _selectedAnswer = null;
        _typedAnswer = null;

        _showResult = false;
        _isCorrect = false;

        _answerController.clear();

        _generateQuestion();
        _isInitializing = false;
      });
    });
  }

  void _generateQuestion() {
    final types = RecapQuestionType.values;

    _questionType = types[_random.nextInt(types.length)];

    _selectedAnswer = null;
    _typedAnswer = null;
    _showResult = false;
    _isCorrect = false;

    _answerController.clear();

    final currentWord = _currentWord;

    if (currentWord == null) {
      _answers = [];
      return;
    }

    switch (_questionType) {
      case RecapQuestionType.multipleChoice:
      case RecapQuestionType.listening:
        _answers = _buildArabicAnswers(currentWord);
        break;

      case RecapQuestionType.reverseChoice:
        _answers = _buildDutchAnswers(currentWord);
        break;

      case RecapQuestionType.typing:
        _answers = [];
        break;
    }
  }

  List<String> _buildArabicAnswers(VocabularyWord currentWord) {
    final answers = <String>[currentWord.arabicMeaning];

    final candidates = [..._words]
      ..removeWhere((word) => word.id == currentWord.id)
      ..shuffle(_random);

    for (final word in candidates) {
      if (answers.length >= 4) {
        break;
      }

      if (word.arabicMeaning.trim().isEmpty) {
        continue;
      }

      if (!answers.contains(word.arabicMeaning)) {
        answers.add(word.arabicMeaning);
      }
    }

    answers.shuffle(_random);

    return answers;
  }

  List<String> _buildDutchAnswers(VocabularyWord currentWord) {
    final answers = <String>[currentWord.dutchWord];

    final candidates = [..._words]
      ..removeWhere((word) => word.id == currentWord.id)
      ..shuffle(_random);

    for (final word in candidates) {
      if (answers.length >= 4) {
        break;
      }

      if (word.dutchWord.trim().isEmpty) {
        continue;
      }

      if (!answers.contains(word.dutchWord)) {
        answers.add(word.dutchWord);
      }
    }

    answers.shuffle(_random);

    return answers;
  }

  void _checkArabicAnswer(String answer) {
    if (_showResult) {
      return;
    }

    final currentWord = _currentWord;

    if (currentWord == null) {
      return;
    }

    final correct = answer == currentWord.arabicMeaning;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _isCorrect = correct;

      if (correct) {
        _score++;
      }
    });
  }

  void _checkDutchAnswer(String answer) {
    if (_showResult) {
      return;
    }

    final currentWord = _currentWord;

    if (currentWord == null) {
      return;
    }

    final correct = answer == currentWord.dutchWord;

    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      _isCorrect = correct;

      if (correct) {
        _score++;
      }
    });
  }

  void _checkTypedAnswer() {
    if (_showResult) {
      return;
    }

    final currentWord = _currentWord;

    if (currentWord == null) {
      return;
    }

    final answer = _answerController.text.trim();

    if (answer.isEmpty) {
      return;
    }

    final correct = _normalize(answer) == _normalize(currentWord.dutchWord);

    setState(() {
      _typedAnswer = answer;
      _showResult = true;
      _isCorrect = correct;

      if (correct) {
        _score++;
      }
    });
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  void _nextQuestion() {
    if (_currentIndex >= _words.length - 1) {
      setState(() {
        _currentIndex = _words.length;
      });
      return;
    }

    setState(() {
      _currentIndex++;
      _generateQuestion();
    });
  }

  void _restart() {
    if (_words.isEmpty) {
      return;
    }

    final shuffledWords = [..._words]..shuffle(_random);

    setState(() {
      _words = shuffledWords;
      _currentIndex = 0;
      _score = 0;

      _selectedAnswer = null;
      _typedAnswer = null;

      _showResult = false;
      _isCorrect = false;

      _answerController.clear();

      _generateQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoriteVocabularyWordsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        title: const Text(
          'مراجعة الكلمات',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: favoritesAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },
        error: (error, _) {
          return _ErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(favoriteVocabularyWordsProvider);
            },
          );
        },
        data: (words) {
          if (words.isEmpty) {
            return const _EmptyReviewState();
          }

          if (_words.isEmpty) {
            _initializeReview(words);

            return const _PreparingReview();
          }

          if (_currentIndex >= _words.length) {
            return _ReviewComplete(
              score: _score,
              total: _words.length,
              onRestart: _restart,
            );
          }

          final currentWord = _currentWord;

          if (currentWord == null) {
            return const _PreparingReview();
          }

          return _ReviewBody(
            word: currentWord,
            currentIndex: _currentIndex,
            total: _words.length,
            score: _score,
            questionType: _questionType,
            selectedAnswer: _selectedAnswer,
            typedAnswer: _typedAnswer,
            showResult: _showResult,
            isCorrect: _isCorrect,
            answerController: _answerController,
            answers: _answers,
            onArabicAnswer: _checkArabicAnswer,
            onDutchAnswer: _checkDutchAnswer,
            onTypedAnswer: _checkTypedAnswer,
            onNext: _nextQuestion,
          );
        },
      ),
    );
  }
}

enum RecapQuestionType { multipleChoice, reverseChoice, listening, typing }

class _ReviewBody extends StatelessWidget {
  const _ReviewBody({
    required this.word,
    required this.currentIndex,
    required this.total,
    required this.score,
    required this.questionType,
    required this.selectedAnswer,
    required this.typedAnswer,
    required this.showResult,
    required this.isCorrect,
    required this.answerController,
    required this.answers,
    required this.onArabicAnswer,
    required this.onDutchAnswer,
    required this.onTypedAnswer,
    required this.onNext,
  });

  final VocabularyWord word;

  final int currentIndex;
  final int total;
  final int score;

  final RecapQuestionType questionType;

  final String? selectedAnswer;
  final String? typedAnswer;

  final bool showResult;
  final bool isCorrect;

  final TextEditingController answerController;

  final List<String> answers;

  final ValueChanged<String> onArabicAnswer;
  final ValueChanged<String> onDutchAnswer;
  final VoidCallback onTypedAnswer;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / total;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReviewHeader(
                  current: currentIndex + 1,
                  total: total,
                  score: score,
                  progress: progress,
                ),

                const SizedBox(height: 26),

                _QuestionTypeBadge(type: questionType),

                const SizedBox(height: 14),

                _QuestionCard(word: word, questionType: questionType),

                const SizedBox(height: 24),

                switch (questionType) {
                  RecapQuestionType.multipleChoice => _MultipleChoiceSection(
                    answers: answers,
                    selectedAnswer: selectedAnswer,
                    correctAnswer: word.arabicMeaning,
                    showResult: showResult,
                    onAnswer: onArabicAnswer,
                  ),

                  RecapQuestionType.reverseChoice => _MultipleChoiceSection(
                    answers: answers,
                    selectedAnswer: selectedAnswer,
                    correctAnswer: word.dutchWord,
                    showResult: showResult,
                    onAnswer: onDutchAnswer,
                    isDutch: true,
                  ),

                  RecapQuestionType.listening => _ListeningSection(
                    word: word,
                    answers: answers,
                    selectedAnswer: selectedAnswer,
                    correctAnswer: word.arabicMeaning,
                    showResult: showResult,
                    onAnswer: onArabicAnswer,
                  ),

                  RecapQuestionType.typing => _TypingSection(
                    word: word,
                    controller: answerController,
                    typedAnswer: typedAnswer,
                    showResult: showResult,
                    onSubmit: onTypedAnswer,
                  ),
                },

                if (showResult) ...[
                  const SizedBox(height: 20),

                  _ResultBanner(
                    isCorrect: isCorrect,
                    correctAnswer: _correctAnswerFor(word, questionType),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: onNext,
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(
                        currentIndex == total - 1
                            ? 'عرض النتيجة'
                            : 'الكلمة التالية',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _correctAnswerFor(VocabularyWord word, RecapQuestionType type) {
    switch (type) {
      case RecapQuestionType.reverseChoice:
      case RecapQuestionType.typing:
        return word.dutchWord;

      case RecapQuestionType.multipleChoice:
      case RecapQuestionType.listening:
        return word.arabicMeaning;
    }
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({
    required this.current,
    required this.total,
    required this.score,
    required this.progress,
  });

  final int current;
  final int total;
  final int score;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'مراجعة الكلمات',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$score صحيح',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.muted,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Text(
              'السؤال $current من $total',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).round()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuestionTypeBadge extends StatelessWidget {
  const _QuestionTypeBadge({required this.type});

  final RecapQuestionType type;

  @override
  Widget build(BuildContext context) {
    final data = switch (type) {
      RecapQuestionType.multipleChoice => (
        Icons.quiz_outlined,
        'اختر المعنى الصحيح',
      ),
      RecapQuestionType.reverseChoice => (
        Icons.translate_rounded,
        'اختر الكلمة الهولندية',
      ),
      RecapQuestionType.listening => (Icons.headphones_rounded, 'استمع واختر'),
      RecapQuestionType.typing => (
        Icons.keyboard_alt_outlined,
        'اكتب الكلمة التي تسمعها',
      ),
    };

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(data.$1, size: 17, color: AppColors.primary),
            const SizedBox(width: 7),
            Text(
              data.$2,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.word, required this.questionType});

  final VocabularyWord word;
  final RecapQuestionType questionType;

  @override
  Widget build(BuildContext context) {
    switch (questionType) {
      case RecapQuestionType.multipleChoice:
        return _MultipleChoiceQuestionCard(word: word);

      case RecapQuestionType.reverseChoice:
        return _ReverseQuestionCard(word: word);

      case RecapQuestionType.listening:
        return _ListeningQuestionCard(word: word);

      case RecapQuestionType.typing:
        return _TypingQuestionCard(word: word);
    }
  }
}

class _MultipleChoiceQuestionCard extends StatelessWidget {
  const _MultipleChoiceQuestionCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return _QuestionCardContainer(
      child: Column(
        children: [
          const _QuestionIcon(icon: Icons.menu_book_rounded),
          const SizedBox(height: 16),
          Text(
            'ما معنى الكلمة التالية؟',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            word.dutchWord,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          PronunciationButton(text: word.dutchWord, size: 26),
        ],
      ),
    );
  }
}

class _ReverseQuestionCard extends StatelessWidget {
  const _ReverseQuestionCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return _QuestionCardContainer(
      child: Column(
        children: [
          const _QuestionIcon(icon: Icons.translate_rounded),
          const SizedBox(height: 16),
          Text(
            'ما هي الكلمة الهولندية؟',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            word.arabicMeaning,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _ListeningQuestionCard extends StatelessWidget {
  const _ListeningQuestionCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return _QuestionCardContainer(
      child: Column(
        children: [
          const _QuestionIcon(icon: Icons.headphones_rounded),
          const SizedBox(height: 16),
          Text(
            'استمع جيدًا ثم اختر المعنى',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'لن تظهر الكلمة حتى تختبر فهمك من الاستماع.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
          const SizedBox(height: 22),
          PronunciationButton(text: word.dutchWord, size: 34),
          const SizedBox(height: 8),
          Text(
            'اضغط للاستماع',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingQuestionCard extends StatelessWidget {
  const _TypingQuestionCard({required this.word});

  final VocabularyWord word;

  @override
  Widget build(BuildContext context) {
    return _QuestionCardContainer(
      child: Column(
        children: [
          const _QuestionIcon(icon: Icons.keyboard_alt_rounded),
          const SizedBox(height: 16),
          Text(
            'اكتب الكلمة الهولندية',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          Text(
            word.arabicMeaning,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          PronunciationButton(text: word.dutchWord, size: 30),
          const SizedBox(height: 8),
          Text(
            'استمع للكلمة ثم اكتبها',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCardContainer extends StatelessWidget {
  const _QuestionCardContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: child,
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(icon, size: 27, color: AppColors.primary),
    );
  }
}

class _MultipleChoiceSection extends StatelessWidget {
  const _MultipleChoiceSection({
    required this.answers,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.showResult,
    required this.onAnswer,
    this.isDutch = false,
  });

  final List<String> answers;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool showResult;
  final ValueChanged<String> onAnswer;
  final bool isDutch;

  @override
  Widget build(BuildContext context) {
    if (answers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: answers.asMap().entries.map((entry) {
        final index = entry.key;
        final answer = entry.value;

        final selected = selectedAnswer == answer;
        final correct = answer == correctAnswer;

        final isWrong = showResult && selected && !correct;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _AnswerButton(
            number: index + 1,
            answer: answer,
            isDutch: isDutch,
            selected: selected,
            correct: correct,
            showResult: showResult,
            isWrong: isWrong,
            onTap: () => onAnswer(answer),
          ),
        );
      }).toList(),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  const _AnswerButton({
    required this.number,
    required this.answer,
    required this.isDutch,
    required this.selected,
    required this.correct,
    required this.showResult,
    required this.isWrong,
    required this.onTap,
  });

  final int number;
  final String answer;
  final bool isDutch;
  final bool selected;
  final bool correct;
  final bool showResult;
  final bool isWrong;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color borderColor = AppColors.borderColor(context);
    Color textColor = AppColors.textColor(context);

    if (showResult && correct) {
      backgroundColor = Colors.green.withValues(alpha: 0.10);
      borderColor = Colors.green;
      textColor = Colors.green;
    } else if (isWrong) {
      backgroundColor = AppColors.destructive.withValues(alpha: 0.10);
      borderColor = AppColors.destructive;
      textColor = AppColors.destructive;
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: showResult ? null : onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderColor,
            width: selected && !showResult ? 1.5 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.muted,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$number',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                answer,
                textDirection: isDutch ? TextDirection.ltr : TextDirection.rtl,
                textAlign: isDutch ? TextAlign.left : TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (showResult && correct)
              const Icon(Icons.check_circle_rounded, color: Colors.green),
            if (isWrong)
              const Icon(Icons.cancel_rounded, color: AppColors.destructive),
          ],
        ),
      ),
    );
  }
}

class _ListeningSection extends StatelessWidget {
  const _ListeningSection({
    required this.word,
    required this.answers,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.showResult,
    required this.onAnswer,
  });

  final VocabularyWord word;
  final List<String> answers;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool showResult;
  final ValueChanged<String> onAnswer;

  @override
  Widget build(BuildContext context) {
    return _MultipleChoiceSection(
      answers: answers,
      selectedAnswer: selectedAnswer,
      correctAnswer: correctAnswer,
      showResult: showResult,
      onAnswer: onAnswer,
    );
  }
}

class _TypingSection extends StatelessWidget {
  const _TypingSection({
    required this.word,
    required this.controller,
    required this.typedAnswer,
    required this.showResult,
    required this.onSubmit,
  });

  final VocabularyWord word;
  final TextEditingController controller;
  final String? typedAnswer;
  final bool showResult;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          enabled: !showResult,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          autofocus: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'اكتب الكلمة الهولندية',
            hintTextDirection: TextDirection.rtl,
            prefixIcon: const Icon(Icons.keyboard_rounded),
            filled: true,
            fillColor: AppColors.cardColor(context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
          onSubmitted: (_) => onSubmit(),
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: showResult ? null : onSubmit,
            icon: const Icon(Icons.check_rounded),
            label: const Text('تحقق'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultBanner extends StatelessWidget {
  const _ResultBanner({required this.isCorrect, required this.correctAnswer});

  final bool isCorrect;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withValues(alpha: 0.10)
            : AppColors.destructive.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? Colors.green : AppColors.destructive,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
            color: isCorrect ? Colors.green : AppColors.destructive,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect ? 'إجابة صحيحة! 🎉' : 'الإجابة الصحيحة: $correctAnswer',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: isCorrect ? Colors.green : AppColors.destructive,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewComplete extends StatelessWidget {
  const _ReviewComplete({
    required this.score,
    required this.total,
    required this.onRestart,
  });

  final int score;
  final int total;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0 : ((score / total) * 100).round();

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppColors.cardColor(context),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.borderColor(context)),
            ),
            child: Column(
              children: [
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    size: 42,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'خلصت المراجعة! 🎉',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'نتيجتك',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$score من $total إجابات صحيحة',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 26),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: onRestart,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('مراجعة مرة أخرى'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  const _EmptyReviewState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: AppColors.muted,
                borderRadius: BorderRadius.circular(26),
              ),
              child: const Icon(
                Icons.style_outlined,
                size: 42,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'مفيش كلمات للمراجعة',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'احفظ بعض الكلمات أولًا، وبعدها هتقدر تراجعها هنا بطرق مختلفة.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreparingReview extends StatelessWidget {
  const _PreparingReview();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: AppColors.destructive,
            ),
            const SizedBox(height: 14),
            Text(
              'حصل خطأ في تحميل الكلمات',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              '$error',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
