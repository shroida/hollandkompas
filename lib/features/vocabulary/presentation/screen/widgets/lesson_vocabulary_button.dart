import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';

class LessonVocabularyButton extends StatelessWidget {
  const LessonVocabularyButton({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.push('/lesson-vocabulary', extra: lesson);
        },
        icon: const Icon(Icons.menu_book_rounded),
        label: const Text(
          'كلمات الدرس',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
