import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/vocabulary/domain/entities/vocabulary_word.dart';
import 'package:hollandkompas/features/vocabulary/presentation/providers/vocabulary_user_providers.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/widgets/pronunciation_button.dart';

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

      final answer = word.arabicMeaning.trim();

      if (answer.isEmpty) {
        continue;
      }

      if (!answers.contains(answer)) {
        answers.add(answer);
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

      final answer = word.dutchWord.trim();

      if (answer.isEmpty) {
        continue;
      }

      if (!answers.contains(answer)) {
        answers.add(answer);
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool isMobile = width < 600;

        final bool isTablet = width >= 600 && width < 1024;

        final bool isDesktop = width >= 1024;

        final horizontalPadding = isMobile
            ? 16.0
            : isTablet
            ? 24.0
            : 32.0;

        final maxWidth = isDesktop
            ? 1100.0
            : isTablet
            ? 900.0
            : double.infinity;

        final questionCard = _QuestionCard(
          word: word,
          questionType: questionType,
          compact: isMobile,
        );

        final answerSection = _AnswerSection(
          word: word,
          questionType: questionType,
          answers: answers,
          selectedAnswer: selectedAnswer,
          showResult: showResult,
          isCorrect: isCorrect,
          answerController: answerController,
          typedAnswer: typedAnswer,
          isMobile: isMobile,
          onArabicAnswer: onArabicAnswer,
          onDutchAnswer: onDutchAnswer,
          onTypedAnswer: onTypedAnswer,
        );

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              8,
              horizontalPadding,
              isDesktop ? 50 : 32,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ReviewHeader(
                      current: currentIndex + 1,
                      total: total,
                      score: score,
                      progress: (currentIndex + 1) / total,
                      isMobile: isMobile,
                    ),
                    SizedBox(height: isMobile ? 20 : 28),

                    _QuestionTypeBadge(type: questionType),

                    SizedBox(height: isMobile ? 12 : 16),

                    if (isDesktop)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: questionCard),
                          const SizedBox(width: 24),
                          Expanded(flex: 6, child: answerSection),
                        ],
                      )
                    else ...[
                      questionCard,
                      SizedBox(height: isMobile ? 18 : 24),
                      answerSection,
                    ],

                    if (showResult) ...[
                      SizedBox(height: isMobile ? 18 : 22),
                      _ResultBanner(
                        isCorrect: isCorrect,
                        correctAnswer: _correctAnswerFor(word, questionType),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: isMobile ? 52 : 56,
                        child: FilledButton.icon(
                          onPressed: onNext,
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            size: isMobile ? 19 : 21,
                          ),
                          label: Text(
                            currentIndex == total - 1
                                ? 'عرض النتيجة'
                                : 'الكلمة التالية',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isMobile ? 14 : 16,
                              ),
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
      },
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

class _AnswerSection extends StatelessWidget {
  const _AnswerSection({
    required this.word,
    required this.questionType,
    required this.answers,
    required this.selectedAnswer,
    required this.showResult,
    required this.isCorrect,
    required this.answerController,
    required this.typedAnswer,
    required this.isMobile,
    required this.onArabicAnswer,
    required this.onDutchAnswer,
    required this.onTypedAnswer,
  });

  final VocabularyWord word;
  final RecapQuestionType questionType;

  final List<String> answers;
  final String? selectedAnswer;

  final bool showResult;
  final bool isCorrect;

  final TextEditingController answerController;
  final String? typedAnswer;

  final bool isMobile;

  final ValueChanged<String> onArabicAnswer;
  final ValueChanged<String> onDutchAnswer;
  final VoidCallback onTypedAnswer;

  @override
  Widget build(BuildContext context) {
    switch (questionType) {
      case RecapQuestionType.multipleChoice:
        return _MultipleChoiceSection(
          answers: answers,
          selectedAnswer: selectedAnswer,
          correctAnswer: word.arabicMeaning,
          showResult: showResult,
          onAnswer: onArabicAnswer,
          isDutch: false,
          isMobile: isMobile,
        );

      case RecapQuestionType.reverseChoice:
        return _MultipleChoiceSection(
          answers: answers,
          selectedAnswer: selectedAnswer,
          correctAnswer: word.dutchWord,
          showResult: showResult,
          onAnswer: onDutchAnswer,
          isDutch: true,
          isMobile: isMobile,
        );

      case RecapQuestionType.listening:
        return _ListeningAnswerSection(
          word: word,
          answers: answers,
          selectedAnswer: selectedAnswer,
          showResult: showResult,
          onAnswer: onArabicAnswer,
          isMobile: isMobile,
        );

      case RecapQuestionType.typing:
        return _TypingSection(
          word: word,
          controller: answerController,
          typedAnswer: typedAnswer,
          showResult: showResult,
          onSubmit: onTypedAnswer,
          isMobile: isMobile,
        );
    }
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({
    required this.current,
    required this.total,
    required this.score,
    required this.progress,
    required this.isMobile,
  });

  final int current;
  final int total;
  final int score;
  final double progress;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'مراجعة الكلمات',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: isMobile ? 17 : 19,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 12,
                vertical: isMobile ? 6 : 7,
              ),
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
            minHeight: isMobile ? 7 : 8,
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
  const _QuestionCard({
    required this.word,
    required this.questionType,
    required this.compact,
  });

  final VocabularyWord word;
  final RecapQuestionType questionType;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? 20.0 : 28.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.cardColor(context),
        borderRadius: BorderRadius.circular(compact ? 20 : 26),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: switch (questionType) {
        RecapQuestionType.multipleChoice => _MeaningQuestion(
          word: word,
          compact: compact,
        ),
        RecapQuestionType.reverseChoice => _ReverseQuestion(
          word: word,
          compact: compact,
        ),
        RecapQuestionType.listening => _ListeningQuestion(
          word: word,
          compact: compact,
        ),
        RecapQuestionType.typing => _TypingQuestion(
          word: word,
          compact: compact,
        ),
      },
    );
  }
}

