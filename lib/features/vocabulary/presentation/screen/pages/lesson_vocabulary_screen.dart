import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/datasource/lesson_vocabulary_remote_datasource.dart';

class LessonVocabularyScreen extends StatefulWidget {
  const LessonVocabularyScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonVocabularyScreen> createState() => _LessonVocabularyScreenState();
}

class _LessonVocabularyScreenState extends State<LessonVocabularyScreen> {
  late final LessonVocabularyRemoteDataSource _dataSource;

  final TextEditingController _searchController = TextEditingController();

  Future<LessonVocabularyData>? _dataFuture;

  String _searchQuery = '';
  String? _playingWordId;

  final Set<String> _favoriteIds = <String>{};
  final Map<String, String> _progressMap = <String, String>{};

  // الكلمات التي يوجد لها request حالي إلى Supabase.
  final Set<String> _favoritePendingIds = <String>{};
  final Set<String> _progressPendingIds = <String>{};

  @override
  void initState() {
    super.initState();

    _dataSource = LessonVocabularyRemoteDataSource(Supabase.instance.client);

    _initialize();
  }

  Future<void> _initialize() async {
    await _dataSource.initialize();

    if (!mounted) return;

    _dataFuture = _loadData();

    setState(() {});
  }

  Future<LessonVocabularyData> _loadData() async {
    final data = await _dataSource.getLessonVocabulary(widget.lesson.id);

    if (!mounted) {
      return data;
    }

    _favoriteIds
      ..clear()
      ..addAll(data.userState.favoriteIds);

    _progressMap
      ..clear()
      ..addAll(data.userState.progressMap);

    return data;
  }

  Future<void> _refresh() async {
    final future = _loadData();

    if (mounted) {
      setState(() {
        _dataFuture = future;
      });
    }

    await future;
  }

