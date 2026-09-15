import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/localization/app_locale.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/auth/presentation/providers/auth_controller.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/enrollment/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/enrollment/presentation/screens/widgets/my_courses_appbar.dart';

class MyCoursesScreen extends ConsumerWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const MyCoursesAppBar(),
      body: _buildBody(context, ref, authState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, dynamic authState) {
    if (authState.isLoading) {
      return const _LoadingState();
    }

    final user = authState.user;

    if (user == null) {
      return const _EmptyState();
    }

    final coursesAsync = ref.watch(enrolledCoursesProvider(user.id));

    return coursesAsync.when(
      loading: () => const _LoadingState(),
      error: (_, __) =>
          _ErrorState(onRetry: () => _refreshCourses(ref, user.id)),
      data: (courses) => _CoursesContent(
        courses: courses,
        onRefresh: () => _refreshCourses(ref, user.id),
      ),
    );
  }

  Future<void> _refreshCourses(WidgetRef ref, String userId) async {
    final provider = enrolledCoursesProvider(userId);

    ref.invalidate(provider);

    await ref.read(provider.future);
  }
}

class _CoursesContent extends ConsumerWidget {
  const _CoursesContent({required this.courses, required this.onRefresh});

  final List<EnrolledCourse> courses;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (courses.isEmpty) {
      return _RefreshableEmptyState(onRefresh: onRefresh);
    }

    final languageCode = ref.watch(
      appLocaleProvider.select((locale) => locale.languageCode),
    );

    final stats = CourseStats.from(courses);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        final horizontalPadding = isDesktop ? 40.0 : 20.0;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1250),
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: onRefresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      24,
                      horizontalPadding,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _HeroHeader(
                        coursesCount: stats.coursesCount,
                        averageProgress: stats.averageProgress,
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      20,
                      horizontalPadding,
                      0,
                    ),
                    sliver: SliverToBoxAdapter(child: _StatsRow(stats: stats)),
                  ),

                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
                    sliver: SliverToBoxAdapter(child: _SectionTitle()),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: _CoursesGrid(
                      courses: courses,
                      languageCode: languageCode,
                      isDesktop: isDesktop,
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CoursesGrid extends StatelessWidget {
  const _CoursesGrid({
    required this.courses,
    required this.languageCode,
    required this.isDesktop,
  });

  final List<EnrolledCourse> courses;
  final String languageCode;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    if (!isDesktop) {
      return SliverList.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _CourseCard(
              enrollment: courses[index],
              languageCode: languageCode,
            ),
          );
        },
      );
    }

    return SliverGrid.builder(
      itemCount: courses.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 550,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        mainAxisExtent: 275,
      ),
      itemBuilder: (context, index) {
        return _CourseCard(
          enrollment: courses[index],
          languageCode: languageCode,
        );
      },
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.enrollment, required this.languageCode});

  final EnrolledCourse enrollment;
  final String languageCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final course = enrollment.course;

    final description =
        course.descriptions[languageCode] ?? course.descriptions['en'] ?? '';

    final progress = enrollment.progress.clamp(0.0, 1.0);
    final percent = (progress * 100).round();
    final completed = progress >= 1.0;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openCourse(context, course),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const _CourseIcon(),
                  const SizedBox(width: 14),

                  Expanded(
                    child: _CourseInfo(
                      title: course.title,
                      description: description,
                    ),
                  ),

                  const SizedBox(width: 10),

                  _LevelBadge(level: course.level),
                ],
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Text(
                    completed ? 'Course completed 🎉' : 'Your progress',
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

              const Spacer(),

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
                    onPressed: () => _openCourse(context, course),
                    icon: Icon(
                      completed
                          ? Icons.replay_rounded
                          : Icons.arrow_forward_rounded,
                      size: 17,
                    ),
                    label: Text(completed ? 'Review' : 'Continue'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCourse(BuildContext context, Course course) {
    context.push(RoutePaths.courseLessons, extra: course);
  }
}

class _CourseIcon extends StatelessWidget {
  const _CourseIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Icon(Icons.translate_rounded, color: Colors.white, size: 27),
    );
  }
}

class _CourseInfo extends StatelessWidget {
  const _CourseInfo({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.subtitleColor(context),
          ),
        ),
      ],
    );
  }
}

class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.coursesCount,
    required this.averageProgress,
  });

  final int coursesCount;
  final double averageProgress;

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
                  '${(averageProgress * 100).round()}% average progress',
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
  const _ProgressCircle({required this.progress});

  final double progress;

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

class CourseStats {
  const CourseStats({
    required this.coursesCount,
    required this.totalLessons,
    required this.completedLessons,
    required this.averageProgress,
  });

  final int coursesCount;
  final int totalLessons;
  final int completedLessons;
  final double averageProgress;

  factory CourseStats.from(List<EnrolledCourse> courses) {
    if (courses.isEmpty) {
      return const CourseStats(
        coursesCount: 0,
        totalLessons: 0,
        completedLessons: 0,
        averageProgress: 0,
      );
    }

    var totalLessons = 0;
    var completedLessons = 0;
    var progressTotal = 0.0;

    for (final course in courses) {
      totalLessons += course.totalLessons;
      completedLessons += course.completedLessons;
      progressTotal += course.progress;
    }

    return CourseStats(
      coursesCount: courses.length,
      totalLessons: totalLessons,
      completedLessons: completedLessons,
      averageProgress: progressTotal / courses.length,
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final CourseStats stats;

  @override
  Widget build(BuildContext context) {
    final items = [
      const _StatData(icon: Icons.menu_book_rounded, label: 'Courses'),
      const _StatData(icon: Icons.play_lesson_rounded, label: 'Total lessons'),
      const _StatData(
        icon: Icons.check_circle_outline_rounded,
        label: 'Completed',
      ),
      const _StatData(icon: Icons.trending_up_rounded, label: 'Progress'),
    ];

    final values = [
      '${stats.coursesCount}',
      '${stats.totalLessons}',
      '${stats.completedLessons}',
      '${(stats.averageProgress * 100).round()}%',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 650) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(data: items[0], value: values[0]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(data: items[1], value: values[1]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(data: items[2], value: values[2]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(data: items[3], value: values[3]),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : 12,
                ),
                child: _StatCard(data: items[index], value: values[index]),
              ),
            );
          }),
        );
      },
    );
  }
}

class _StatData {
  const _StatData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data, required this.value});

  final _StatData data;
  final String value;

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
                    value,
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

    return Column(
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

class _RefreshableEmptyState extends StatelessWidget {
  const _RefreshableEmptyState({required this.onRefresh});

  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        children: const [SizedBox(height: 600, child: _EmptyState())],
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
                  context.go(RoutePaths.home);
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

class _ErrorState extends StatefulWidget {
  const _ErrorState({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  State<_ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<_ErrorState> {
  bool _retrying = false;

  Future<void> _retry() async {
    if (_retrying) {
      return;
    }

    setState(() {
      _retrying = true;
    });

    try {
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() {
          _retrying = false;
        });
      }
    }
  }

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
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Something went wrong while loading '
              'your enrolled courses.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _retrying ? null : _retry,
              icon: _retrying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.refresh_rounded),
              label: Text(_retrying ? 'Loading...' : 'Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