class _MeaningQuestion extends StatelessWidget {
  const _MeaningQuestion({required this.word, required this.compact});

  final VocabularyWord word;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionIcon(icon: Icons.menu_book_rounded, size: compact ? 52 : 60),
        SizedBox(height: compact ? 14 : 18),
        Text(
          'ما معنى الكلمة التالية؟',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
        SizedBox(height: compact ? 12 : 16),
        Text(
          word.dutchWord,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 28 : 34,
          ),
        ),
        SizedBox(height: compact ? 14 : 18),
        PronunciationButton(text: word.dutchWord, size: compact ? 24 : 30),
      ],
    );
  }
}

class _ReverseQuestion extends StatelessWidget {
  const _ReverseQuestion({required this.word, required this.compact});

  final VocabularyWord word;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionIcon(icon: Icons.translate_rounded, size: compact ? 52 : 60),
        SizedBox(height: compact ? 14 : 18),
        Text(
          'ما هي الكلمة الهولندية؟',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
        SizedBox(height: compact ? 12 : 16),
        Text(
          word.arabicMeaning,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 24 : 30,
          ),
        ),
      ],
    );
  }
}

class _ListeningQuestion extends StatelessWidget {
  const _ListeningQuestion({required this.word, required this.compact});

  final VocabularyWord word;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionIcon(icon: Icons.headphones_rounded, size: compact ? 52 : 60),
        SizedBox(height: compact ? 14 : 18),
        Text(
          'استمع جيدًا ثم اختر المعنى',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: compact ? 17 : 19,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'الكلمة مخفية حتى تختبر فهمك من الاستماع.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
        SizedBox(height: compact ? 20 : 26),
        PronunciationButton(text: word.dutchWord, size: compact ? 34 : 42),
        const SizedBox(height: 8),
        Text(
          'اضغط للاستماع',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}

class _TypingQuestion extends StatelessWidget {
  const _TypingQuestion({required this.word, required this.compact});

  final VocabularyWord word;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _QuestionIcon(
          icon: Icons.keyboard_alt_rounded,
          size: compact ? 52 : 60,
        ),
        SizedBox(height: compact ? 14 : 18),
        Text(
          'اكتب الكلمة الهولندية',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: compact ? 12 : 16),
        Text(
          word.arabicMeaning,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: compact ? 24 : 30,
          ),
        ),
        SizedBox(height: compact ? 16 : 22),
        PronunciationButton(text: word.dutchWord, size: compact ? 30 : 36),
        const SizedBox(height: 8),
        Text(
          'استمع للكلمة ثم اكتبها',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}

class _QuestionIcon extends StatelessWidget {
  const _QuestionIcon({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(size * .30),
      ),
      child: Icon(icon, size: size * .48, color: AppColors.primary),
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
    required this.isDutch,
    required this.isMobile,
  });

  final List<String> answers;
  final String? selectedAnswer;
  final String correctAnswer;
  final bool showResult;
  final ValueChanged<String> onAnswer;
  final bool isDutch;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (answers.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid =
            !isMobile && constraints.maxWidth >= 560 && answers.length >= 3;

        if (!useGrid) {
          return Column(
            children: answers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnswerButton(
                  number: entry.key + 1,
                  answer: entry.value,
                  isDutch: isDutch,
                  selected: selectedAnswer == entry.value,
                  correct: entry.value == correctAnswer,
                  showResult: showResult,
                  onTap: () => onAnswer(entry.value),
                ),
              );
            }).toList(),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: answers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.55,
          ),
          itemBuilder: (context, index) {
            final answer = answers[index];

            return _AnswerButton(
              number: index + 1,
              answer: answer,
              isDutch: isDutch,
              selected: selectedAnswer == answer,
              correct: answer == correctAnswer,
              showResult: showResult,
              onTap: () => onAnswer(answer),
            );
          },
        );
      },
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
    required this.onTap,
  });

  final int number;
  final String answer;
  final bool isDutch;
  final bool selected;
  final bool correct;
  final bool showResult;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isWrong = showResult && selected && !correct;

    Color? backgroundColor;
    Color borderColor = AppColors.borderColor(context);
    Color textColor = AppColors.textColor(context);

    if (showResult && correct) {
      backgroundColor = Colors.green.withValues(alpha: .10);
      borderColor = Colors.green;
      textColor = Colors.green;
    } else if (isWrong) {
      backgroundColor = AppColors.destructive.withValues(alpha: .10);
      borderColor = AppColors.destructive;
      textColor = AppColors.destructive;
    }

    return OutlinedButton(
      onPressed: showResult ? null : onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor,
          width: selected && !showResult ? 1.5 : 1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              answer,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textDirection: isDutch ? TextDirection.ltr : TextDirection.rtl,
              textAlign: isDutch ? TextAlign.left : TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (showResult && correct)
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 21,
            ),
          if (isWrong)
            const Icon(
              Icons.cancel_rounded,
              color: AppColors.destructive,
              size: 21,
            ),
        ],
      ),
    );
  }
}

