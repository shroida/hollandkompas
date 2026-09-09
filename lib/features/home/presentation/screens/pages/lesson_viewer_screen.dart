import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/home/domain/entities/lesson.dart';
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

  final List<Lesson> lessons;

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

class _LessonViewerScreenState extends ConsumerState<LessonViewerScreen> {
  bool _isSavingProgress = false;
  bool _isLessonCompleted = false;
  bool _isOpeningNextLesson = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLessonProgress();
    });
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
    } catch (e) {
      debugPrint('Failed to load lesson progress: $e');
    }
  }

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

      // Refresh My Courses progress.
      ref.invalidate(enrolledCoursesProvider(user.id));

      debugPrint('======================================');
      debugPrint('LESSON COMPLETED');
      debugPrint('Student ID: ${user.id}');
      debugPrint('Lesson ID: ${widget.lesson.id}');
      debugPrint('Lesson: ${widget.lesson.title}');
      debugPrint('Current Index: ${widget.currentIndex}');
      debugPrint('Next Lesson: ${nextLesson?.title}');
      debugPrint('======================================');

      // Automatically open next lesson.
      await _openNextLesson();
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSavingProgress = false;
      });

      debugPrint('Failed to save progress: $e');

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save progress: $e')));
    }
  }

  Future<void> _openNextLesson() async {
    final next = nextLesson;

    // No next lesson = course completed.
    if (next == null) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Congratulations! You completed the course 🎉'),
        ),
      );

      return;
    }

    if (_isOpeningNextLesson) {
      return;
    }

    setState(() {
      _isOpeningNextLesson = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) {
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        context.pop(_isLessonCompleted);
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.pop(_isLessonCompleted);
            },
          ),

          title: Text('Lesson ${widget.currentIndex + 1}'),

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
                        LessonStatusBanner(
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
                          SecureVideoPlayer(
                            videoUrl: widget.lesson.videoUrl ?? '',
                            onVideoCompleted: _markLessonCompleted,
                          ),

                        const SizedBox(height: 28),

                        LessonHeader(
                          lesson: widget.lesson,
                          isEnrolled: widget.isEnrolled,
                          isLocked: isLocked,
                        ),

                        const SizedBox(height: 24),

                        LessonDescription(
                          description: widget.lesson.description,
                        ),

                        const SizedBox(height: 28),

                        LessonInformation(lesson: widget.lesson),

                        const SizedBox(height: 28),

                        if (!widget.isEnrolled)
                          FreeLessonCard(onEnroll: _showEnrollmentDialog)
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const ContinueLearningCard(),

                              const SizedBox(height: 16),

                              SizedBox(
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
                                              ? Icons.check_circle
                                              : Icons.check_circle_outline,
                                        ),

                                  label: Text(
                                    _isLessonCompleted
                                        ? hasNextLesson
                                              ? 'Completed • Next lesson'
                                              : 'Course completed 🎉'
                                        : 'Mark lesson as completed',
                                  ),
                                ),
                              ),

                              if (_isLessonCompleted && hasNextLesson) ...[
                                const SizedBox(height: 12),

                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _isOpeningNextLesson
                                        ? null
                                        : _openNextLesson,
                                    icon: const Icon(
                                      Icons.arrow_forward_rounded,
                                    ),
                                    label: Text('Next: ${nextLesson!.title}'),
                                  ),
                                ),
                              ],
                            ],
                          ),
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
}
