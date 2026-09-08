import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  double _playbackSpeed = 1.0;
  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    await _controller.initialize();
    _controller.addListener(_videoListener);
    if (!mounted) return;
    setState(() {
      _isInitialized = true;
    });
  }

  void _videoListener() {
    if (!_controller.value.isInitialized) return;
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    if (duration.inMilliseconds > 0 &&
        position >= duration &&
        !_controller.value.isPlaying) {
      widget.onVideoCompleted?.call();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _togglePlayPause() async {
    if (_controller.value.isPlaying) {
      await _controller.pause();
    } else {
      await _controller.play();
    }
    if (!mounted) return;
    setState(() {
      _showControls = true;
    });
  }

  Future<void> _seekBy(Duration offset) async {
    final current = _controller.value.position;
    final duration = _controller.value.duration;
    var target = current + offset;
    if (target < Duration.zero) {
      target = Duration.zero;
    }
    if (target > duration) {
      target = duration;
    }
    await _controller.seekTo(target);
  }

  Future<void> _changeSpeed(double speed) async {
    await _controller.setPlaybackSpeed(speed);
    if (!mounted) return;
    setState(() {
      _playbackSpeed = speed;
    });
  }

  Future<void> _toggleFullscreen() async {
    if (_isFullscreen) {
      await _exitFullscreen();
    } else {
      await _enterFullscreen();
    }
  }

  Future<void> _enterFullscreen() async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        fullscreenDialog: true,
        pageBuilder: (_, _, _) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Center(child: _buildVideoContent(fullscreen: true)),
            ),
          );
        },
      ),
    );
    if (!mounted) return;
    setState(() {
      _isFullscreen = false;
    });
  }

  Future<void> _exitFullscreen() async {
    Navigator.of(context).pop();
  }

  Widget _buildVideoContent({bool fullscreen = false}) {
    if (!_isInitialized) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final aspectRatio = _controller.value.aspectRatio;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio > 0 ? aspectRatio : 16 / 9,
            child: VideoPlayer(_controller),
          ),
          if (_showControls)
            Positioned.fill(child: _buildControls(fullscreen: fullscreen)),
        ],
      ),
    );
  }

  Widget _buildControls({required bool fullscreen}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black54, Colors.transparent, Colors.black87],
          stops: [0, 0.45, 1],
        ),
      ),
      child: Column(
        children: [
          const Spacer(),
          _buildCenterControls(),
          const Spacer(),
          _buildBottomControls(fullscreen: fullscreen),
        ],
      ),
    );
  }

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            _seekBy(const Duration(seconds: -10));
          },
          icon: const Icon(
            Icons.replay_10_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: _togglePlayPause,
          icon: Icon(
            _controller.value.isPlaying
                ? Icons.pause_circle_filled_rounded
                : Icons.play_circle_fill_rounded,
            color: Colors.white,
            size: 64,
          ),
        ),
        const SizedBox(width: 20),
        IconButton(
          onPressed: () {
            _seekBy(const Duration(seconds: 10));
          },
          icon: const Icon(
            Icons.forward_10_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls({required bool fullscreen}) {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          Row(
            children: [
              Text(
                _formatDuration(position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Text(
                ' / ',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                _formatDuration(duration),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Spacer(),
              _buildSpeedButton(),
              const SizedBox(width: 4),
              IconButton(
                tooltip: fullscreen ? 'Exit fullscreen' : 'Fullscreen',
                onPressed: _toggleFullscreen,
                icon: Icon(
                  fullscreen
                      ? Icons.fullscreen_exit_rounded
                      : Icons.fullscreen_rounded,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedButton() {
    return PopupMenuButton<double>(
      initialValue: _playbackSpeed,
      tooltip: 'Playback speed',
      color: Colors.black87,
      onSelected: _changeSpeed,
      itemBuilder: (_) {
        return const [
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
            child: Text('1x', style: TextStyle(color: Colors.white)),
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
            child: Text('2x', style: TextStyle(color: Colors.white)),
          ),
        ];
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          '${_playbackSpeed}x',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    if (hours > 0) {
      return '$hours:'
          '${minutes.toString().padLeft(2, '0')}:'
          '${seconds.toString().padLeft(2, '0')}';
    }
    return '$minutes:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: _buildVideoContent(),
    );
  }
}
