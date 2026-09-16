import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonVocabularyScreen extends StatefulWidget {
  const LessonVocabularyScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonVocabularyScreen> createState() => _LessonVocabularyScreenState();
}

class _LessonVocabularyScreenState extends State<LessonVocabularyScreen> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<_LessonVocabularyItem>> _wordsFuture;

  String _searchQuery = '';
  String? _playingWordId;
  final Set<String> _favoriteIds = <String>{};
  final Map<String, String> _progressMap = <String, String>{};

  bool _loadingUserState = true;

  @override
  void initState() {
    super.initState();

    _configureTts();
    _wordsFuture = _loadWords();
  }

  Future<void> _configureTts() async {
    try {
      await _tts.setLanguage('nl-NL');
      await _tts.setSpeechRate(0.42);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);

      await _tts.awaitSpeakCompletion(true);
    } catch (error) {
      debugPrint('[LESSON-VOCAB] TTS setup failed: $error');
    }
  }

  Future<List<_LessonVocabularyItem>> _loadWords() async {
    final response = await _supabase
        .from('vocabularies')
        .select('''
          id,
          lesson_id,
          word,
          translation_en,
          translation_ar,
          category,
          created_at
        ''')
        .eq('lesson_id', widget.lesson.id)
        .order('id', ascending: true);

    final rows = List<Map<String, dynamic>>.from(response);

    final words = rows
        .map(_LessonVocabularyItem.fromMap)
        .toList(growable: false);

    await _loadUserState(words);

    return words;
  }

  Future<void> _loadUserState(List<_LessonVocabularyItem> words) async {
    final user = _supabase.auth.currentUser;

    if (user == null || words.isEmpty) {
      if (mounted) {
        setState(() {
          _loadingUserState = false;
        });
      }
      return;
    }

    try {
      final wordIds = words.map((word) => word.id).toList();

      final favoritesResponse = await _supabase
          .from('user_favorite_words')
          .select('word_id')
          .eq('user_id', user.id)
          .inFilter('word_id', wordIds);

      final progressResponse = await _supabase
          .from('user_vocabulary_progress')
          .select('word_id, status')
          .eq('user_id', user.id)
          .inFilter('word_id', wordIds);

      final favoriteRows = List<Map<String, dynamic>>.from(favoritesResponse);

      final progressRows = List<Map<String, dynamic>>.from(progressResponse);

      _favoriteIds
        ..clear()
        ..addAll(
          favoriteRows
              .map((row) => row['word_id']?.toString())
              .whereType<String>(),
        );

      _progressMap
        ..clear()
        ..addEntries(
          progressRows.map(
            (row) => MapEntry(
              row['word_id']?.toString() ?? '',
              row['status']?.toString() ?? 'new',
            ),
          ),
        );
    } catch (error) {
      debugPrint('[LESSON-VOCAB] Failed to load user state: $error');
    } finally {
      if (mounted) {
        setState(() {
          _loadingUserState = false;
        });
      }
    }
  }

  Future<void> _toggleFavorite(_LessonVocabularyItem word) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      _showSnackBar('لازم تكون مسجل دخول لحفظ المفضلة.');
      return;
    }

    final currentlyFavorite = _favoriteIds.contains(word.id);

    try {
      if (currentlyFavorite) {
        await _supabase
            .from('user_favorite_words')
            .delete()
            .eq('user_id', user.id)
            .eq('word_id', word.id);

        if (!mounted) return;

        setState(() {
          _favoriteIds.remove(word.id);
        });
      } else {
        await _supabase.from('user_favorite_words').insert({
          'user_id': user.id,
          'word_id': word.id,
        });

        if (!mounted) return;

        setState(() {
          _favoriteIds.add(word.id);
        });
      }
    } catch (error) {
      debugPrint('[LESSON-VOCAB] Favorite error: $error');

      _showSnackBar('حصل خطأ أثناء تحديث المفضلة.');
    }
  }

  Future<void> _updateProgress(
    _LessonVocabularyItem word,
    String status,
  ) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      _showSnackBar('لازم تكون مسجل دخول لحفظ التقدم.');
      return;
    }

    try {
      await _supabase.from('user_vocabulary_progress').upsert({
        'user_id': user.id,
        'word_id': word.id,
        'status': status,
      }, onConflict: 'user_id,word_id');

      if (!mounted) return;

      setState(() {
        _progressMap[word.id] = status;
      });
    } catch (error) {
      debugPrint('[LESSON-VOCAB] Progress error: $error');

      _showSnackBar('حصل خطأ أثناء حفظ التقدم.');
    }
  }

  Future<void> _speak(_LessonVocabularyItem word) async {
    try {
      if (_playingWordId == word.id) {
        await _tts.stop();

        if (!mounted) return;

        setState(() {
          _playingWordId = null;
        });

        return;
      }

      await _tts.stop();

      if (!mounted) return;

      setState(() {
        _playingWordId = word.id;
      });

      await _tts.speak(word.dutchWord);

      if (!mounted) return;

      setState(() {
        _playingWordId = null;
      });
    } catch (error) {
      debugPrint('[LESSON-VOCAB] TTS error: $error');

      if (!mounted) return;

      setState(() {
        _playingWordId = null;
      });

      _showSnackBar('تعذر تشغيل النطق.');
    }
  }

  List<_LessonVocabularyItem> _filterWords(List<_LessonVocabularyItem> words) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return words;
    }

    return words.where((word) {
      return word.dutchWord.toLowerCase().contains(query) ||
          word.arabicMeaning.toLowerCase().contains(query) ||
          word.englishMeaning.toLowerCase().contains(query) ||
          word.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'كلمات الدرس',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text(
              widget.lesson.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.subtitleColor(context),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<_LessonVocabularyItem>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingView();
          }

          if (snapshot.hasError) {
            return _ErrorView(
              error: snapshot.error,
              onRetry: () {
                setState(() {
                  _wordsFuture = _loadWords();
                  _loadingUserState = true;
                });
              },
            );
          }

          final allWords = snapshot.data ?? const [];

          if (allWords.isEmpty) {
            return const _EmptyView();
          }

          final filteredWords = _filterWords(allWords);

          final favoriteCount = allWords
              .where((word) => _favoriteIds.contains(word.id))
              .length;

          final masteredCount = allWords
              .where((word) => _progressMap[word.id] == 'mastered')
              .length;

          return RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.cardColor(context),
            onRefresh: () async {
              setState(() {
                _wordsFuture = _loadWords();
                _loadingUserState = true;
              });

              await _wordsFuture;
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Column(
                      children: [
                        _LessonSummaryCard(
                          totalWords: allWords.length,
                          favoriteWords: favoriteCount,
                          masteredWords: masteredCount,
                        ),
                        const SizedBox(height: 14),
                        _SearchField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          onClear: () {
                            _searchController.clear();

                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                        const SizedBox(height: 14),
                        if (_searchQuery.isNotEmpty)
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              '${filteredWords.length} كلمة',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.subtitleColor(context),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (filteredWords.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _NoSearchResultsView(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                    sliver: SliverList.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _VocabularyCard(
                            word: word,
                            index: index,
                            isFavorite: _favoriteIds.contains(word.id),
                            progress: _progressMap[word.id] ?? 'new',
                            isPlaying: _playingWordId == word.id,
                            onSpeak: () => _speak(word),
                            onFavorite: () => _toggleFavorite(word),
                            onProgressChanged: (status) =>
                                _updateProgress(word, status),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _searchController.dispose();
    super.dispose();
  }
}

// ============================================================
// DATA MODEL
// ============================================================

class _LessonVocabularyItem {
  const _LessonVocabularyItem({
    required this.id,
    required this.lessonId,
    required this.dutchWord,
    required this.arabicMeaning,
    required this.englishMeaning,
    required this.category,
    this.createdAt,
  });

  final String id;
  final String lessonId;
  final String dutchWord;
  final String arabicMeaning;
  final String englishMeaning;
  final String category;
  final DateTime? createdAt;

  factory _LessonVocabularyItem.fromMap(Map<String, dynamic> map) {
    return _LessonVocabularyItem(
      id: map['id']?.toString() ?? '',
      lessonId: map['lesson_id']?.toString() ?? '',
      dutchWord: map['word']?.toString() ?? '',
      arabicMeaning: map['translation_ar']?.toString() ?? '',
      englishMeaning: map['translation_en']?.toString() ?? '',
      category: map['category']?.toString() ?? '',
      createdAt: map['created_at'] == null
          ? null
          : DateTime.tryParse(map['created_at'].toString()),
    );
  }
}

// ============================================================
// SUMMARY CARD
// ============================================================

class _LessonSummaryCard extends StatelessWidget {
  const _LessonSummaryCard({
    required this.totalWords,
    required this.favoriteWords,
    required this.masteredWords,
  });

  final int totalWords;
  final int favoriteWords;
  final int masteredWords;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            isDark ? AppColors.darkCard : AppColors.card,
            isDark ? AppColors.darkMuted : AppColors.accent,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.borderColor(context)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'مفردات الدرس',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SummaryItem(
                  value: '$totalWords',
                  label: 'كلمة',
                  icon: Icons.translate_rounded,
                ),
              ),
              _SummaryDivider(),
              Expanded(
                child: _SummaryItem(
                  value: '$favoriteWords',
                  label: 'مفضلة',
                  icon: Icons.favorite_rounded,
                ),
              ),
              _SummaryDivider(),
              Expanded(
                child: _SummaryItem(
                  value: '$masteredWords',
                  label: 'محفوظة',
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 42,
      color: AppColors.borderColor(context),
    );
  }
}

// ============================================================
// SEARCH
// ============================================================

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      decoration: InputDecoration(
        hintText: 'ابحث في كلمات الدرس...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }
}

// ============================================================
// VOCABULARY CARD
// ============================================================

class _VocabularyCard extends StatelessWidget {
  const _VocabularyCard({
    required this.word,
    required this.index,
    required this.isFavorite,
    required this.progress,
    required this.isPlaying,
    required this.onSpeak,
    required this.onFavorite,
    required this.onProgressChanged,
  });

  final _LessonVocabularyItem word;
  final int index;
  final bool isFavorite;
  final String progress;
  final bool isPlaying;
  final VoidCallback onSpeak;
  final VoidCallback onFavorite;
  final ValueChanged<String> onProgressChanged;

  @override
  Widget build(BuildContext context) {
    final progressData = _progressData(context, progress);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.cardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderColor(context)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onSpeak,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WordNumber(number: index + 1),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.dutchWord,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          word.arabicMeaning,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (word.englishMeaning.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            word.englishMeaning,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.subtitleColor(context),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    children: [
                      _CircleActionButton(
                        icon: isPlaying
                            ? Icons.stop_rounded
                            : Icons.volume_up_rounded,
                        active: isPlaying,
                        onTap: onSpeak,
                      ),
                      const SizedBox(height: 7),
                      _CircleActionButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        active: isFavorite,
                        onTap: onFavorite,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _CategoryChip(
                    label: _categoryLabel(word.category),
                    icon: _categoryIcon(word.category),
                  ),
                  const Spacer(),
                  _ProgressBadge(
                    label: progressData.label,
                    icon: progressData.icon,
                    color: progressData.color,
                    onTap: () {
                      _showProgressMenu(context, current: progress);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({String label, IconData icon, Color color}) _progressData(
    BuildContext context,
    String value,
  ) {
    switch (value) {
      case 'learning':
        return (
          label: 'بتتعلمها',
          icon: Icons.school_rounded,
          color: AppColors.warning,
        );
      case 'mastered':
        return (
          label: 'محفوظة',
          icon: Icons.check_circle_rounded,
          color: AppColors.success,
        );
      case 'new':
      default:
        return (
          label: 'جديدة',
          icon: Icons.fiber_new_rounded,
          color: AppColors.mutedForeground,
        );
    }
  }

  void _showProgressMenu(BuildContext context, {required String current}) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.cardColor(context),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'حالة الكلمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                _ProgressOption(
                  label: 'جديدة',
                  icon: Icons.fiber_new_rounded,
                  color: AppColors.mutedForeground,
                  selected: current == 'new',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onProgressChanged('new');
                  },
                ),
                _ProgressOption(
                  label: 'بتتعلمها',
                  icon: Icons.school_rounded,
                  color: AppColors.warning,
                  selected: current == 'learning',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onProgressChanged('learning');
                  },
                ),
                _ProgressOption(
                  label: 'محفوظة',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  selected: current == 'mastered',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onProgressChanged('mastered');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// SMALL COMPONENTS
// ============================================================

class _WordNumber extends StatelessWidget {
  const _WordNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Text(
        '$number',
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  const _CircleActionButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.muted.withValues(alpha: 0.60),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            icon,
            size: 21,
            color: active
                ? AppColors.primary
                : AppColors.subtitleColor(context),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.muted.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.secondary),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressOption extends StatelessWidget {
  const _ProgressOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: color)
          : null,
    );
  }
}

// ============================================================
// STATES
// ============================================================

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 58,
            height: 58,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          const SizedBox(height: 14),
          Text(
            'بنجهز كلمات الدرس...',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.subtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                size: 36,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'مفيش كلمات للدرس ده لسه',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              'لما تضيف كلمات مرتبطة بالدرس هتظهر هنا.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.subtitleColor(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoSearchResultsView extends StatelessWidget {
  const _NoSearchResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.subtitleColor(context),
            ),
            const SizedBox(height: 12),
            const Text(
              'مفيش نتائج',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(
              'جرب كلمة مختلفة.',
              style: TextStyle(color: AppColors.subtitleColor(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.destructive.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 34,
                color: AppColors.destructive,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'حصل خطأ أثناء تحميل الكلمات',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.subtitleColor(context),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
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

// ============================================================
// HELPERS
// ============================================================

String _categoryLabel(String category) {
  switch (category.toLowerCase()) {
    case 'verb':
      return 'فعل';
    case 'noun':
      return 'اسم';
    case 'adjective':
      return 'صفة';
    case 'adverb':
      return 'ظرف';
    case 'pronoun':
      return 'ضمير';
    case 'conjunction':
      return 'أداة ربط';
    case 'expression':
      return 'تعبير';
    case 'question':
      return 'سؤال';
    case 'greeting':
      return 'تحية';
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
      return 'مشروب';
    case 'family':
      return 'عائلة';
    case 'weather':
      return 'طقس';
    case 'time':
      return 'وقت';
    default:
      return category;
  }
}

IconData _categoryIcon(String category) {
  switch (category.toLowerCase()) {
    case 'verb':
      return Icons.directions_run_rounded;
    case 'noun':
      return Icons.label_outline_rounded;
    case 'adjective':
      return Icons.auto_awesome_outlined;
    case 'adverb':
      return Icons.speed_rounded;
    case 'pronoun':
      return Icons.person_outline_rounded;
    case 'conjunction':
      return Icons.link_rounded;
    case 'expression':
      return Icons.chat_bubble_outline_rounded;
    case 'question':
      return Icons.help_outline_rounded;
    case 'greeting':
      return Icons.waving_hand_outlined;
    case 'phone':
      return Icons.phone_outlined;
    case 'grammar':
      return Icons.menu_book_outlined;
    case 'location':
      return Icons.location_on_outlined;
    case 'food':
      return Icons.restaurant_outlined;
    case 'money':
      return Icons.payments_outlined;
    case 'drink':
      return Icons.local_drink_outlined;
    case 'family':
      return Icons.groups_outlined;
    case 'weather':
      return Icons.cloud_outlined;
    case 'time':
      return Icons.schedule_outlined;
    default:
      return Icons.category_outlined;
  }
}
