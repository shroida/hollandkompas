import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/theme/app_colors.dart';
import 'package:hollandkompas/features/courses/domain/entities/course.dart';
import 'package:hollandkompas/features/courses/presentation/widgets/enrollment_dialog.dart';
import 'package:hollandkompas/features/enrollment/presentation/providers/enrolled_courses_provider.dart';
import 'package:hollandkompas/features/lesson/domain/entities/lesson.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/controllers/lesson_viewer_controller.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_completion_provider.dart';
import 'package:hollandkompas/features/lesson/presentation/providers/lesson_viewer_provider.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/continue_learning_card.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/free_lesson_card.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_description.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_header.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_information.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lessons_status_banner.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/locked_video.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/next_lesson_card.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/secure_video_player.dart';
import 'package:hollandkompas/features/vocabulary/presentation/screen/widgets/lesson_vocabulary_button.dart';
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

class _LessonViewerScreenState extends ConsumerState<LessonViewerScreen>
    with SingleTickerProviderStateMixin {
  bool _showNextLessonPanel = false;
  int _countdown = 3;

  Timer? _nextLessonTimer;

  final ScrollController _scrollController = ScrollController();

  late final AnimationController _countdownAnimationController;

  bool get isFirstLesson => widget.lesson.lessonOrder == 1;

  bool get isLocked => !widget.isEnrolled && !isFirstLesson;

  bool get hasNextLesson => widget.currentIndex + 1 < widget.lessons.length;

  Lesson? get nextLesson =>
      hasNextLesson ? widget.lessons[widget.currentIndex + 1] : null;

  LessonViewerState get viewerState =>
      ref.watch(lessonViewerControllerProvider);

  @override
  void initState() {
    super.initState();

    _countdownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLessonProgress());
  }

  Future<void> _loadLessonProgress() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      await ref
          .read(lessonViewerControllerProvider.notifier)
          .loadProgress(studentId: user.id, lessonId: widget.lesson.id);
    } catch (e) {
      _showErrorSnackBar('Failed to load lesson progress: $e');
    }
  }

  Future<void> _markLessonCompleted() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

    try {
      final completed = await ref
          .read(lessonViewerControllerProvider.notifier)
          .completeLesson(studentId: user.id, lessonId: widget.lesson.id);

      if (!completed || !mounted) return;

      ref.invalidate(enrolledCoursesProvider(user.id));

      ref.invalidate(lessonCompletionProvider(widget.lesson.id));

      if (nextLesson != null) {
        await _prepareNextLesson();
      } else {
        setState(() {
          _showNextLessonPanel = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      _showErrorSnackBar('Failed to save progress: $e');
    }
  }

  Future<void> _prepareNextLesson() async {
    setState(() {
      _showNextLessonPanel = true;
      _countdown = 3;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) return;

    await _scrollToNextLesson();

    if (!mounted) return;

    _startNextLessonCountdown();
  }

  Future<void> _scrollToNextLesson() async {
    if (!_scrollController.hasClients) return;

    await Future.delayed(const Duration(milliseconds: 100));

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;

    final target = (maxScroll - 20).clamp(0.0, maxScroll);

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _startNextLessonCountdown() {
    if (nextLesson == null) {
      setState(() {
        _showNextLessonPanel = true;
      });

      return;
    }

    _nextLessonTimer?.cancel();

    _countdownAnimationController
      ..stop()
      ..reset()
      ..forward();

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

  Future<void> _openNextLesson() async {
    final next = nextLesson;

    if (next == null) {
      _nextLessonTimer?.cancel();

      if (!mounted) return;

      setState(() {
        _showNextLessonPanel = false;
      });

      _showCourseCompletedSnackBar();
      return;
    }

    final controller = ref.read(lessonViewerControllerProvider.notifier);

    if (viewerState.isOpeningNextLesson) return;

    _nextLessonTimer?.cancel();

    controller.setOpeningNextLesson(true);

    setState(() {
      _showNextLessonPanel = false;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

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

            await context.push(RoutePaths.payment, extra: widget.course);
          },
        );
      },
    );
  }

  void _goBack() {
    _nextLessonTimer?.cancel();

    if (context.canPop()) {
      context.pop(viewerState.isLessonCompleted);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Text(message),
      ),
    );
  }

  void _showCourseCompletedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonViewerControllerProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBack();
        }
      },
      child: Scaffold(appBar: _buildAppBar(state), body: _buildBody(state)),
    );
  }

  PreferredSizeWidget _buildAppBar(LessonViewerState state) {
    return AppBar(
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
        if (hasNextLesson) _buildProgressBadge(),
        if (!widget.isEnrolled) _buildEnrollButton(),
      ],
    );
  }

  Widget _buildProgressBadge() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
    );
  }

  Widget _buildEnrollButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: IconButton(
        tooltip: 'Enroll',
        onPressed: _showEnrollmentDialog,
        icon: const Icon(Icons.school_rounded),
      ),
    );
  }

  Widget _buildBody(LessonViewerState state) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1000 ? 40.0 : 20.0;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  48,
                ),
                child: _buildContent(state),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(LessonViewerState state) {
    return Column(
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
        _buildVideo(),
        const SizedBox(height: 28),
        LessonHeader(
          lesson: widget.lesson,
          isEnrolled: widget.isEnrolled,
          isLocked: isLocked,
        ),
        const SizedBox(height: 24),
        LessonDescription(description: widget.lesson.description),
        const SizedBox(height: 28),
        LessonInformation(lesson: widget.lesson),
        const SizedBox(height: 28),
        _buildLearningSection(state),
      ],
    );
  }

  Widget _buildVideo() {
    if (isLocked) {
      return LockedVideo(onUnlock: _showEnrollmentDialog);
    }

    return SecureVideoPlayer(
      videoUrl: widget.lesson.videoUrl ?? '',
      onVideoCompleted: _markLessonCompleted,
    );
  }

  Widget _buildLearningSection(LessonViewerState state) {
    if (!widget.isEnrolled) {
      return FreeLessonCard(onEnroll: _showEnrollmentDialog);
    }

    return Column(
      children: [
        const ContinueLearningCard(),
        const SizedBox(height: 16),
        LessonVocabularyButton(lesson: widget.lesson),
        const SizedBox(height: 16),
        _buildCompletionButton(state),
        _buildNextLessonPanel(),
      ],
    );
  }

  Widget _buildCompletionButton(LessonViewerState state) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
      child: SizedBox(
        key: ValueKey(state.isLessonCompleted),
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: _canCompleteLesson(state) ? _markLessonCompleted : null,
          icon: _buildCompletionIcon(state),
          label: Text(_completionButtonText(state)),
        ),
      ),
    );
  }

  Widget _buildCompletionIcon(LessonViewerState state) {
    if (state.isSavingProgress) {
      return const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    return Icon(
      state.isLessonCompleted
          ? Icons.check_circle_rounded
          : Icons.check_circle_outline_rounded,
    );
  }

  bool _canCompleteLesson(LessonViewerState state) {
    return !state.isSavingProgress &&
        !state.isLessonCompleted &&
        !state.isOpeningNextLesson;
  }

  String _completionButtonText(LessonViewerState state) {
    if (state.isLessonCompleted) {
      return hasNextLesson ? 'Lesson completed' : 'Course completed';
    }

    return 'Mark lesson as completed';
  }

  Widget _buildNextLessonPanel() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
      child: _showNextLessonPanel
          ? Padding(
              key: const ValueKey('next_lesson'),
              padding: const EdgeInsets.only(top: 16),
              child: NextLessonCard(
                nextLesson: nextLesson,
                countdown: _countdown,
                hasNextLesson: hasNextLesson,
                animationController: _countdownAnimationController,
                onSkip: _openNextLesson,
                isOpening: viewerState.isOpeningNextLesson,
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty_next_lesson')),
    );
  }

  @override
  void dispose() {
    _nextLessonTimer?.cancel();
    _scrollController.dispose();
    _countdownAnimationController.dispose();
    super.dispose();
  }
}
