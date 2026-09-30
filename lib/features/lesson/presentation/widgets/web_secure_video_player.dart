import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class WebSecureVideoPlayer extends StatefulWidget {
  const WebSecureVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
  });

  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  @override
  State<WebSecureVideoPlayer> createState() => _WebSecureVideoPlayerState();
}

class _WebSecureVideoPlayerState extends State<WebSecureVideoPlayer> {
  YoutubePlayerController? _controller;

  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;

  StreamSubscription<YoutubePlayerValue>? _playerStateSubscription;

  Timer? _controlsTimer;
  Timer? _feedbackTimer;

  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);

  final ValueNotifier<bool> _isDraggingNotifier = ValueNotifier(false);

  final ValueNotifier<double> _sliderNotifier = ValueNotifier(0);

  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);

  final ValueNotifier<String?> _seekFeedbackNotifier = ValueNotifier(null);

  final ValueNotifier<double> _playbackRateNotifier = ValueNotifier(1.0);

  final ValueNotifier<Duration> _positionNotifier = ValueNotifier(
    Duration.zero,
  );

  final ValueNotifier<Duration> _durationNotifier = ValueNotifier(
    Duration.zero,
  );

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool _completionSent = false;
  bool _disposed = false;

  bool _durationRequestInFlight = false;

  int _loadRequestId = 0;

  @override
  void initState() {
    super.initState();

    unawaited(_loadVideo(widget.videoUrl));
  }

  @override
  void didUpdateWidget(covariant WebSecureVideoPlayer oldWidget) {
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

    await _cancelSubscriptions();
    await _closeController();

    if (!_isCurrentRequest(requestId)) {
      return;
    }

    _resetState();

    if (mounted) {
      setState(() {});
    }

    await _loadVideo(url, requestId: requestId);
  }

  void _resetState() {
    _completionSent = false;
    _durationRequestInFlight = false;

    _position = Duration.zero;
    _duration = Duration.zero;

    _positionNotifier.value = Duration.zero;

    _durationNotifier.value = Duration.zero;

    _sliderNotifier.value = 0;

    _showControlsNotifier.value = true;

    _isDraggingNotifier.value = false;

    _playbackRateNotifier.value = 1.0;

    _errorNotifier.value = null;

    _seekFeedbackNotifier.value = null;
  }

  Future<void> _loadVideo(String url, {int? requestId}) async {
    final currentRequestId = requestId ?? ++_loadRequestId;

    _cancelControlsTimer();
    _cancelFeedbackTimer();

    await _cancelSubscriptions();
    await _closeController();

    if (!_isCurrentRequest(currentRequestId)) {
      return;
    }

    _resetState();

    final videoId = _extractVideoId(url);

    if (videoId == null) {
      _errorNotifier.value = 'Invalid YouTube video URL.';

      if (mounted && !_disposed) {
        setState(() {});
      }

      return;
    }

    final params = YoutubePlayerParams(
      showControls: false,
      showFullscreenButton: false,
      enableKeyboard: false,
      enableJavaScript: true,
      mute: false,
      enableCaption: false,
      interfaceLanguage: 'en',
      showVideoAnnotations: false,
      loop: false,
      playsInline: true,
      strictRelatedVideos: true,

      // Keep the native YouTube controls hidden.
      // The Flutter controls below are used instead.
      pointerEvents: PointerEvents.none,

      // Recommended origin for IFrame API.
      origin: kIsWeb ? Uri.base.origin : null,

      // Privacy-enhanced YouTube host.
      privacyEnhancedMode: true,

      // Avoid excessive JS bridge polling.
      videoStateUpdateInterval: 250,
    );

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      credentialless: false,
      params: params,
    );

    if (!_isCurrentRequest(currentRequestId)) {
      await controller.close();
      return;
    }

    _controller = controller;

    _videoStateSubscription = controller.videoStateStream.listen((videoState) {
      if (!_isCurrentRequest(currentRequestId)) {
        return;
      }

      final position = videoState.position;

      _position = position;

      _positionNotifier.value = position;

      if (!_isDraggingNotifier.value) {
        _updateSliderFromPosition();
      }

      _checkCompletionFromPosition();
    });

    _playerStateSubscription = controller.stream.listen((value) {
      if (!_isCurrentRequest(currentRequestId)) {
        return;
      }

      _handlePlayerValue(value, controller);
    });

    if (mounted && !_disposed) {
      setState(() {});
    }
  }

  bool _isCurrentRequest(int requestId) {
    return !_disposed && requestId == _loadRequestId;
  }

  void _handlePlayerValue(
    YoutubePlayerValue value,
    YoutubePlayerController controller,
  ) {
    if (_disposed || !identical(controller, _controller)) {
      return;
    }

    if (value.hasError) {
      _errorNotifier.value = _getErrorMessage(value.error);

      _cancelControlsTimer();

      _showControlsNotifier.value = true;

      if (mounted) {
        setState(() {});
      }

      return;
    }

    final metadataDuration = value.metaData.duration;

    if (metadataDuration > Duration.zero) {
      if (metadataDuration != _duration) {
        _duration = metadataDuration;

        _durationNotifier.value = metadataDuration;

        _updateSliderFromPosition();
      }
    } else {
      _requestDurationIfNeeded(controller);
    }

    final playbackRate = value.playbackRate;

    if (playbackRate > 0 && playbackRate != _playbackRateNotifier.value) {
      _playbackRateNotifier.value = playbackRate;
    }

    switch (value.playerState) {
      case PlayerState.ended:
        if (_duration > Duration.zero) {
          _position = _duration;

          _positionNotifier.value = _duration;

          _sliderNotifier.value = 1.0;
        }

        _cancelControlsTimer();

        _showControlsNotifier.value = true;

        _emitCompletion();

        break;

      case PlayerState.playing:
        _scheduleControlsHide();
        break;

      case PlayerState.paused:
      case PlayerState.cued:
      case PlayerState.buffering:
      case PlayerState.unStarted:
      case PlayerState.unknown:
        _cancelControlsTimer();

        _showControlsNotifier.value = true;

        break;
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _requestDurationIfNeeded(YoutubePlayerController controller) {
    if (_durationRequestInFlight ||
        _disposed ||
        !identical(controller, _controller)) {
      return;
    }

    _durationRequestInFlight = true;

    unawaited(() async {
      try {
        final seconds = await controller.duration;

        if (_disposed || !identical(controller, _controller)) {
          return;
        }

        if (seconds > 0) {
          final duration = Duration(milliseconds: (seconds * 1000).round());

          _duration = duration;

          _durationNotifier.value = duration;

          _updateSliderFromPosition();
        }
      } catch (_) {
        // The metadata stream may provide
        // the duration later.
      } finally {
        _durationRequestInFlight = false;
      }
    }());
  }

  void _checkCompletionFromPosition() {
    if (_completionSent || _duration <= Duration.zero) {
      return;
    }

    final remaining = _duration - _position;

    if (remaining <= const Duration(milliseconds: 500)) {
      _emitCompletion();
    }
  }

  void _emitCompletion() {
    if (_completionSent || _disposed) {
      return;
    }

    _completionSent = true;

    final callback = widget.onVideoCompleted;

    if (callback == null) {
      return;
    }

    final requestId = _loadRequestId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed || requestId != _loadRequestId) {
        return;
      }

      callback();
    });
  }

  bool _isPlayerUsable() {
    final controller = _controller;

    if (controller == null) {
      return false;
    }

    return controller.value.playerState != PlayerState.unknown;
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) {
      return;
    }

    _showControlsNow();

    try {
      final state = controller.value.playerState;

      if (state == PlayerState.playing) {
        await controller.pauseVideo();
        return;
      }

      final isAtEnd =
          state == PlayerState.ended ||
          (_duration > Duration.zero &&
              _position >= _duration - const Duration(milliseconds: 500));

      if (isAtEnd) {
        _completionSent = false;

        await controller.seekTo(seconds: 0, allowSeekAhead: true);

        _position = Duration.zero;

        _positionNotifier.value = Duration.zero;

        _sliderNotifier.value = 0;
      }

      await controller.playVideo();
    } catch (error) {
      debugPrint('WebSecureVideoPlayer play/pause failed: $error');
    }
  }

  Future<void> _seekRelative(double seconds) async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) {
      return;
    }

    _showControlsNow();

    try {
      final currentSeconds = await controller.currentTime;

      final durationSeconds = await controller.duration;

      var targetSeconds = currentSeconds + seconds;

      if (targetSeconds < 0) {
        targetSeconds = 0;
      }

      if (durationSeconds > 0 && targetSeconds > durationSeconds) {
        targetSeconds = durationSeconds;
      }

      if (targetSeconds < currentSeconds) {
        _completionSent = false;
      }

      await controller.seekTo(seconds: targetSeconds, allowSeekAhead: true);

      _position = Duration(milliseconds: (targetSeconds * 1000).round());

      _positionNotifier.value = _position;

      if (durationSeconds > 0) {
        _duration = Duration(milliseconds: (durationSeconds * 1000).round());

        _durationNotifier.value = _duration;
      }

      _updateSliderFromPosition();

      _showSeekFeedback(seconds < 0 ? '-10' : '+10');
    } catch (error) {
      debugPrint('WebSecureVideoPlayer seek failed: $error');
    }
  }

  Future<void> _seekToFraction(double fraction) async {
    final controller = _controller;

    if (controller == null ||
        !_isPlayerUsable() ||
        _duration <= Duration.zero) {
      return;
    }

    final safeFraction = _safeFraction(fraction);

    final targetSeconds = (_duration.inMilliseconds * safeFraction) / 1000;

    if (targetSeconds < (_duration.inMilliseconds / 1000) - 0.5) {
      _completionSent = false;
    }

    try {
      await controller.seekTo(seconds: targetSeconds, allowSeekAhead: true);

      _position = Duration(milliseconds: (targetSeconds * 1000).round());

      _positionNotifier.value = _position;

      _sliderNotifier.value = safeFraction;
    } catch (error) {
      debugPrint('WebSecureVideoPlayer slider seek failed: $error');
    }
  }

  Future<void> _changePlaybackRate(double rate) async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) {
      return;
    }

    const allowedRates = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

    if (!allowedRates.contains(rate)) {
      return;
    }

    _cancelControlsTimer();

    try {
      await controller.setPlaybackRate(rate);

      _playbackRateNotifier.value = rate;

      if (controller.value.playerState == PlayerState.playing) {
        _scheduleControlsHide();
      }
    } catch (error) {
      debugPrint('WebSecureVideoPlayer playback speed failed: $error');

      final currentRate = controller.value.playbackRate;

      if (currentRate > 0) {
        _playbackRateNotifier.value = currentRate;
      }
    }
  }

  void _updateSliderFromPosition() {
    if (_isDraggingNotifier.value) {
      return;
    }

    if (_duration <= Duration.zero || _duration.inMilliseconds <= 0) {
      _sliderNotifier.value = 0;
      return;
    }

    final positionMilliseconds = _position.inMilliseconds
        .clamp(0, _duration.inMilliseconds)
        .toInt();

    final fraction = positionMilliseconds / _duration.inMilliseconds;

    if (!fraction.isFinite) {
      _sliderNotifier.value = 0;
      return;
    }

    _sliderNotifier.value = fraction.clamp(0.0, 1.0).toDouble();
  }

  void _handleSliderStart(double value) {
    _cancelControlsTimer();

    _isDraggingNotifier.value = true;

    final safeValue = _safeFraction(value);

    _sliderNotifier.value = safeValue;

    if (_duration > Duration.zero) {
      _position = Duration(
        milliseconds: (_duration.inMilliseconds * safeValue).round(),
      );

      _positionNotifier.value = _position;
    }
  }

  void _handleSliderChanged(double value) {
    final safeValue = _safeFraction(value);

    _sliderNotifier.value = safeValue;

    if (_duration > Duration.zero) {
      _position = Duration(
        milliseconds: (_duration.inMilliseconds * safeValue).round(),
      );

      _positionNotifier.value = _position;
    }
  }

  void _handleSliderEnd(double value) {
    final safeValue = _safeFraction(value);

    _isDraggingNotifier.value = false;

    unawaited(_seekToFraction(safeValue));

    _showControlsNow();
  }

  double _safeFraction(double value) {
    if (!value.isFinite) {
      return 0;
    }

    return value.clamp(0.0, 1.0).toDouble();
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

    if (controller != null &&
        controller.value.playerState == PlayerState.playing) {
      _scheduleControlsHide();
    } else {
      _cancelControlsTimer();
    }
  }

  void _scheduleControlsHide() {
    _controlsTimer?.cancel();

    final controller = _controller;

    if (controller == null ||
        controller.value.playerState != PlayerState.playing ||
        _isDraggingNotifier.value) {
      return;
    }

    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted || _disposed) {
        return;
      }

      final currentController = _controller;

      if (currentController == null ||
          currentController.value.playerState != PlayerState.playing ||
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

  Widget _buildPlayerOverlay(YoutubePlayerValue value) {
    if (value.hasError) {
      return _buildErrorState(_getErrorMessage(value.error));
    }

    if (value.playerState == PlayerState.unknown) {
      return ValueListenableBuilder<String?>(
        valueListenable: _errorNotifier,
        builder: (context, error, _) {
          if (error != null) {
            return _buildErrorState(error);
          }

          return const Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            ),
          );
        },
      );
    }

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        _buildGestureLayer(),
        _buildBottomGradient(),
        _buildCenterControls(value),
        _buildBottomControls(value),
        _buildSeekFeedback(),
      ],
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

  Widget _buildCenterControls(YoutubePlayerValue value) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        final isPlaying = value.playerState == PlayerState.playing;

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
                _buildPlayButton(isPlaying),
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

  Widget _buildPlayButton(bool isPlaying) {
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

  Widget _buildBottomControls(YoutubePlayerValue value) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControlsNotifier,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        final usable = value.playerState != PlayerState.unknown;

        return Positioned(
          left: 12,
          right: 12,
          bottom: 7,
          height: 78,
          child: Column(
            children: [
              _buildSlider(usable),
              const SizedBox(height: 1),
              Row(
                children: [
                  _buildTimeLabel(),
                  const Spacer(),
                  _buildPlaybackSpeedButton(usable),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSlider(bool usable) {
    return ValueListenableBuilder<double>(
      valueListenable: _sliderNotifier,
      builder: (context, value, _) {
        final safeValue = _safeFraction(value);

        final enabled = usable && _duration > Duration.zero;

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
              onChangeStart: enabled ? _handleSliderStart : null,
              onChanged: enabled ? _handleSliderChanged : null,
              onChangeEnd: enabled ? _handleSliderEnd : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeLabel() {
    return AnimatedBuilder(
      animation: Listenable.merge([_positionNotifier, _durationNotifier]),
      builder: (context, _) {
        return Text(
          '${_formatDuration(_positionNotifier.value)} / '
          '${_formatDuration(_durationNotifier.value)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _buildPlaybackSpeedButton(bool usable) {
    return ValueListenableBuilder<double>(
      valueListenable: _playbackRateNotifier,
      builder: (context, rate, _) {
        return PopupMenuButton<double>(
          enabled: usable,
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

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
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
      ),
    );
  }

  String _getErrorMessage(YoutubeError error) {
    switch (error) {
      case YoutubeError.none:
        return 'Unable to load this YouTube video.';

      case YoutubeError.invalidParam:
        return 'Invalid YouTube video URL.';

      case YoutubeError.html5Error:
        return 'This video cannot be played in the browser.';

      case YoutubeError.videoNotFound:
        return 'This YouTube video is unavailable, private, or deleted.';

      case YoutubeError.notEmbeddable:
        return 'This video does not allow embedded playback.';

      case YoutubeError.cannotFindVideo:
        return 'YouTube could not find this video.';

      case YoutubeError.sameAsNotEmbeddable:
        return 'This video does not allow embedded playback.';

      case YoutubeError.sameAsNotEmbeddable2:
        return 'This video does not allow embedded playback.';

      case YoutubeError.unknown:
        return 'Unable to load this YouTube video.';
    }
  }

  String? _extractVideoId(String value) {
    final input = value.trim();

    if (input.isEmpty) {
      return null;
    }

    final rawIdPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');

    if (rawIdPattern.hasMatch(input)) {
      return input;
    }

    return YoutubePlayerController.convertUrlToId(input);
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
    final controller = _controller;

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: controller == null
            ? ValueListenableBuilder<String?>(
                valueListenable: _errorNotifier,
                builder: (context, error, _) {
                  if (error != null) {
                    return _buildErrorState(error);
                  }

                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              )
            : YoutubePlayer(
                key: ValueKey(controller.key),
                controller: controller,
                aspectRatio: 16 / 9,
                autoFullScreen: false,
                enableFullScreenOnVerticalDrag: false,
                keepAlive: false,
                thumbnailQuality: ThumbnailQuality.high,
                thumbnailFormat: ThumbnailFormat.webp,
                controlsBuilder: (context, isFullscreen) {
                  return YoutubeValueBuilder(
                    controller: controller,
                    builder: (context, value) {
                      return _buildPlayerOverlay(value);
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<void> _cancelSubscriptions() async {
    final videoStateSubscription = _videoStateSubscription;

    final playerStateSubscription = _playerStateSubscription;

    _videoStateSubscription = null;

    _playerStateSubscription = null;

    if (videoStateSubscription != null) {
      await videoStateSubscription.cancel();
    }

    if (playerStateSubscription != null) {
      await playerStateSubscription.cancel();
    }
  }

  Future<void> _closeController() async {
    final controller = _controller;

    _controller = null;

    if (controller == null) {
      return;
    }

    try {
      await controller.close();
    } catch (_) {}
  }

  @override
  void dispose() {
    _disposed = true;

    ++_loadRequestId;

    _cancelControlsTimer();
    _cancelFeedbackTimer();

    final videoStateSubscription = _videoStateSubscription;

    final playerStateSubscription = _playerStateSubscription;

    final controller = _controller;

    _videoStateSubscription = null;

    _playerStateSubscription = null;

    _controller = null;

    if (videoStateSubscription != null) {
      unawaited(videoStateSubscription.cancel());
    }

    if (playerStateSubscription != null) {
      unawaited(playerStateSubscription.cancel());
    }

    if (controller != null) {
      unawaited(controller.close());
    }

    _showControlsNotifier.dispose();

    _isDraggingNotifier.dispose();

    _sliderNotifier.dispose();

    _errorNotifier.dispose();

    _seekFeedbackNotifier.dispose();

    _playbackRateNotifier.dispose();

    _positionNotifier.dispose();

    _durationNotifier.dispose();

    super.dispose();
  }
}
