import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/enrolled_course.dart';
import 'package:hollandkompas/features/home/presentation/providers/current_user_provider.dart';
import 'package:hollandkompas/features/home/presentation/providers/enrolled_courses_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(title: const Text('My Profile')),

      body: userAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        },

        error: (error, stack) {
          return _ProfileError(
            error: error,
            onRetry: () {
              ref.invalidate(currentUserProvider);
            },
          );
        },

        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          final enrolledCoursesAsync = ref.watch(
            enrolledCoursesProvider(user.id),
          );

          return enrolledCoursesAsync.when(
            loading: () {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            },

            error: (error, stack) {
              return _ProfileError(
                error: error,
                onRetry: () {
                  ref.invalidate(enrolledCoursesProvider(user.id));
                },
              );
            },

            data: (courses) {
              return _ProfileContent(user: user, courses: courses);
            },
          );
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final dynamic user;
  final List<EnrolledCourse> courses;

  const _ProfileContent({required this.user, required this.courses});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        final horizontalPadding = isDesktop ? 48.0 : 20.0;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    28,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(child: _ProfileHeader(user: user)),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24,
                    horizontalPadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _LearningStats(courses: courses),
                  ),
                ),

                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    36,
                    horizontalPadding,
                    16,
                  ),
                  sliver: const SliverToBoxAdapter(child: _LearningHeader()),
                ),

                if (courses.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: const SliverToBoxAdapter(child: _EmptyCourses()),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      40,
                    ),
                    sliver: SliverList.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _EnrolledCourseCard(enrollment: course),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 14),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final firstName = user.firstName ?? '';
    final lastName = user.lastName ?? '';

    final fullName = '$firstName $lastName'.trim();

    final initials = [
      firstName.isNotEmpty ? firstName[0] : '',
      lastName.isNotEmpty ? lastName[0] : '',
    ].join().toUpperCase();

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, Color(0xFF294CA8)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.18),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initials.isEmpty ? '?' : initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back 👋',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  fullName.isEmpty ? 'Student' : fullName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    _ProfileBadge(
                      icon: Icons.school_rounded,
                      text: user.level.toString().split('.').last.toUpperCase(),
                    ),

                    const SizedBox(width: 8),

                    const _ProfileBadge(
                      icon: Icons.person_rounded,
                      text: 'Student',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ProfileBadge({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.85)),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningStats extends StatelessWidget {
  final List<EnrolledCourse> courses;

  const _LearningStats({required this.courses});

  @override
  Widget build(BuildContext context) {
    final totalLessons = courses.fold<int>(
      0,
      (sum, course) => sum + course.totalLessons,
    );

    final averageProgress = courses.isEmpty
        ? 0.0
        : courses.fold<double>(0, (sum, course) => sum + course.progress) /
              courses.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 650;

        final children = [
          _StatCard(
            icon: Icons.menu_book_rounded,
            value: '${courses.length}',
            label: 'Enrolled courses',
          ),
          _StatCard(
            icon: Icons.play_lesson_rounded,
            value: '$totalLessons',
            label: 'Total lessons',
          ),
          _StatCard(
            icon: Icons.trending_up_rounded,
            value: '${averageProgress.round()}%',
            label: 'Average progress',
          ),
        ];

        if (isSmall) {
          return Column(
            children: children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: child,
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: children
              .map(
                (child) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: child,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _LearningHeader extends StatelessWidget {
  const _LearningHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Learning',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                'Courses you are currently learning.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

class _EnrolledCourseCard extends StatelessWidget {
  final EnrolledCourse enrollment;

  const _EnrolledCourseCard({required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final course = enrollment.course;

    final progress = enrollment.progress.clamp(0.0, 1.0);

    final progressPercent = (progress * 100).round();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // Navigate to course.
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.translate_rounded,
                      color: Colors.white,
                      size: 26,
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

                  const SizedBox(width: 12),

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
                        fontSize: 11,
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
                    'Progress',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '$progressPercent%',
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

              const SizedBox(height: 12),

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
                    icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                    label: Text(progress == 0 ? 'Start learning' : 'Continue'),
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

class _EmptyCourses extends StatelessWidget {
  const _EmptyCourses();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.school_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'No courses yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 8),

            Text(
              'Start your Dutch learning journey by enrolling '
              'in a course.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.subtitleColor(context),
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.icon(
              onPressed: () {
                // Navigate to courses.
              },
              icon: const Icon(Icons.explore_rounded),
              label: const Text('Explore courses'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileError extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const _ProfileError({required this.error, required this.onRetry});

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
              'Unable to load your profile',
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