  Future<void> _toggleFavorite(LessonVocabularyWord word) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _showSnackBar('لازم تكون مسجل دخول لحفظ المفضلة.');
      return;
    }

    // نفس الكلمة لا يمكن إرسال requestين لها في نفس الوقت.
    if (_favoritePendingIds.contains(word.id)) {
      return;
    }

    final oldValue = _favoriteIds.contains(word.id);
    final newValue = !oldValue;

    // Optimistic UI.
    if (mounted) {
      setState(() {
        if (newValue) {
          _favoriteIds.add(word.id);
        } else {
          _favoriteIds.remove(word.id);
        }

        _favoritePendingIds.add(word.id);
      });
    }

    try {
      await _dataSource.setFavorite(wordId: word.id, isFavorite: newValue);
    } catch (error) {
      if (!mounted) return;

      // Rollback.
      setState(() {
        if (oldValue) {
          _favoriteIds.add(word.id);
        } else {
          _favoriteIds.remove(word.id);
        }
      });

      _showSnackBar('حصل خطأ أثناء تحديث المفضلة.');
    } finally {
      if (!mounted) return;

      setState(() {
        _favoritePendingIds.remove(word.id);
      });
    }
  }

  Future<void> _updateProgress(LessonVocabularyWord word, String status) async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      _showSnackBar('لازم تكون مسجل دخول لحفظ التقدم.');
      return;
    }

    // نفس الكلمة لا تعمل أكثر من request في نفس الوقت.
    if (_progressPendingIds.contains(word.id)) {
      return;
    }

    final oldStatus = _progressMap[word.id] ?? 'new';

    // لو اختار نفس الحالة الموجودة بالفعل، مفيش داعي لأي request.
    if (oldStatus == status) {
      return;
    }

    // Optimistic UI:
    // الحالة تتغير فوراً على الشاشة قبل Supabase.
    if (mounted) {
      setState(() {
        _progressMap[word.id] = status;
        _progressPendingIds.add(word.id);
      });
    }

    try {
      await _dataSource.updateProgress(wordId: word.id, status: status);
    } catch (error) {
      if (!mounted) return;

      // Rollback لو Supabase فشل.
      setState(() {
        _progressMap[word.id] = oldStatus;
      });

      _showSnackBar('حصل خطأ أثناء حفظ التقدم.');
    } finally {
      if (!mounted) return;

      setState(() {
        _progressPendingIds.remove(word.id);
      });
    }
  }

  Future<void> _speak(LessonVocabularyWord word) async {
    try {
      if (_playingWordId == word.id) {
        await _dataSource.stopSpeaking();

        if (!mounted) return;

        setState(() {
          _playingWordId = null;
        });

        return;
      }

      await _dataSource.stopSpeaking();

      if (!mounted) return;

      setState(() {
        _playingWordId = word.id;
      });

      await _dataSource.speak(word.dutchWord);

      if (!mounted) return;

      setState(() {
        _playingWordId = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _playingWordId = null;
      });

      _showSnackBar('تعذر تشغيل النطق.');
    }
  }

  List<LessonVocabularyWord> _filterWords(List<LessonVocabularyWord> words) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return words;
    }

    return words
        .where((word) {
          return word.dutchWord.toLowerCase().contains(query) ||
              word.arabicMeaning.toLowerCase().contains(query) ||
              word.englishMeaning.toLowerCase().contains(query) ||
              word.category.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final dataFuture = _dataFuture;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor(context),
      appBar: AppBar(
        title: Column(
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
      body: dataFuture == null
          ? const _LoadingView()
          : FutureBuilder<LessonVocabularyData>(
              future: dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const _LoadingView();
                }

                if (snapshot.hasError) {
                  return _ErrorView(error: snapshot.error, onRetry: _refresh);
                }

                final data = snapshot.data;

                if (data == null || data.words.isEmpty) {
                  return const _EmptyView();
                }

                return _VocabularyContent(
                  data: data,
                  searchController: _searchController,
                  searchQuery: _searchQuery,
                  favoriteIds: _favoriteIds,
                  progressMap: _progressMap,
                  playingWordId: _playingWordId,
                  favoritePendingIds: _favoritePendingIds,
                  progressPendingIds: _progressPendingIds,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onClearSearch: () {
                    _searchController.clear();

                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  onRefresh: _refresh,
                  onSpeak: _speak,
                  onFavorite: _toggleFavorite,
                  onProgressChanged: _updateProgress,
                );
              },
            ),
    );
  }

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text(message),
        ),
      );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _dataSource.dispose();
    super.dispose();
  }
}

class _VocabularyContent extends StatelessWidget {
  const _VocabularyContent({
    required this.data,
    required this.searchController,
    required this.searchQuery,
    required this.favoriteIds,
    required this.progressMap,
    required this.playingWordId,
    required this.favoritePendingIds,
    required this.progressPendingIds,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onRefresh,
    required this.onSpeak,
    required this.onFavorite,
    required this.onProgressChanged,
  });

  final LessonVocabularyData data;

  final TextEditingController searchController;

  final String searchQuery;

  final Set<String> favoriteIds;

  final Map<String, String> progressMap;

  final String? playingWordId;

  final Set<String> favoritePendingIds;

  final Set<String> progressPendingIds;

  final ValueChanged<String> onSearchChanged;

  final VoidCallback onClearSearch;

  final Future<void> Function() onRefresh;

  final ValueChanged<LessonVocabularyWord> onSpeak;

  final ValueChanged<LessonVocabularyWord> onFavorite;

  final Future<void> Function(LessonVocabularyWord word, String status)
  onProgressChanged;

