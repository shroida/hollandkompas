import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class SecureVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  const SecureVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
  });

  @override
  State<SecureVideoPlayer> createState() => _SecureVideoPlayerState();
}

class _SecureVideoPlayerState extends State<SecureVideoPlayer> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;

  bool _showControls = true;
  bool _isInitialized = false;
  bool _completionCalled = false;
  bool _isDraggingSlider = false;

  double _dragSliderValue = 0.0;
  double _playbackSpeed = 1.0;

  Timer? _hideControlsTimer;
  late final String? _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(widget.videoUrl);

    if (_videoId == null || _videoId.isEmpty) {
      return;
    }

    _initializePlayer(_videoId);
  }

  /// استخراج Video ID سواء تم إرسال URL كامل أو ID فقط
  String? _extractVideoId(String input) {
    if (input.length == 11 && !input.contains('/')) {
      return input;
    }
    return YoutubePlayerController.convertUrlToId(input);
  }

  void _initializePlayer(String videoId) {
    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        privacyEnhancedMode: true,
        showControls: false,
        showFullscreenButton: false,
        enableKeyboard: false,
        playsInline: true,
        strictRelatedVideos: true,
        enableCaption: false,
        videoStateUpdateInterval: 250,
      ),
    );

    _controller = controller;

    _videoStateSubscription = controller.videoStateStream.listen((state) {
      if (!mounted) return;

      final currentPlayerState = controller.value.playerState;

      // تعديل: كتابة unStarted بحرف S كبير
      if (!_isInitialized &&
          currentPlayerState != PlayerState.unStarted &&
          currentPlayerState != PlayerState.unknown) {
        setState(() {
          _isInitialized = true;
        });
      }

      _checkCompletion(state);
      setState(() {});
    });
  }

  void _resetControlsTimer() {
    _hideControlsTimer?.cancel();
    if (_controller?.value.playerState == PlayerState.playing) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && !_isDraggingSlider) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  void _checkCompletion(YoutubeVideoState state) {
    final controller = _controller;
    if (controller == null) return;

    final duration = controller.metadata.duration;
    if (duration <= Duration.zero) return;

    final position = state.position;
    final currentPlayerState = controller.value.playerState;

    final reachedEnd =
        position >= (duration - const Duration(milliseconds: 500)) &&
        currentPlayerState == PlayerState.ended;

    if (reachedEnd && !_completionCalled) {
      _completionCalled = true;
      widget.onVideoCompleted?.call();
    }
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;
    if (controller == null) return;

    final state = controller.value.playerState;

    if (state == PlayerState.playing) {
      await controller.pauseVideo();
      _hideControlsTimer?.cancel();
      setState(() {
        _showControls = true;
      });
    } else {
      await controller.playVideo();
      setState(() {
        _showControls = true;
      });
      _resetControlsTimer();
    }
  }

  Future<void> _seekBy(Duration offset) async {
    final controller = _controller;
    if (controller == null) return;

    final currentSeconds = await controller.currentTime;
    final durationSeconds = await controller.duration;

    var targetSeconds = currentSeconds + (offset.inMilliseconds / 1000.0);

    if (targetSeconds < 0) {
      targetSeconds = 0;
    }

    if (durationSeconds > 0 && targetSeconds > durationSeconds) {
      targetSeconds = durationSeconds;
    }

    await controller.seekTo(seconds: targetSeconds, allowSeekAhead: true);
    _resetControlsTimer();
  }

  Future<void> _changeSpeed(double speed) async {
    final controller = _controller;
    if (controller == null) return;

    await controller.setPlaybackRate(speed);

    if (!mounted) return;

    setState(() {
      _playbackSpeed = speed;
    });
    _resetControlsTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _videoId.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildErrorState(),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: Colors.black,
        child: AspectRatio(aspectRatio: 16 / 9, child: _buildPlayer()),
      ),
    );
  }

  Widget _buildPlayer() {
    final controller = _controller;
    if (controller == null) {
      return _buildErrorState();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        YoutubePlayer(
          controller: controller,
          aspectRatio: 16 / 9,
          autoFullScreen: false,
          enableFullScreenOnVerticalDrag: false,
          keepAlive: false,
        ),

        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                _showControls = !_showControls;
              });
              if (_showControls) {
                _resetControlsTimer();
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () => _seekBy(const Duration(seconds: -10)),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onDoubleTap: () => _seekBy(const Duration(seconds: 10)),
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_showControls,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _showControls ? 1.0 : 0.0,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                      Colors.black87,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  children: [
                    _buildHeader(),
                    const Spacer(),
                    _buildCenterControls(),
                    const Spacer(),
                    _buildBottomControls(),
                  ],
                ),
              ),
            ),
          ),
        ),

        StreamBuilder<YoutubeVideoState>(
          stream: controller.videoStateStream,
          builder: (context, snapshot) {
            final isBuffering =
                controller.value.playerState == PlayerState.buffering;

            if (!_isInitialized || isBuffering) {
              return Positioned.fill(
                child: Container(
                  color: !_isInitialized ? Colors.black : Colors.black38,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.school_rounded, color: Colors.white70, size: 20),
          SizedBox(width: 8),
          Text(
            'HollandKompas Player',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    final isPlaying = controller.value.playerState == PlayerState.playing;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Back 10s',
          onPressed: () => _seekBy(const Duration(seconds: -10)),
          icon: const Icon(
            Icons.replay_10_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
        const SizedBox(width: 28),
        IconButton(
          tooltip: isPlaying ? 'Pause' : 'Play',
          onPressed: _togglePlayPause,
          icon: Icon(
            isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded,
            color: Colors.white,
            size: 64,
          ),
        ),
        const SizedBox(width: 28),
        IconButton(
          tooltip: 'Forward 10s',
          onPressed: () => _seekBy(const Duration(seconds: 10)),
          icon: const Icon(
            Icons.forward_10_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressBar(),
          Row(
            children: [_buildTimeLabel(), const Spacer(), _buildSpeedButton()],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final position = state?.position ?? Duration.zero;
        final duration = controller.metadata.duration;

        final totalMs = duration.inMilliseconds.toDouble();
        final currentMs = position.inMilliseconds.toDouble();

        double sliderValue = 0.0;
        if (totalMs > 0) {
          sliderValue = (currentMs / totalMs).clamp(0.0, 1.0);
        }

        final displayValue = _isDraggingSlider ? _dragSliderValue : sliderValue;

        return SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          child: Slider(
            value: displayValue,
            onChangeStart: (val) {
              setState(() {
                _isDraggingSlider = true;
                _dragSliderValue = val;
              });
              _hideControlsTimer?.cancel();
            },
            onChanged: (val) {
              setState(() {
                _dragSliderValue = val;
              });
            },
            onChangeEnd: (val) async {
              setState(() {
                _isDraggingSlider = false;
              });

              if (totalMs > 0) {
                final targetSeconds = (totalMs * val) / 1000.0;
                await controller.seekTo(
                  seconds: targetSeconds,
                  allowSeekAhead: true,
                );
              }
              _resetControlsTimer();
            },
          ),
        );
      },
    );
  }

  Widget _buildTimeLabel() {
    final controller = _controller;
    if (controller == null) return const SizedBox.shrink();

    return StreamBuilder<YoutubeVideoState>(
      stream: controller.videoStateStream,
      builder: (context, snapshot) {
        final position = snapshot.data?.position ?? Duration.zero;
        final duration = controller.metadata.duration;

        return Text(
          '${_formatDuration(position)} / ${_formatDuration(duration)}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  Widget _buildSpeedButton() {
    return PopupMenuButton<double>(
      initialValue: _playbackSpeed,
      tooltip: 'Playback Speed',
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: _changeSpeed,
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 0.5,
          child: Text('0.5x', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 0.75,
          child: Text('0.75x', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 1.0,
          child: Text('1.0x (Normal)', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 1.25,
          child: Text('1.25x', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 1.5,
          child: Text('1.5x', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem(
          value: 2.0,
          child: Text('2.0x', style: TextStyle(color: Colors.white)),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '${_playbackSpeed}x',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.grey[900],
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.play_circle_outline_rounded,
            color: Colors.white38,
            size: 48,
          ),
          SizedBox(height: 12),
          Text(
            'Unable to load video',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoStateSubscription?.cancel();
    _controller?.close();
    super.dispose();
  }
}
