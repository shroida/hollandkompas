import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/continue_learning.dart';
import 'package:hollandkompas/features/home/presentation/providers/continue_learning_provider.dart';

class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key, required this.data});

  final ContinueLearning data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final progress = data.progress.clamp(0.0, 1.0);

    final percent = (progress * 100).round();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openLesson(context),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.secondary, AppColors.primary],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.play_lesson_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Continue Learning',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          data.course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subtitleColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      data.course.level.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                data.lesson.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Lesson ${data.currentIndex + 1} '
                'of ${data.lessons.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.muted,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$percent%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openLesson(context),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLesson(BuildContext context) {
    context.push(
      RoutePaths.lessonViewer,
      extra: {
        'course': data.course,
        'lesson': data.lesson,
        'lessons': data.lessons,
        'currentIndex': data.currentIndex,
        'isEnrolled': true,
        'totalLessons': data.lessons.length,
      },
    );
  }
}

class ContinueLearningSection extends ConsumerWidget {
  const ContinueLearningSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(continueLearningProvider);

    return state.when(
      loading: () {
        return const _ContinueLearningLoading();
      },

      error: (error, stackTrace) {
        debugPrint('ContinueLearning ERROR: $error');

        debugPrintStack(stackTrace: stackTrace);

        return _ContinueLearningError(message: error.toString());
      },

      data: (data) {
        if (data == null) {
          return const _NoContinueLearning();
        }

        return ContinueLearningCard(data: data);
      },
    );
  }
}

class _ContinueLearningLoading extends StatelessWidget {
  const _ContinueLearningLoading();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: const SizedBox(
        height: 150,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _NoContinueLearning extends StatelessWidget {
  const _NoContinueLearning();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.play_lesson_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No lesson to continue',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Complete or start a lesson to see it here.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContinueLearningError extends StatelessWidget {
  const _ContinueLearningError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.destructive,
              size: 32,
            ),
            const SizedBox(height: 10),
            const Text(
              'Unable to load Continue Learning',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                color: AppColors.subtitleColor(context),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
