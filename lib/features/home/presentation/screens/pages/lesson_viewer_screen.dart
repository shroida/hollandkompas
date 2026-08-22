import 'package:flutter/material.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LessonViewerScreen extends StatefulWidget {
  final Lesson lesson;

  final bool isEnrolled;

  final int totalLessons;

  const LessonViewerScreen({
    super.key,
    required this.lesson,
    required this.isEnrolled,
    this.totalLessons = 1,
  });

  @override
  State<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends State<LessonViewerScreen> {
  late final YoutubePlayerController _controller;

  bool get isFirstLesson => widget.lesson.lessonOrder == 1;

  bool get isLocked => !widget.isEnrolled && !isFirstLesson;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayerController.convertUrlToId(
      widget.lesson.videoUrl ?? '',
    );

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        playsInline: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _showEnrollmentDialog() {
    showDialog<void>(
      context: context,
      builder: (context) {
        return _EnrollmentDialog(
          onEnroll: () {
            Navigator.of(context).pop();

            // TODO: Call your enrollment action here.
            //
            // Example:
            // ref.read(enrollmentControllerProvider.notifier)
            //     .enroll(widget.lesson.courseId);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Lesson'),
        actions: [
          if (!widget.isEnrolled)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                tooltip: 'Enroll',
                onPressed: _showEnrollmentDialog,
                icon: const Icon(Icons.school_rounded),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 1000;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    isDesktop ? 40 : 20,
                    24,
                    isDesktop ? 40 : 20,
                    48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LessonStatusBanner(
                        lessonOrder: widget.lesson.lessonOrder,
                        totalLessons: widget.totalLessons,
                        isEnrolled: widget.isEnrolled,
                        isLocked: isLocked,
                        onEnroll: _showEnrollmentDialog,
                      ),

                      const SizedBox(height: 20),

                      if (isLocked)
                        LockedVideo(onUnlock: _showEnrollmentDialog)
                      else
                        VideoPlayer(controller: _controller),

                      const SizedBox(height: 28),

                      _LessonHeader(
                        lesson: widget.lesson,
                        isEnrolled: widget.isEnrolled,
                        isLocked: isLocked,
                      ),

                      const SizedBox(height: 24),

                      LessonDescription(description: widget.lesson.description),

                      const SizedBox(height: 28),

                      _LessonInformation(lesson: widget.lesson),

                      const SizedBox(height: 28),

                      if (!widget.isEnrolled)
                        _FreeLessonCard(onEnroll: _showEnrollmentDialog)
                      else
                        const _ContinueLearningCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LessonStatusBanner extends StatelessWidget {
  final int lessonOrder;
  final int totalLessons;
  final bool isEnrolled;
  final bool isLocked;
  final VoidCallback onEnroll;

  const _LessonStatusBanner({
    required this.lessonOrder,
    required this.totalLessons,
    required this.isEnrolled,
    required this.isLocked,
    required this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    if (isEnrolled) {
      return _StatusContainer(
        icon: Icons.check_circle_rounded,
        title: 'You are enrolled',
        subtitle: 'All lessons are available to you.',
        trailing: const Icon(Icons.verified_rounded, color: AppColors.primary),
      );
    }

    if (lessonOrder == 1) {
      return _StatusContainer(
        icon: Icons.play_circle_fill_rounded,
        title: 'Free preview',
        subtitle: 'Lesson 1 is available for free.',
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'FREE',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    }

    return _StatusContainer(
      icon: Icons.lock_rounded,
      title: 'Enrollment required',
      subtitle: 'Enroll to unlock this lesson and the rest of the course.',
      trailing: TextButton(onPressed: onEnroll, child: const Text('Enroll')),
    );
  }
}

class _StatusContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _StatusContainer({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          trailing,
        ],
      ),
    );
  }
}

class _LessonInformation extends StatelessWidget {
  final Lesson lesson;

  const _LessonInformation({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InfoTile(
            icon: Icons.play_lesson_rounded,
            value: 'Lesson ${lesson.lessonOrder}',
            label: 'Course lesson',
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _InfoTile(
            icon: Icons.schedule_rounded,
            value: '${lesson.durationMinutes} min',
            label: 'Duration',
          ),
        ),
      ],
    );
  }
}

class _ContinueLearningCard extends StatelessWidget {
  const _ContinueLearningCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep learning',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Continue your Dutch learning journey.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}

class _EnrollmentDialog extends StatelessWidget {
  final VoidCallback onEnroll;

  const _EnrollmentDialog({required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      title: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_open_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),

          const SizedBox(height: 18),

          const Text('Unlock this course', textAlign: TextAlign.center),
        ],
      ),
      content: const Text(
        'This lesson is available after enrollment. '
        'Enroll now to unlock all lessons and track your progress.',
        textAlign: TextAlign.center,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      actions: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onEnroll,
            icon: const Icon(Icons.school_rounded),
            label: const Text('Enroll now'),
          ),
        ),

        const SizedBox(height: 6),

        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Maybe later'),
          ),
        ),
      ],
    );
  }
}

class _FreeLessonCard extends StatelessWidget {
  final VoidCallback onEnroll;

  const _FreeLessonCard({required this.onEnroll});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.school_rounded, color: Colors.white, size: 30),

          const SizedBox(height: 14),

          const Text(
            'Enjoying the lesson?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Enroll in this course to unlock all lessons, '
            'track your progress, and continue learning.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onEnroll,
              icon: const Icon(Icons.school_rounded),
              label: const Text('Enroll in this course'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.muted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonHeader extends StatelessWidget {
  final Lesson lesson;
  final bool isEnrolled;
  final bool isLocked;

  const _LessonHeader({
    required this.lesson,
    required this.isEnrolled,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.14),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(17),
          ),
          child: Icon(
            isLocked ? Icons.lock_rounded : Icons.play_lesson_rounded,
            color: AppColors.primary,
            size: 27,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'LESSON ${lesson.lessonOrder}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),

                  const SizedBox(width: 10),

                  if (!isEnrolled && lesson.lessonOrder == 1)
                    _SmallBadge(text: 'FREE'),

                  if (isLocked) const _SmallBadge(text: 'LOCKED'),
                ],
              ),

              const SizedBox(height: 7),

              Text(
                lesson.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 9),

              Row(
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppColors.subtitleColor(context),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    '${lesson.durationMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;

  const _SmallBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
