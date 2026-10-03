import 'dart:async';

import 'package:flutter/foundation.dart';
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
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/free_lesson_card.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_description.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_header.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lesson_information.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/lessons_status_banner.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/lessons%20viewers/locked_video.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/mobile_secure_video_player.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/next_lesson_card.dart';
import 'package:hollandkompas/features/lesson/presentation/widgets/web_secure_video_player.dart';
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

  bool _isCompletingLesson = false;
  bool _isOpeningNextLesson = false;

  Timer? _nextLessonTimer;

  final ScrollController _scrollController = ScrollController();

  late final AnimationController _countdownAnimationController;

  bool get isFirstLesson => widget.lesson.lessonOrder == 1;

  bool get isLocked => !widget.isEnrolled && !isFirstLesson;

  bool get hasNextLesson => widget.currentIndex + 1 < widget.lessons.length;

  Lesson? get nextLesson =>
      hasNextLesson ? widget.lessons[widget.currentIndex + 1] : null;

  @override
  void initState() {
    super.initState();

    _countdownAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.invalidate(lessonViewerControllerProvider);
      _loadLessonProgress();
    });
  }

  @override
  void didUpdateWidget(covariant LessonViewerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.lesson.id == widget.lesson.id) {
      return;
    }

    _resetForNewLesson();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.invalidate(lessonViewerControllerProvider);
      _loadLessonProgress();
    });
  }

  void _resetForNewLesson() {
    _nextLessonTimer?.cancel();
    _nextLessonTimer = null;

    _countdownAnimationController
      ..stop()
      ..reset();

    _showNextLessonPanel = false;
    _countdown = 3;

    _isCompletingLesson = false;
    _isOpeningNextLesson = false;

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadLessonProgress() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null || !mounted) {
      return;
    }

    try {
      await ref
          .read(lessonViewerControllerProvider.notifier)
          .loadProgress(studentId: user.id, lessonId: widget.lesson.id);
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showErrorSnackBar('Failed to load lesson progress: $e');
    }
  }

  Future<void> _markLessonCompleted() async {
    if (_isCompletingLesson || _isOpeningNextLesson) {
      return;
    }

    final currentState = ref.read(lessonViewerControllerProvider);

    if (currentState.isSavingProgress || currentState.isLessonCompleted) {
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return;
    }

    _isCompletingLesson = true;

    if (mounted) {
      setState(() {});
    }

    try {
      final completed = await ref
          .read(lessonViewerControllerProvider.notifier)
          .completeLesson(studentId: user.id, lessonId: widget.lesson.id);

      if (!completed || !mounted) {
        return;
      }

      ref.invalidate(enrolledCoursesProvider(user.id));

      ref.invalidate(lessonCompletionProvider(widget.lesson.id));

      if (nextLesson != null) {
        await _prepareNextLesson();
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          _showNextLessonPanel = true;
          _countdown = 0;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      _showErrorSnackBar('Failed to save progress: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCompletingLesson = false;
        });
      }
    }
  }

  Future<void> _prepareNextLesson() async {
    if (!mounted || _isOpeningNextLesson) {
      return;
    }

    setState(() {
      _showNextLessonPanel = true;
      _countdown = 3;
    });

    await Future.delayed(const Duration(milliseconds: 80));

    if (!mounted) {
      return;
    }

    await _scrollToNextLesson();

    if (!mounted) {
      return;
    }

    _startNextLessonCountdown();
  }

  Future<void> _scrollToNextLesson() async {
    if (!_scrollController.hasClients) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted || !_scrollController.hasClients) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;

    final target = (maxScroll - 20).clamp(0.0, maxScroll);

    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
    );
  }

  void _startNextLessonCountdown() {
    if (!mounted) {
      return;
    }

    if (nextLesson == null) {
      setState(() {
        _showNextLessonPanel = true;
        _countdown = 0;
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
        _nextLessonTimer = null;

        unawaited(_openNextLesson());

        return;
      }

      setState(() {
        _countdown--;
      });
    });
  }

  Future<void> _openNextLesson() async {
    if (_isOpeningNextLesson) {
      return;
    }

    final next = nextLesson;

    if (next == null) {
      _nextLessonTimer?.cancel();
      _nextLessonTimer = null;

      if (!mounted) {
        return;
      }

      setState(() {
        _showNextLessonPanel = false;
      });

      _showCourseCompletedSnackBar();

      return;
    }

    _isOpeningNextLesson = true;

    _nextLessonTimer?.cancel();
    _nextLessonTimer = null;

    _countdownAnimationController.stop();

    if (mounted) {
      setState(() {
        _showNextLessonPanel = false;
      });
    }

    await Future.delayed(const Duration(milliseconds: 150));

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

            await context.push(RoutePaths.payment, extra: widget.course);
          },
        );
      },
    );
  }

  void _goBack() {
    _nextLessonTimer?.cancel();
    _nextLessonTimer = null;

    _countdownAnimationController.stop();

    if (_isOpeningNextLesson) {
      return;
    }

    if (context.canPop()) {
      final state = ref.read(lessonViewerControllerProvider);

      context.pop(state.isLessonCompleted);
    }
  }

  void _goHome() {
    if (_isOpeningNextLesson) {
      return;
    }

    _nextLessonTimer?.cancel();
    _nextLessonTimer = null;

    _countdownAnimationController.stop();

    context.go(RoutePaths.home);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) {
      return;
    }

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
    if (!mounted) {
      return;
    }

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
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(state),
        body: _buildBody(state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(LessonViewerState state) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 68,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildHomeButton(),
            const SizedBox(width: 10),
            _buildBackButton(),
            const SizedBox(width: 14),
            Expanded(child: _buildLessonHeaderTitle()),
            const SizedBox(width: 10),
            if (hasNextLesson) _buildProgressBadge(),
            if (!widget.isEnrolled) _buildEnrollButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton() {
    return Tooltip(
      message: 'Home',
      child: Material(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _goHome,
          child: const SizedBox(
            width: 44,
            height: 44,
            child: Icon(Icons.home_rounded, color: AppColors.primary, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    final theme = Theme.of(context);

    return Tooltip(
      message: 'Back',
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isOpeningNextLesson ? null : _goBack,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.arrow_back_rounded,
              color: theme.iconTheme.color,
              size: 21,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonHeaderTitle() {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.course.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.lesson.title.trim().isNotEmpty
              ? widget.lesson.title
              : 'Lesson ${widget.currentIndex + 1}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.60),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
    );
  }

  Widget _buildEnrollButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
        message: 'Enroll',
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: _showEnrollmentDialog,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: Icon(Icons.school_rounded, color: Colors.white, size: 21),
            ),
          ),
        ),
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
        _buildVideoSection(),
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

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildVideo(), const SizedBox(height: 10), _buildVideoHint()],
    );
  }

  Widget _buildVideo() {
    if (isLocked) {
      return LockedVideo(onUnlock: _showEnrollmentDialog);
    }

    final videoUrl = widget.lesson.videoUrl?.trim() ?? '';

    if (videoUrl.isEmpty) {
      return _buildMissingVideo();
    }

    return kIsWeb
        ? WebSecureVideoPlayer(
            key: ValueKey('web-video-${widget.lesson.id}'),
            videoUrl: videoUrl,
            onVideoCompleted: _markLessonCompleted,
          )
        : MobileSecureVideoPlayer(
            key: ValueKey('mobile-video-${widget.lesson.id}'),
            videoUrl: videoUrl,
            onVideoCompleted: _markLessonCompleted,
          );
  }

  Widget _buildMissingVideo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        height: 360,
        color: Colors.black,
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.video_library_outlined, color: Colors.white38, size: 32),
            SizedBox(height: 14),
            Text(
              'Video unavailable',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoHint() {
    if (isLocked) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(
          Icons.touch_app_rounded,
          size: 15,
          color: Theme.of(
            context,
          ).textTheme.bodySmall?.color?.withValues(alpha: 0.55),
        ),
        const SizedBox(width: 6),
        Text(
          'Double tap left/right to skip 10 seconds',
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }

  Widget _buildLearningSection(LessonViewerState state) {
    if (!widget.isEnrolled) {
      return FreeLessonCard(onEnroll: _showEnrollmentDialog);
    }

    return Column(
      children: [
        LessonVocabularyButton(lesson: widget.lesson),
        const SizedBox(height: 16),
        _buildCompletionButton(state),
        _buildNextLessonPanel(),
      ],
    );
  }

  Widget _buildCompletionButton(LessonViewerState state) {
    final disabled =
        _isCompletingLesson ||
        _isOpeningNextLesson ||
        !_canCompleteLesson(state);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
      child: SizedBox(
        key: ValueKey(
          '${widget.lesson.id}-'
          '${state.isLessonCompleted}-'
          '$_isCompletingLesson-'
          '$_isOpeningNextLesson',
        ),
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: disabled ? null : _markLessonCompleted,
          icon: _buildCompletionIcon(state),
          label: Text(_completionButtonText(state)),
        ),
      ),
    );
  }

  Widget _buildCompletionIcon(LessonViewerState state) {
    if (_isCompletingLesson || state.isSavingProgress) {
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
        !_isOpeningNextLesson;
  }

  String _completionButtonText(LessonViewerState state) {
    if (state.isLessonCompleted) {
      return hasNextLesson ? 'Lesson completed' : 'Course completed';
    }

    if (_isCompletingLesson || state.isSavingProgress) {
      return 'Saving progress...';
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
                isOpening: _isOpeningNextLesson,
              ),
            )
          : const SizedBox(key: ValueKey('empty_next_lesson')),
    );
  }

  @override
  void dispose() {
    _nextLessonTimer?.cancel();
    _nextLessonTimer = null;

    _countdownAnimationController.dispose();

    _scrollController.dispose();

    super.dispose();
  }
}