  @override
  Widget build(BuildContext context) {
    final words = _filterWords(data.words);

    final favoriteCount = favoriteIds.length;

    final masteredCount = progressMap.values
        .where((status) => status == 'mastered')
        .length;

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.cardColor(context),
      onRefresh: onRefresh,
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
                    totalWords: data.words.length,
                    favoriteWords: favoriteCount,
                    masteredWords: masteredCount,
                  ),
                  const SizedBox(height: 14),
                  _SearchField(
                    controller: searchController,
                    onChanged: onSearchChanged,
                    onClear: onClearSearch,
                  ),
                  if (searchQuery.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        '${words.length} كلمة',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.subtitleColor(context),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (words.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _NoSearchResultsView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              sliver: SliverList.builder(
                itemCount: words.length,
                itemBuilder: (context, index) {
                  final word = words[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: RepaintBoundary(
                      child: _VocabularyCard(
                        word: word,
                        index: index,
                        isFavorite: favoriteIds.contains(word.id),
                        progress: progressMap[word.id] ?? 'new',
                        isPlaying: playingWordId == word.id,
                        isFavoritePending: favoritePendingIds.contains(word.id),
                        isProgressPending: progressPendingIds.contains(word.id),
                        onSpeak: () => onSpeak(word),
                        onFavorite: () => onFavorite(word),
                        onProgressChanged: (status) =>
                            onProgressChanged(word, status),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  List<LessonVocabularyWord> _filterWords(List<LessonVocabularyWord> words) {
    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return words;
    }

    return words
        .where((word) {
          return word.dutchWord.toLowerCase().contains(query) ||
              word.arabicMeaning.toLowerCase().contains(query) ||
              word.englishMeaning.toLowerCase().contains(query) ||
              word.category.toLowerCase().contains(query);
        })
        .toList(growable: false);
  }
}

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
              const _SummaryDivider(),
              Expanded(
                child: _SummaryItem(
                  value: '$favoriteWords',
                  label: 'مفضلة',
                  icon: Icons.favorite_rounded,
                ),
              ),
              const _SummaryDivider(),
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
      textInputAction: TextInputAction.search,
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

class _VocabularyCard extends StatelessWidget {
  const _VocabularyCard({
    required this.word,
    required this.index,
    required this.isFavoritePending,
    required this.isProgressPending,
    required this.isFavorite,
    required this.progress,
    required this.isPlaying,
    required this.onSpeak,
    required this.onFavorite,
    required this.onProgressChanged,
  });

  final LessonVocabularyWord word;
  final int index;
  final bool isFavorite;
  final String progress;
  final bool isFavoritePending;
  final bool isProgressPending;
  final bool isPlaying;
  final VoidCallback onSpeak;
  final VoidCallback onFavorite;
  final ValueChanged<String> onProgressChanged;

  @override
  Widget build(BuildContext context) {
    final progressData = _progressData(progress);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.cardColor(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderColor(context)),
      ),
      child: InkWell(
        onTap: onSpeak,
        borderRadius: BorderRadius.circular(20),
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
                        loading: isFavoritePending,
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
                    loading: isProgressPending,
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

  ({String label, IconData icon, Color color}) _progressData(String value) {
    switch (value) {
      case 'learning':
        return (
          label: 'بتتعلمها',
          icon: Icons.school_rounded,
          color: AppColors.warning,
        );

      case 'mastered':
        return (
          label: 'متقنها',
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
                    onProgressChanged('new');
                    Navigator.pop(sheetContext);
                  },
                ),

                _ProgressOption(
                  label: 'بتتعلمها',
                  icon: Icons.school_rounded,
                  color: AppColors.warning,
                  selected: current == 'learning',
                  onTap: () {
                    onProgressChanged('learning');
                    Navigator.pop(sheetContext);
                  },
                ),

                _ProgressOption(
                  label: 'متقنها',
                  icon: Icons.check_circle_rounded,
                  color: AppColors.success,
                  selected: current == 'mastered',
                  onTap: () {
                    onProgressChanged('mastered');
                    Navigator.pop(sheetContext);
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
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.muted.withValues(alpha: 0.60),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(13),
        child: SizedBox(
          width: 42,
          height: 42,
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Icon(
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
    this.loading = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              loading
                  ? SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    )
                  : Icon(icon, size: 14, color: color),
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
  final Future<void> Function() onRetry;

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
