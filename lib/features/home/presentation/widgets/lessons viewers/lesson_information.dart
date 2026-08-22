import 'package:flutter/material.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/info_tile.dart';

class LessonInformation extends StatelessWidget {
  final Lesson lesson;

  const LessonInformation({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoTile(
            icon: Icons.play_lesson_rounded,
            value: 'Lesson ${lesson.lessonOrder}',
            label: 'Course lesson',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: InfoTile(
            icon: Icons.schedule_rounded,
            value: '${lesson.durationMinutes} min',
            label: 'Duration',
          ),
        ),
      ],
    );
  }
}
