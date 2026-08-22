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
