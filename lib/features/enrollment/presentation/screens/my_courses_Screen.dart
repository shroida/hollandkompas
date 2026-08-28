import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/presentation/providers/current_user_provider.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My Courses',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),

        error: (error, stack) => _ErrorState(
          onRetry: () {
            ref.invalidate(currentUserProvider);
          },
        ),

        data: (user) {
          if (user == null) {
            return const _EmptyState();
          }

          final coursesAsync = ref.watch(enrolledCoursesProvider(user.id));

          return coursesAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),

            error: (error, stack) => _ErrorState(
              onRetry: () {
                ref.invalidate(enrolledCoursesProvider(user.id));
              },
            ),

            data: (courses) {
              return _MyCoursesContent(courses: courses);
            },
          );
        },
      ),
    );
  }
}

class _MyCoursesContent extends StatelessWidget {
  final List<EnrolledCourse> courses;

  const _MyCoursesContent({required this.courses});

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const _EmptyState();
    }

    final totalLessons = courses.fold<int>(
      0,
      (sum, course) => sum + course.totalLessons,
    );

    final completedLessons = courses.fold<int>(
      0,
      (sum, course) => sum + course.completedLessons,
    );

    final averageProgress = courses.isEmpty
        ? 0.0
        : courses.fold<double>(0, (sum, course) => sum + course.progress) /
              courses.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1250),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 40 : 20,
                    24,
                    isDesktop ? 40 : 20,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _HeroHeader(
                      coursesCount: courses.length,
                      averageProgress: averageProgress,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 40 : 20,
                    20,
                    isDesktop ? 40 : 20,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _StatsRow(
                      coursesCount: courses.length,
                      totalLessons: totalLessons,
                      completedLessons: completedLessons,
                      averageProgress: averageProgress,
                    ),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 40 : 20,
                    32,
                    isDesktop ? 40 : 20,
                    16,
                  ),
                  sliver: const SliverToBoxAdapter(child: _SectionTitle()),
                ),

                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 40 : 20,
                  ),
                  sliver: isDesktop
                      ? SliverGrid.builder(
                          itemCount: courses.length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 550,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 18,
                                mainAxisExtent: 275,
                              ),
                          itemBuilder: (context, index) {
                            return _CourseCard(enrollment: courses[index]);
                          },
                        )
                      : SliverList.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _CourseCard(enrollment: courses[index]),
                            );
                          },
                        ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final int coursesCount;
  final double averageProgress;

  const _HeroHeader({
    required this.coursesCount,
    required this.averageProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.auto_stories_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keep learning 🚀',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Your learning journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '$coursesCount courses • '
                  '${averageProgress.round()}% average progress',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (MediaQuery.sizeOf(context).width >= 600)
            _ProgressCircle(progress: averageProgress),
        ],
      ),
    );
  }
}

class _ProgressCircle extends StatelessWidget {
  final double progress;

  const _ProgressCircle({required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      height: 82,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.15),
            color: Colors.white,
          ),
          Text(
            '${(progress * 100).round()}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int coursesCount;
  final int totalLessons;
  final int completedLessons;
  final double averageProgress;

  const _StatsRow({
    required this.coursesCount,
    required this.totalLessons,
    required this.completedLessons,
    required this.averageProgress,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StatData(
        icon: Icons.menu_book_rounded,
        value: '$coursesCount',
        label: 'Courses',
      ),
      _StatData(
        icon: Icons.play_lesson_rounded,
        value: '$totalLessons',
        label: 'Total lessons',
      ),
      _StatData(
        icon: Icons.check_circle_outline_rounded,
        value: '$completedLessons',
        label: 'Completed',
      ),
      _StatData(
        icon: Icons.trending_up_rounded,
        value: '${averageProgress.round()}%',
        label: 'Progress',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 650;

        if (isSmall) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: _StatCard(data: stats[0])),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(data: stats[1])),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(data: stats[2])),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(data: stats[3])),
                ],
              ),
            ],
          );
        }

        return Row(
          children: stats
              .map(
                (stat) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _StatCard(data: stat),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _StatData {
  final IconData icon;
  final String value;
  final String label;

  const _StatData({
    required this.icon,
    required this.value,
    required this.label,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(data.icon, color: AppColors.primary, size: 21),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My learning',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Continue where you left off.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CourseCard extends StatelessWidget {
  final EnrolledCourse enrollment;

  const _CourseCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final course = enrollment.course;

    final progress = enrollment.progress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();

    final isCompleted = progress >= 1.0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push(
            '/course-lessons',
            extra: {'course': course, 'isEnrolled': true},
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          course.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.subtitleColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course.level.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Text(
                    isCompleted ? 'Course completed 🎉' : 'Your progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '$percent%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 9),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 9,
                  backgroundColor: AppColors.muted,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 13),

              Row(
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 15,
                    color: AppColors.subtitleColor(context),
                  ),

                  const SizedBox(width: 5),

                  Text(
                    '${enrollment.completedLessons} / '
                    '${enrollment.totalLessons} lessons',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),

                  const Spacer(),

                  TextButton.icon(
                    onPressed: () {
                      context.push(
                        '/course-lessons',
                        extra: {'course': course, 'isEnrolled': true},
                      );
                    },
                    icon: Icon(
                      isCompleted
                          ? Icons.replay_rounded
                          : Icons.arrow_forward_rounded,
                      size: 17,
                    ),
                    label: Text(isCompleted ? 'Review' : 'Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.primary,
                  size: 42,
                ),
              ),

              const SizedBox(height: 22),

              Text(
                'Your courses are waiting',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'You have not enrolled in any courses yet. '
                'Start learning Dutch today.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.subtitleColor(context),
                ),
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: () {
                  context.go('/home');
                },
                icon: const Icon(Icons.explore_rounded),
                label: const Text('Explore courses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              'Unable to load your courses',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Something went wrong while loading your enrolled courses.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),

            const SizedBox(height: 20),

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
