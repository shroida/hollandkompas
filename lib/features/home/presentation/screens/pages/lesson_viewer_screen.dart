import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
import 'package:hollandkompas/features/home/presentation/providers/lesson_progress_provider.dart';
import 'package:hollandkompas/features/home/presentation/screens/pages/secure_video_player.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/continue_learning_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/free_lesson_card.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/lesson_description.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/lesson_header.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/lesson_information.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/lessons_status_banner.dart';
import 'package:hollandkompas/features/home/presentation/widgets/lessons%20viewers/locked_video.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LessonViewerScreen extends ConsumerStatefulWidget {
  final Lesson lesson;
  final Course course;
  final bool isEnrolled;

  /// All lessons in the current course.
  final List<Lesson> lessons;

  /// Current lesson index in [lessons].
  final int currentIndex;

  final int totalLessons;

  const LessonViewerScreen({
    super.key,
    required this.course,
    required this.lesson,
    required this.isEnrolled,
    required this.lessons,
    required this.currentIndex,
    this.totalLessons = 1,
  });

  @override
  ConsumerState<LessonViewerScreen> createState() => _LessonViewerScreenState();
}

class _LessonViewerScreenState extends ConsumerState<LessonViewerScreen>
    with SingleTickerProviderStateMixin {
  bool _isSavingProgress = false;
  bool _isLessonCompleted = false;

  bool _showNextLessonPanel = false;
  bool _isOpeningNextLesson = false;

  Timer? _nextLessonTimer;

  int _countdown = 3;

  final ScrollController _scrollController = ScrollController();

  AnimationController? _countdownAnimationController;

  bool get isFirstLesson => widget.lesson.lessonOrder == 1;

  bool get isLocked => !widget.isEnrolled && !isFirstLesson;

  bool get hasNextLesson => widget.currentIndex + 1 < widget.lessons.length;

  Lesson? get nextLesson {
    if (!hasNextLesson) {
      return null;
    }

    return widget.lessons[widget.currentIndex + 1];
  }

  @override
  void initState() {
    super.initState();

    _countdownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLessonProgress();
    });
  }

  Future<void> _scrollToNextLesson() async {
    if (!_scrollController.hasClients) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (!_scrollController.hasClients) {
      return;
    }

    final target = (_scrollController.position.maxScrollExtent - 20).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _loadLessonProgress() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('lesson_progress')
          .select('completed')
          .eq('student_id', user.id)
          .eq('lesson_id', widget.lesson.id)
          .maybeSingle();

      if (!mounted) {
        return;
      }

      setState(() {
        _isLessonCompleted = response?['completed'] == true;
      });

      debugPrint(
        'Lesson progress loaded: '
        '${widget.lesson.id} = $_isLessonCompleted',
      );
    } catch (e) {
      debugPrint('Failed to load lesson progress: $e');
    }
  }

  // ============================================================
  // MARK LESSON COMPLETED
  // ============================================================
  Future<void> _markLessonCompleted() async {
    if (_isSavingProgress || _isLessonCompleted || _isOpeningNextLesson) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      debugPrint('Cannot save progress: user is not authenticated.');
      return;
    }

    setState(() {
      _isSavingProgress = true;
    });

    try {
      await Supabase.instance.client.from('lesson_progress').upsert({
        'student_id': user.id,
        'lesson_id': widget.lesson.id,
        'completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }, onConflict: 'student_id,lesson_id');

      if (!mounted) {
        return;
      }

      setState(() {
        _isLessonCompleted = true;
        _isSavingProgress = false;
      });

      // Refresh My Courses.
      ref.invalidate(enrolledCoursesProvider(user.id));

      // Refresh current lesson completion.
      ref.invalidate(lessonCompletionProvider(widget.lesson.id));

      if (nextLesson != null) {
        setState(() {
          _showNextLessonPanel = true;
          _countdown = 3;
        });

        // Give Flutter one frame to render the panel.
        await Future.delayed(const Duration(milliseconds: 80));

        if (!mounted) {
          return;
        }

        await _scrollToNextLesson();

        if (!mounted) {
          return;
        }

        _startNextLessonCountdown();
      } else {
        // Last lesson.
        setState(() {
          _showNextLessonPanel = true;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSavingProgress = false;
      });

      debugPrint('Failed to save progress: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Text('Failed to save progress: $e'),
        ),
      );
    }
  }
  // ============================================================
  // START COUNTDOWN
  // ============================================================

  void _startNextLessonCountdown() {
    final next = nextLesson;

    // Last lesson.
    if (next == null) {
      if (!mounted) {
        return;
      }

      setState(() {
        _showNextLessonPanel = true;
      });

      return;
    }

    _nextLessonTimer?.cancel();

    _countdownAnimationController?.stop();
    _countdownAnimationController?.reset();
    _countdownAnimationController?.forward();

    setState(() {
      _showNextLessonPanel = true;
      _countdown = 3;
    });

    _nextLessonTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdown <= 1) {
        timer.cancel();

        _openNextLesson();

        return;
      }

      setState(() {
        _countdown--;
      });
    });
  }

  // ============================================================
  // OPEN NEXT LESSON
  // ============================================================

  Future<void> _openNextLesson() async {
    final next = nextLesson;

    if (next == null) {
      if (!mounted) {
        return;
      }

      _nextLessonTimer?.cancel();

      setState(() {
        _showNextLessonPanel = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: const Row(
            children: [
              Icon(Icons.celebration_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Congratulations! You completed the course 🎉'),
              ),
            ],
          ),
        ),
      );

      return;
    }

    if (_isOpeningNextLesson) {
      return;
    }

    _nextLessonTimer?.cancel();

    setState(() {
      _isOpeningNextLesson = true;
      _showNextLessonPanel = false;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) {
      return;
    }

    debugPrint('Opening next lesson: ${next.title}');

    context.pushReplacement(
      '/lesson-viewer',
      extra: {
        'course': widget.course,
        'lesson': next,
        'lessons': widget.lessons,
        'currentIndex': widget.currentIndex + 1,
        'isEnrolled': widget.isEnrolled,
        'totalLessons': widget.lessons.length,
      },
    );
  }

  // ============================================================
  // ENROLLMENT DIALOG
  // ============================================================

  void _showEnrollmentDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return EnrollmentDialog(
          course: widget.course,
          onEnroll: () async {
            Navigator.of(dialogContext).pop();

            await context.push('/payment', extra: {'course': widget.course});
          },
        );
      },
    );
  }

  // ============================================================
  // BACK
  // ============================================================

  void _goBack() {
    _nextLessonTimer?.cancel();

    if (context.canPop()) {
      context.pop(_isLessonCompleted);
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _goBack();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _goBack,
          ),

          title: Text(
            'Lesson ${widget.currentIndex + 1}',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),

          centerTitle: false,

          actions: [
            if (hasNextLesson)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.currentIndex + 1} / ${widget.lessons.length}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

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
                    controller: _scrollController,

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
                        // ====================================================
                        // LESSON STATUS
                        // ====================================================
                        LessonStatusBanner(
                          lessonOrder: widget.lesson.lessonOrder,

                          totalLessons: widget.totalLessons,

                          isEnrolled: widget.isEnrolled,

                          isLocked: isLocked,

                          onEnroll: _showEnrollmentDialog,
                        ),

                        const SizedBox(height: 20),

                        // ====================================================
                        // VIDEO
                        // ====================================================
                        if (isLocked)
                          LockedVideo(onUnlock: _showEnrollmentDialog)
                        else
                          SecureVideoPlayer(
                            videoUrl: widget.lesson.videoUrl ?? '',

                            onVideoCompleted: _markLessonCompleted,
                          ),

                        const SizedBox(height: 28),

                        // ====================================================
                        // LESSON HEADER
                        // ====================================================
                        LessonHeader(
                          lesson: widget.lesson,

                          isEnrolled: widget.isEnrolled,

                          isLocked: isLocked,
                        ),

                        const SizedBox(height: 24),

                        // ====================================================
                        // DESCRIPTION
                        // ====================================================
                        LessonDescription(
                          description: widget.lesson.description,
                        ),

                        const SizedBox(height: 28),

                        // ====================================================
                        // INFORMATION
                        // ====================================================
                        LessonInformation(lesson: widget.lesson),

                        const SizedBox(height: 28),

                        // ====================================================
                        // BOTTOM CONTENT
                        // ====================================================
                        if (!widget.isEnrolled)
                          FreeLessonCard(onEnroll: _showEnrollmentDialog)
                        else ...[
                          const ContinueLearningCard(),

                          const SizedBox(height: 16),

                          // ==================================================
                          // COMPLETION BUTTON
                          // ==================================================
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),

                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,

                                child: SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                ),
                              );
                            },

                            child: SizedBox(
                              key: ValueKey(_isLessonCompleted),

                              width: double.infinity,

                              child: FilledButton.icon(
                                onPressed:
                                    (_isSavingProgress ||
                                        _isLessonCompleted ||
                                        _isOpeningNextLesson)
                                    ? null
                                    : _markLessonCompleted,

                                icon: _isSavingProgress
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(
                                        _isLessonCompleted
                                            ? Icons.check_circle_rounded
                                            : Icons
                                                  .check_circle_outline_rounded,
                                      ),

                                label: Text(
                                  _isLessonCompleted
                                      ? hasNextLesson
                                            ? 'Lesson completed'
                                            : 'Course completed'
                                      : 'Mark lesson as completed',
                                ),
                              ),
                            ),
                          ),

                          // ==================================================
                          // NEXT LESSON PANEL
                          // ==================================================
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),

                            switchInCurve: Curves.easeOutCubic,

                            switchOutCurve: Curves.easeInCubic,

                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,

                                child: SizeTransition(
                                  sizeFactor: animation,
                                  child: child,
                                ),
                              );
                            },

                            child: _showNextLessonPanel
                                ? Padding(
                                    key: const ValueKey('next_lesson'),

                                    padding: const EdgeInsets.only(top: 16),

                                    child: _NextLessonCard(
                                      nextLesson: nextLesson,

                                      countdown: _countdown,

                                      hasNextLesson: hasNextLesson,

                                      animationController:
                                          _countdownAnimationController,

                                      onSkip: _openNextLesson,

                                      isOpening: _isOpeningNextLesson,
                                    ),
                                  )
                                : const SizedBox.shrink(
                                    key: ValueKey('empty_next_lesson'),
                                  ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nextLessonTimer?.cancel();
    _scrollController.dispose();

    _countdownAnimationController?.dispose();

    super.dispose();
  }
}

