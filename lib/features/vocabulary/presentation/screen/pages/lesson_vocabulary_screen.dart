import 'package:flutter/material.dart';
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

  late Future<List<Map<String, dynamic>>> _wordsFuture;

  @override
  void initState() {
    super.initState();
    _wordsFuture = _loadWords();
  }

  Future<List<Map<String, dynamic>>> _loadWords() async {
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

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'كلمات الدرس',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wordsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _buildError(snapshot.error);
          }

          final words = snapshot.data ?? [];

          if (words.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'لا توجد كلمات مرتبطة بهذا الدرس حاليًا.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _wordsFuture = _loadWords();
              });

              await _wordsFuture;
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _VocabularyCard(word: words[index], index: index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 16),
            const Text(
              'حدث خطأ أثناء تحميل كلمات الدرس.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                setState(() {
                  _wordsFuture = _loadWords();
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VocabularyCard extends StatelessWidget {
  const _VocabularyCard({required this.word, required this.index});

  final Map<String, dynamic> word;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dutchWord = word['word']?.toString() ?? '';
    final arabicMeaning = word['translation_ar']?.toString() ?? '';
    final englishMeaning = word['translation_en']?.toString() ?? '';
    final category = word['category']?.toString() ?? '';

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.10),
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dutchWord,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    arabicMeaning,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (englishMeaning.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      englishMeaning,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                  if (category.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.withValues(alpha: 0.10),
                      ),
                      child: Text(
                        _categoryLabel(category),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      default:
        return category;
    }
  }
}
