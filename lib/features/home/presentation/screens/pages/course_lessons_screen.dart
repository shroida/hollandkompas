import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/course.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:hollandkompas/features/home/presentation/providers/course_lessons_provider.dart';

class CourseLessonsScreen extends ConsumerWidget {
  final Course course;

  const CourseLessonsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(courseLessonsProvider(course.id));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Course')),
      body: lessonsAsync.when(
        loading: () => const _LoadingState(),

        error: (error, stackTrace) {
          return _ErrorState(
            error: error,
            onRetry: () {
              ref.invalidate(courseLessonsProvider(course.id));
            },
          );
        },

        data: (lessons) {
          return _CourseLessonsContent(course: course, lessons: lessons);
        },
      ),
    );
  }
}

class _CourseLessonsContent extends StatelessWidget {
  final Course course;
  final List<Lesson> lessons;

  const _CourseLessonsContent({required this.course, required this.lessons});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        final isTablet = constraints.maxWidth >= 650;

        final horizontalPadding = isDesktop
            ? 48.0
            : isTablet
            ? 32.0
            : 20.0;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _CourseHeader(
                      course: course,
                      lessonCount: lessons.length,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    32,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SectionHeader(lessonCount: lessons.length),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    16,
                    horizontalPadding,
                    40,
                  ),
                  sliver: SliverList.builder(
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: LessonCard(
                          lesson: lessons[index],
                          isFirst: index == 0,
                          onTap: () {
                            // TODO:
                            // Navigate to LessonScreen
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CourseHeader extends StatelessWidget {
  final Course course;
  final int lessonCount;

  const _CourseHeader({required this.course, required this.lessonCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, Color(0xFF294CA8)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              const SizedBox(width: 14),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  course.level.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Text(
            course.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            course.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              _HeaderStat(
                icon: Icons.menu_book_rounded,
                value: '$lessonCount',
                label: 'Lessons',
              ),

              const SizedBox(width: 24),

              const _HeaderStat(
                icon: Icons.schedule_rounded,
                value: '—',
                label: 'Minutes',
              ),

              const SizedBox(width: 24),

              const _HeaderStat(
                icon: Icons.trending_up_rounded,
                value: '0%',
                label: 'Progress',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeaderStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.75), size: 18),

        const SizedBox(width: 7),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.65),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final int lessonCount;

  const _SectionHeader({required this.lessonCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Course lessons',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),

        const Spacer(),

        Text(
          '$lessonCount lessons',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool isFirst;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.isFirst,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _LessonNumber(number: lesson.lessonOrder, isFirst: isFirst),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      lesson.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.subtitleColor(context),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: AppColors.primary,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          '${lesson.durationMinutes} min',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subtitleColor(context),
                          ),
                        ),

                        if (lesson.videoUrl != null) ...[
                          const SizedBox(width: 14),

                          const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            'Video',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.subtitleColor(context),
                            ),
                          ),
                        ],

                        if (lesson.audioUrl != null) ...[
                          const SizedBox(width: 14),

                          const Icon(
                            Icons.headphones_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LessonNumber extends StatelessWidget {
  final int number;
  final bool isFirst;

  const _LessonNumber({required this.number, required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isFirst ? AppColors.primary : AppColors.muted,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
            color: isFirst ? Colors.white : AppColors.secondary,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ErrorState({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 52,
              color: AppColors.destructive,
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load lessons',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 8),

            Text(
              error.toString(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),

            const SizedBox(height: 18),

            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