// ============================================================
// NEXT LESSON CARD
// ============================================================

class _NextLessonCard extends StatelessWidget {
  final Lesson? nextLesson;
  final int countdown;
  final bool hasNextLesson;
  final AnimationController? animationController;
  final VoidCallback onSkip;
  final bool isOpening;

  const _NextLessonCard({
    required this.nextLesson,
    required this.countdown,
    required this.hasNextLesson,
    required this.animationController,
    required this.onSkip,
    required this.isOpening,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ==========================================================
    // COURSE COMPLETED
    // ==========================================================

    if (!hasNextLesson || nextLesson == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.secondary.withValues(alpha: 0.95),
              AppColors.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.16),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course completed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Amazing work. You finished all lessons 🎉',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ==========================================================
    // NEXT LESSON
    // ==========================================================

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondary, AppColors.primary],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Up next',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.subtitleColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      nextLesson!.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ========================================================
          // COUNTDOWN
          // ========================================================
          if (!isOpening) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Starting in $countdown seconds',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.subtitleColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                TextButton(onPressed: onSkip, child: const Text('Skip')),
              ],
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: (3 - countdown) / 3,
                backgroundColor: AppColors.muted,
                color: AppColors.primary,
              ),
            ),
          ] else ...[
            const Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 10),
                Text(
                  'Opening next lesson...',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