class _ListeningAnswerSection extends StatelessWidget {
  const _ListeningAnswerSection({
    required this.word,
    required this.answers,
    required this.selectedAnswer,
    required this.showResult,
    required this.onAnswer,
    required this.isMobile,
  });

  final VocabularyWord word;
  final List<String> answers;
  final String? selectedAnswer;
  final bool showResult;
  final ValueChanged<String> onAnswer;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return _MultipleChoiceSection(
      answers: answers,
      selectedAnswer: selectedAnswer,
      correctAnswer: word.arabicMeaning,
      showResult: showResult,
      onAnswer: onAnswer,
      isDutch: false,
      isMobile: isMobile,
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
    required this.isMobile,
  });

  final VocabularyWord word;
  final TextEditingController controller;
  final String? typedAnswer;
  final bool showResult;
  final VoidCallback onSubmit;
  final bool isMobile;

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
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: 'اكتب الكلمة الهولندية',
            hintTextDirection: TextDirection.rtl,
            prefixIcon: const Icon(Icons.keyboard_rounded),
            filled: true,
            fillColor: AppColors.cardColor(context),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 14 : 18,
              vertical: isMobile ? 15 : 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: BorderSide(color: AppColors.borderColor(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
          onSubmitted: (_) => onSubmit(),
        ),
        SizedBox(height: isMobile ? 12 : 14),
        SizedBox(
          width: double.infinity,
          height: isMobile ? 50 : 54,
          child: FilledButton.icon(
            onPressed: showResult ? null : onSubmit,
            icon: const Icon(Icons.check_rounded),
            label: const Text('تحقق'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 14 : 16),
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
            ? Colors.green.withValues(alpha: .10)
            : AppColors.destructive.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? Colors.green : AppColors.destructive,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
            color: isCorrect ? Colors.green : AppColors.destructive,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isCorrect ? 'إجابة صحيحة! 🎉' : 'الإجابة الصحيحة: $correctAnswer',
              textDirection: TextDirection.rtl,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          final horizontalPadding = isMobile ? 20.0 : 32.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 24 : 34),
                decoration: BoxDecoration(
                  color: AppColors.cardColor(context),
                  borderRadius: BorderRadius.circular(isMobile ? 24 : 30),
                  border: Border.all(color: AppColors.borderColor(context)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: isMobile ? 72 : 84,
                      height: isMobile ? 72 : 84,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(isMobile ? 22 : 26),
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        size: isMobile ? 38 : 44,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'خلصت المراجعة! 🎉',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'نتيجتك',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.subtitleColor(context),
                      ),
                    ),
                    const SizedBox(height: 18),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      height: isMobile ? 52 : 56,
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
          );
        },
      ),
    );
  }
}

class _EmptyReviewState extends StatelessWidget {
  const _EmptyReviewState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isMobile ? 78 : 88,
                    height: isMobile ? 78 : 88,
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      Icons.style_outlined,
                      size: isMobile ? 38 : 44,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'مفيش كلمات للمراجعة',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
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
        },
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth < 600 ? 20.0 : 32.0;

          return SingleChildScrollView(
            padding: EdgeInsets.all(horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 50,
                    color: AppColors.destructive,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'حصل خطأ في تحميل الكلمات',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
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
        },
      ),
    );
  }
}
