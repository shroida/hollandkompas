import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MobileSecureVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  const MobileSecureVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
  });

  @override
  State<MobileSecureVideoPlayer> createState() =>
      _MobileSecureVideoPlayerState();
}

class _MobileSecureVideoPlayerState extends State<MobileSecureVideoPlayer> {
  VideoPlayerController? _controller;

  Timer? _controlsTimer;
  Timer? _feedbackTimer;

  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);
  final ValueNotifier<bool> _isDraggingNotifier = ValueNotifier(false);
  final ValueNotifier<double> _sliderNotifier = ValueNotifier(0);
  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _seekFeedbackNotifier = ValueNotifier<String?>(
    null,
  );
  final ValueNotifier<double> _playbackRateNotifier = ValueNotifier(1.0);

  String? _videoId;

  bool _isInitializing = false;
  bool _completionSent = false;
  bool _disposed = false;

  int _loadRequestId = 0;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    unawaited(_loadVideo(widget.videoUrl));
  }

  @override
  void didUpdateWidget(covariant MobileSecureVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldUrl = oldWidget.videoUrl.trim();
    final newUrl = widget.videoUrl.trim();

    if (oldUrl == newUrl) {
      return;
    }

    unawaited(_reloadVideo(newUrl));
  }

  Future<void> _reloadVideo(String url) async {
    final requestId = ++_loadRequestId;

    _cancelControlsTimer();
    _cancelFeedbackTimer();

    _completionSent = false;
    _position = Duration.zero;
    _duration = Duration.zero;
    _videoId = null;

    _sliderNotifier.value = 0;
    _showControlsNotifier.value = true;
    _isDraggingNotifier.value = false;
    _playbackRateNotifier.value = 1.0;
    _errorNotifier.value = null;
    _seekFeedbackNotifier.value = null;

    final oldController = _controller;
    _controller = null;
    _isInitializing = false;

    if (oldController != null) {
      oldController.removeListener(_handleControllerChanged);

      try {
        await oldController.dispose();
      } catch (_) {}
    }

    if (!mounted || _disposed || requestId != _loadRequestId) {
      return;
    }

    setState(() {});

    await _loadVideo(url);
  }

  Future<void> _loadVideo(String url) async {
    if (_disposed || _isInitializing) {
      return;
    }

    final requestId = _loadRequestId;

    _isInitializing = true;
    _errorNotifier.value = null;

    final videoId = _extractVideoId(url);

    if (videoId == null) {
      _isInitializing = false;
      _videoId = null;
      _handleInitializationError('Invalid YouTube video URL.');
      return;
    }

    _videoId = videoId;

    if (mounted && !_disposed && requestId == _loadRequestId) {
      setState(() {});
    }

    YoutubeExplode? yt;
    VideoPlayerController? controller;

    try {
      yt = YoutubeExplode();

      final manifest = await _getManifestWithFallbacks(yt, videoId);

      if (_disposed || requestId != _loadRequestId) {
        return;
      }

      final selectedStream = _selectMuxedMp4Stream(manifest);

      if (selectedStream == null) {
        throw StateError(
          'No playable MP4 muxed stream was found for this video.',
        );
      }

      controller = VideoPlayerController.networkUrl(
        selectedStream.url,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: false,
          allowBackgroundPlayback: false,
        ),
      );

      if (_disposed || requestId != _loadRequestId) {
        await controller.dispose();
        controller = null;
        return;
      }

      _controller = controller;
      controller.addListener(_handleControllerChanged);

      await controller.initialize();

      if (_disposed ||
          requestId != _loadRequestId ||
          controller != _controller) {
        controller.removeListener(_handleControllerChanged);

        try {
          await controller.dispose();
        } catch (_) {}

        return;
      }

      _duration = controller.value.duration;
      _position = controller.value.position;

      _updateSliderFromPosition();

      _isInitializing = false;

      if (mounted && !_disposed && requestId == _loadRequestId) {
        setState(() {});
      }
    } on VideoRequiresPurchaseException {
      if (_isCurrentRequest(requestId)) {
        _handleInitializationError(
          'This video requires a purchase and cannot be played.',
        );
      }
    } on VideoUnavailableException {
      if (_isCurrentRequest(requestId)) {
        _handleInitializationError(
          'This YouTube video is unavailable, private, deleted, or cannot be played.',
        );
      }
    } on VideoUnplayableException {
      if (_isCurrentRequest(requestId)) {
        _handleInitializationError(
          'This YouTube video cannot be played directly.',
        );
      }
    } catch (error) {
      if (!_isCurrentRequest(requestId)) {
        return;
      }

      debugPrint(
        'MobileSecureVideoPlayer: failed to load YouTube video '
        '$_videoId: $error',
      );

      _handleInitializationError('Unable to load the video stream.');
    } finally {
      _isInitializing = false;
      yt?.close();

      if (controller != null &&
          _disposed &&
          identical(controller, _controller)) {
        _controller = null;
      }
    }
  }

  bool _isCurrentRequest(int requestId) {
    return !_disposed && requestId == _loadRequestId;
  }

  Future<StreamManifest> _getManifestWithFallbacks(
    YoutubeExplode yt,
    String videoId,
  ) async {
    Object? lastError;

    final clients = <YoutubeApiClient>[
      YoutubeApiClient.ios,
      YoutubeApiClient.androidVr,
      YoutubeApiClient.safari,
      YoutubeApiClient.tv,
    ];

    for (final client in clients) {
      try {
        debugPrint(
          'MobileSecureVideoPlayer: requesting manifest with client: $client',
        );

        final manifest = await yt.videos.streams.getManifest(
          VideoId(videoId),
          ytClients: <YoutubeApiClient>[client],
          requireWatchPage: false,
        );

        if (manifest.muxed.isNotEmpty) {
          debugPrint(
            'MobileSecureVideoPlayer: manifest loaded with client: $client',
          );

          return manifest;
        }

        lastError = StateError(
          'Manifest returned no muxed streams for client $client.',
        );
      } catch (error) {
        lastError = error;

        debugPrint('MobileSecureVideoPlayer: client $client failed: $error');
      }
    }

    try {
      debugPrint(
        'MobileSecureVideoPlayer: trying default manifest extraction.',
      );

      final manifest = await yt.videos.streams.getManifest(
        VideoId(videoId),
        requireWatchPage: false,
      );

      if (manifest.muxed.isNotEmpty) {
        return manifest;
      }

      lastError = StateError('Default manifest returned no muxed streams.');
    } catch (error) {
      lastError = error;

      debugPrint(
        'MobileSecureVideoPlayer: default manifest extraction failed: $error',
      );
    }

    throw StateError(
      'Unable to extract a playable YouTube stream for '
      '$videoId. Last error: $lastError',
    );
  }

  MuxedStreamInfo? _selectMuxedMp4Stream(StreamManifest manifest) {
    final streams = manifest.muxed
        .where((stream) => stream.container == StreamContainer.mp4)
        .toList();

    if (streams.isEmpty) {
      return null;
    }

    streams.sort((a, b) {
      final heightComparison = b.videoResolution.height.compareTo(
        a.videoResolution.height,
      );

      if (heightComparison != 0) {
        return heightComparison;
      }

      return b.videoResolution.width.compareTo(a.videoResolution.width);
    });

    return streams.first;
  }

  void _handleInitializationError(String message) {
    _isInitializing = false;
    _controller = null;
    _errorNotifier.value = message;

    _cancelControlsTimer();

    if (mounted && !_disposed) {
      setState(() {});
    }
  }

  void _handleControllerChanged() {
    if (_disposed) {
      return;
    }

    final controller = _controller;

    if (controller == null) {
      return;
    }

    final value = controller.value;

    if (value.hasError) {
      _errorNotifier.value = value.errorDescription ?? 'Video playback error.';

      _cancelControlsTimer();
      _showControlsNotifier.value = true;

      if (mounted) {
        setState(() {});
      }

      return;
    }

    _duration = value.duration;
    _position = value.position;

    if (!_isDraggingNotifier.value) {
      _updateSliderFromPosition();
    }

    _checkCompletion(value);

    if (value.isPlaying) {
      _scheduleControlsHide();
    } else {
      _cancelControlsTimer();
      _showControlsNotifier.value = true;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _checkCompletion(VideoPlayerValue value) {
    if (_completionSent) {
      return;
    }

    final duration = value.duration;
    final position = value.position;

    if (duration <= Duration.zero) {
      return;
    }

    final remaining = duration - position;

    if (value.isCompleted || remaining <= const Duration(milliseconds: 500)) {
      _emitCompletion();
    }
  }

  void _emitCompletion() {
    if (_completionSent) {
      return;
    }

    _completionSent = true;

    final callback = widget.onVideoCompleted;

    if (callback == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed) {
        return;
      }

      callback();
    });
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    _showControlsNow();

    try {
      final value = controller.value;

      if (value.isPlaying) {
        await controller.pause();
        return;
      }

      final isAtEnd =
          value.isCompleted ||
          (_duration > Duration.zero &&
              _position >= _duration - const Duration(milliseconds: 500));

      if (isAtEnd) {
        _completionSent = false;

        await controller.seekTo(Duration.zero);

        _position = Duration.zero;
        _sliderNotifier.value = 0;
      }

      await controller.play();
    } catch (error) {
      debugPrint('MobileSecureVideoPlayer: play/pause failed: $error');
    }
  }

  Future<void> _seekRelative(double seconds) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    _showControlsNow();

    try {
      final current = controller.value.position;
      final duration = controller.value.duration;

      var target = current + Duration(milliseconds: (seconds * 1000).round());

      if (target < Duration.zero) {
        target = Duration.zero;
      }

      if (duration > Duration.zero && target > duration) {
        target = duration;
      }

      if (target < current) {
        _completionSent = false;
      }

      await controller.seekTo(target);

      _position = target;
      _duration = duration;

      _updateSliderFromPosition();

      _showSeekFeedback(seconds < 0 ? '-10' : '+10');
    } catch (error) {
      debugPrint('MobileSecureVideoPlayer: seek failed: $error');
    }
  }

  Future<void> _seekToFraction(double fraction) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final duration = controller.value.duration;

    if (duration <= Duration.zero) {
      return;
    }

    final safeFraction = fraction.isFinite
        ? fraction.clamp(0.0, 1.0).toDouble()
        : 0.0;

    final milliseconds = (duration.inMilliseconds * safeFraction).round();

    final target = Duration(milliseconds: milliseconds);

    if (target < duration - const Duration(milliseconds: 500)) {
      _completionSent = false;
    }

    try {
      await controller.seekTo(target);

      _position = target;
      _duration = duration;

      _sliderNotifier.value = safeFraction;
    } catch (error) {
      debugPrint('MobileSecureVideoPlayer: slider seek failed: $error');
    }
  }

  Future<void> _changePlaybackRate(double rate) async {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    const allowedRates = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    if (!allowedRates.contains(rate)) {
      return;
    }

    _cancelControlsTimer();

    try {
      await controller.setPlaybackSpeed(rate);

      _playbackRateNotifier.value = rate;

      if (controller.value.isPlaying) {
        _scheduleControlsHide();
      }
    } catch (error) {
      debugPrint('MobileSecureVideoPlayer: playback speed failed: $error');

      _playbackRateNotifier.value = controller.value.playbackSpeed;
    }
  }

  void _updateSliderFromPosition() {
    if (_isDraggingNotifier.value) {
      return;
    }

    final duration = _duration;

    if (duration <= Duration.zero || duration.inMilliseconds <= 0) {
      _sliderNotifier.value = 0;
      return;
    }

    final positionMilliseconds = _position.inMilliseconds
        .clamp(0, duration.inMilliseconds)
        .toInt();

    final fraction = positionMilliseconds / duration.inMilliseconds;

    if (!fraction.isFinite) {
      _sliderNotifier.value = 0;
      return;
    }

    _sliderNotifier.value = fraction.clamp(0.0, 1.0).toDouble();
  }

  void _handleSliderStart(double value) {
    _cancelControlsTimer();

    _isDraggingNotifier.value = true;

    final safeValue = value.isFinite ? value.clamp(0.0, 1.0).toDouble() : 0.0;

    _sliderNotifier.value = safeValue;

    if (_duration > Duration.zero) {
      _position = Duration(
        milliseconds: (_duration.inMilliseconds * safeValue).round(),
      );
    }
  }

  void _handleSliderChanged(double value) {
    final safeValue = value.isFinite ? value.clamp(0.0, 1.0).toDouble() : 0.0;

    _sliderNotifier.value = safeValue;

    if (_duration > Duration.zero) {
      _position = Duration(
        milliseconds: (_duration.inMilliseconds * safeValue).round(),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleSliderEnd(double value) {
    final safeValue = value.isFinite ? value.clamp(0.0, 1.0).toDouble() : 0.0;

    _isDraggingNotifier.value = false;

    unawaited(_seekToFraction(safeValue));

    _showControlsNow();
  }

  void _toggleControls() {
    if (_showControlsNotifier.value) {
      _cancelControlsTimer();
      _showControlsNotifier.value = false;
      return;
    }

    _showControlsNow();
  }

  void _showControlsNow() {
    _showControlsNotifier.value = true;

    final controller = _controller;

    if (controller != null && controller.value.isPlaying) {
      _scheduleControlsHide();
    } else {
      _cancelControlsTimer();
    }
  }

  void _scheduleControlsHide() {
    _controlsTimer?.cancel();

    final controller = _controller;

    if (controller == null ||
        !controller.value.isPlaying ||
        _isDraggingNotifier.value) {
      return;
    }

    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _disposed) {
        return;
      }

      final currentController = _controller;

      if (currentController == null ||
          !currentController.value.isPlaying ||
          _isDraggingNotifier.value) {
        return;
      }

      _showControlsNotifier.value = false;
      _controlsTimer = null;
    });
  }

  void _cancelControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = null;
  }

  void _showSeekFeedback(String value) {
    _feedbackTimer?.cancel();

    _seekFeedbackNotifier.value = value;

    _feedbackTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted || _disposed) {
        return;
      }

      _seekFeedbackNotifier.value = null;
      _feedbackTimer = null;
    });
  }

  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  Widget _buildVideoSurface() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: _buildLoadingState(),
      );
    }

    final aspectRatio = controller.value.aspectRatio > 0
        ? controller.value.aspectRatio
        : 16 / 9;

    return Center(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: VideoPlayer(controller),
      ),
    );
  }

  Widget _buildLoadingState() {
    final error = _errorNotifier.value;

    if (error != null) {
      return _buildErrorState(error);
    }

    return const SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white70,
              size: 34,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGestureLayer() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, showControls, _) {
        final bottom = showControls ? 88.0 : 0.0;

        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: bottom,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleControls,
                  onDoubleTap: () {
                    unawaited(_seekRelative(-10));
                  },
                  child: const SizedBox.expand(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleControls,
                  child: const SizedBox.expand(),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _toggleControls,
                  onDoubleTap: () {
                    unawaited(_seekRelative(10));
                  },
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomGradient() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 115,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.88),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterControls() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 88,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSeekButton(
                  icon: Icons.replay_10_rounded,
                  tooltip: 'Back 10 seconds',
                  onPressed: () {
                    unawaited(_seekRelative(-10));
                  },
                ),
                const SizedBox(width: 22),
                _buildPlayButton(),
                const SizedBox(width: 22),
                _buildSeekButton(
                  icon: Icons.forward_10_rounded,
                  tooltip: 'Forward 10 seconds',
                  onPressed: () {
                    unawaited(_seekRelative(10));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    final controller = _controller;

    final isPlaying =
        controller != null &&
        controller.value.isInitialized &&
        controller.value.isPlaying;

    return Material(
      color: Colors.black.withValues(alpha: 0.62),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _togglePlayPause,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _buildSeekButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.black.withValues(alpha: 0.62),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: 50,
            height: 50,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: 12,
          right: 12,
          bottom: 7,
          height: 78,
          child: Column(
            children: [
              _buildSlider(),
              const SizedBox(height: 1),
              Row(
                children: [
                  _buildTimeLabel(),
                  const Spacer(),
                  _buildPlaybackSpeedButton(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlider() {
    return ValueListenableBuilder<double>(
      valueListenable: _sliderNotifier,
      builder: (context, value, _) {
        final safeValue = value.isFinite
            ? value.clamp(0.0, 1.0).toDouble()
            : 0.0;

        return SizedBox(
          height: 34,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 15),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white38,
              thumbColor: Colors.white,
              overlayColor: Colors.white24,
            ),
            child: Slider(
              value: safeValue,
              min: 0,
              max: 1,
              onChangeStart: _handleSliderStart,
              onChanged: _handleSliderChanged,
              onChangeEnd: _handleSliderEnd,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeLabel() {
    return Text(
      '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildPlaybackSpeedButton() {
    return ValueListenableBuilder<double>(
      valueListenable: _playbackRateNotifier,
      builder: (context, rate, _) {
        return PopupMenuButton<double>(
          tooltip: 'Playback speed',
          initialValue: rate,
          color: Colors.black87,
          onOpened: _cancelControlsTimer,
          onCanceled: _showControlsNow,
          onSelected: (selectedRate) {
            unawaited(_changePlaybackRate(selectedRate));
          },
          itemBuilder: (context) {
            const rates = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

            return rates.map((item) {
              final selected = item == rate;

              return PopupMenuItem<double>(
                value: item,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_formatPlaybackRate(item)}x',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w500,
                      ),
                    ),
                    if (selected)
                      const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.58),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_formatPlaybackRate(rate)}x',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeekFeedback() {
    return ValueListenableBuilder<String?>(
      valueListenable: _seekFeedbackNotifier,
      builder: (context, feedback, _) {
        if (feedback == null) {
          return const SizedBox.shrink();
        }

        final isForward = feedback.startsWith('+');

        return Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Container(
                  key: ValueKey(feedback),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.68),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isForward
                            ? Icons.fast_forward_rounded
                            : Icons.fast_rewind_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        '$feedback sec',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String? _extractVideoId(String value) {
    final input = value.trim();

    if (input.isEmpty) {
      return null;
    }

    try {
      final id = VideoId.parseVideoId(input);

      if (id != null && VideoId.validateVideoId(id)) {
        return id;
      }
    } catch (_) {}

    final idPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

    if (idPattern.hasMatch(input)) {
      return input;
    }

    return null;
  }

  String _formatDuration(Duration duration) {
    if (duration <= Duration.zero) {
      return '00:00';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPlaybackRate(double rate) {
    if (rate == rate.roundToDouble()) {
      return rate.toStringAsFixed(0);
    }

    return rate.toStringAsFixed(2).replaceFirst(RegExp(r'0+$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: _errorNotifier,
      builder: (context, error, _) {
        final controller = _controller;

        final initialized =
            controller != null && controller.value.isInitialized;

        return AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              color: Colors.black,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.hardEdge,
                children: [
                  _buildVideoSurface(),
                  if (error == null && initialized) _buildGestureLayer(),
                  _buildBottomGradient(),
                  if (error == null && initialized) _buildCenterControls(),
                  if (error == null && initialized) _buildBottomControls(),
                  _buildSeekFeedback(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _disposed = true;
    ++_loadRequestId;

    _cancelControlsTimer();
    _cancelFeedbackTimer();

    final controller = _controller;

    if (controller != null) {
      controller.removeListener(_handleControllerChanged);
      unawaited(controller.dispose());
    }

    _controller = null;

    _showControlsNotifier.dispose();
    _isDraggingNotifier.dispose();
    _sliderNotifier.dispose();
    _errorNotifier.dispose();
    _seekFeedbackNotifier.dispose();
    _playbackRateNotifier.dispose();

    super.dispose();
  }
}
