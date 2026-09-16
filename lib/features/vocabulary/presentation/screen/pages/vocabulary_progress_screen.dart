import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/vocabulary_user_providers.dart';
import '../widgets/progress_summary_widget.dart';

class VocabularyProgressScreen extends ConsumerWidget {
  const VocabularyProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(vocabularyProgressStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('التقدم')),
      body: statsAsync.when(
        data: (stats) => Padding(
          padding: const EdgeInsets.all(18),
          child: ProgressSummaryWidget(stats: stats),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('حصل خطأ: $error')),
      ),
    );
  }
}
