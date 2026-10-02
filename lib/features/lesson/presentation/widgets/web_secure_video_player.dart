import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../core/shared/widget/browser_fullscreen.dart';

// ---------------------------------------------------------------------------
// WebSecureVideoPlayer
//
// Flutter Web player for lessons hosted on YouTube, with app-owned controls.
//
// Why the previous version did not work on web (both verified in the source of
// youtube_player_iframe 6.0.2):
//
// 1. Clicks never reached the Flutter controls. On Flutter Web the YouTube
//    player lives in an <iframe> (HtmlElementView). Mouse/touch events that
//    land on an iframe stay inside it and never reach Flutter, so any Flutter
//    widget painted on top of it looks fine but is dead. The official
//    `youtube_player_flutter` package keeps YouTube's native controls on web
//    for exactly this reason. The Flutter team's documented fix is
//    `PointerInterceptor`, which puts a transparent DOM element between the
//    iframe and the Flutter widgets. The whole overlay below is wrapped in one.
//
// 2. `controller.seekTo(seconds:, allowSeekAhead:)` is silently dropped on web.
//    It sends `player.seekTo(10.0, true)` to the iframe, whose message handler
//    (`_safeCall` in assets/player.html) only accepts ONE JSON argument, so
//    JSON.parse("10.0, true") throws and the error is swallowed. That is why
//    "forward 10s", "back 10s" and the progress bar did nothing. We send
//    `player.seekTo(<seconds>)` (one argument) through
//    `controller.webViewController.runJavaScript` instead, which works on every
//    version of the package.
//
// What this file deliberately does NOT do: it never crops/zooms the iframe,
// never injects CSS/JS into YouTube's frame, and never claims the video is
// protected. See the notes in the chat for what YouTube allows you to hide.
// ---------------------------------------------------------------------------

const double _kBarHeight = 88;
const double _kSeekStep = 10;
const Duration _kControlsHideDelay = Duration(seconds: 3);
const List<double> _kPlaybackRates = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

class WebSecureVideoPlayer extends StatelessWidget {
  const WebSecureVideoPlayer({
    super.key,
    required this.videoUrl,
    this.onVideoCompleted,
    this.controlsOverVideo = true,
  });

  final String videoUrl;
  final VoidCallback? onVideoCompleted;

  /// `true`  -> controls are drawn over the video (same look as the mobile
  ///            player). Playback-control overlays are tolerated by YouTube's
  ///            developer policy guide as long as they do not collide with
  ///            YouTube's own UI, but the "Required Minimum Functionality"
  ///            page is stricter ("no overlays in front of any part of the
  ///            player").
  /// `false` -> the control bar sits below the video and nothing covers the
  ///            iframe. This is the strictest reading of YouTube's policy; the
  ///            trade-off is no double-tap gestures and YouTube's own title /
  ///            links stay clickable.
  final bool controlsOverVideo;

  @override
  Widget build(BuildContext context) {
    return _WebPlayerCore(
      videoUrl: videoUrl,
      onVideoCompleted: onVideoCompleted,
      controlsOverVideo: controlsOverVideo,
    );
  }
}

/// Everything needed to continue playback in a freshly created player.
class _PlayerHandoff {
  const _PlayerHandoff({
    required this.position,
    required this.wasPlaying,
    required this.playbackRate,
    required this.volume,
    required this.muted,
  });

  final Duration position;
  final bool wasPlaying;
  final double playbackRate;
  final int volume;
  final bool muted;
}

class _FullscreenResult {
  const _FullscreenResult({required this.handoff, required this.completed});

  final _PlayerHandoff handoff;
  final bool completed;
}

/// Sizes that adapt to the available width (desktop / tablet / phone browser).
class _Metrics {
  const _Metrics(this.width);

  final double width;

  bool get compact => width < 480;
  bool get wide => width >= 820;

  double get playSize => compact ? 54 : 64;
  double get playIcon => compact ? 30 : 35;
  double get seekSize => compact ? 44 : 50;
  double get seekIcon => compact ? 25 : 28;
  double get centerGap => compact ? 14 : 22;
  double get labelSize => compact ? 11 : 12;
  double get iconSize => compact ? 20 : 22;
  double get sidePadding => compact ? 8 : 14;
  bool get showVolumeSlider => wide;
}

class _WebPlayerCore extends StatefulWidget {
  const _WebPlayerCore({
    required this.videoUrl,
    required this.controlsOverVideo,
    this.onVideoCompleted,
    this.handoff,
    this.isFullscreenPage = false,
  });

  final String videoUrl;
  final bool controlsOverVideo;
  final VoidCallback? onVideoCompleted;
  final _PlayerHandoff? handoff;
  final bool isFullscreenPage;

  @override
  State<_WebPlayerCore> createState() => _WebPlayerCoreState();
}

class _WebPlayerCoreState extends State<_WebPlayerCore> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;
  StreamSubscription<YoutubePlayerValue>? _playerValueSubscription;
  void Function()? _cancelFullscreenListener;

  Timer? _controlsTimer;
  Timer? _feedbackTimer;

  final FocusNode _focusNode = FocusNode(debugLabel: 'WebSecureVideoPlayer');

  final ValueNotifier<bool> _showControls = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isDragging = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _speedMenuOpen = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _muted = ValueNotifier<bool>(false);
  final ValueNotifier<int> _volume = ValueNotifier<int>(100);
  final ValueNotifier<double> _slider = ValueNotifier<double>(0);
  final ValueNotifier<double> _buffered = ValueNotifier<double>(0);
  final ValueNotifier<double> _playbackRate = ValueNotifier<double>(1.0);
  final ValueNotifier<Duration> _position = ValueNotifier<Duration>(
    Duration.zero,
  );
  final ValueNotifier<Duration> _duration = ValueNotifier<Duration>(
    Duration.zero,
  );
  final ValueNotifier<PlayerState> _playerState = ValueNotifier<PlayerState>(
    PlayerState.unknown,
  );
  final ValueNotifier<String?> _error = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _seekFeedback = ValueNotifier<String?>(null);

  int _loadGeneration = 0;
  bool _disposed = false;
  bool _completionSent = false;
  bool _wantsToPlay = false;
  bool _settingsApplied = false;
  bool _restoreSettings = false;
  bool _durationRequestInFlight = false;
  bool _suspendedForFullscreen = false;
  bool _sawBrowserFullscreen = false;
  bool _exiting = false;

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    final handoff = widget.handoff;

    if (handoff != null) {
      _playbackRate.value = handoff.playbackRate;
      _volume.value = handoff.volume;
      _muted.value = handoff.muted;
    }

    if (widget.isFullscreenPage) {
      _sawBrowserFullscreen = isBrowserFullscreen;
      _cancelFullscreenListener = listenBrowserFullscreenChange(
        _handleBrowserFullscreenChange,
      );
    }

    _startPlayer(
      startAt: handoff?.position ?? Duration.zero,
      autoPlay: handoff?.wasPlaying ?? false,
      restoreSettings: handoff != null,
    );
  }

  @override
  void didUpdateWidget(covariant _WebPlayerCore oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoUrl.trim() == widget.videoUrl.trim()) {
      return;
    }

    _completionSent = false;

    // Run after the current build pass so notifier listeners are not marked
    // dirty in the middle of it.
    scheduleMicrotask(() {
      if (!mounted || _disposed) return;

      _startPlayer(
        startAt: Duration.zero,
        autoPlay: false,
        restoreSettings: false,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _disposed = true;

    _cancelControlsTimer();
    _cancelFeedbackTimer();
    _cancelFullscreenListener?.call();

    _teardownPlayer();

    _focusNode.dispose();
    _showControls.dispose();
    _isDragging.dispose();
    _speedMenuOpen.dispose();
    _muted.dispose();
    _volume.dispose();
    _slider.dispose();
    _buffered.dispose();
    _playbackRate.dispose();
    _position.dispose();
    _duration.dispose();
    _playerState.dispose();
    _error.dispose();
    _seekFeedback.dispose();

    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Player setup / teardown
  // -------------------------------------------------------------------------

  bool _isCurrent(int generation) {
    return mounted && !_disposed && generation == _loadGeneration;
  }

  YoutubePlayerParams _buildParams() {
    return YoutubePlayerParams(
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

      // Overlay mode: the iframe content never receives pointer events, the
      // Flutter overlay (behind a PointerInterceptor) owns all interaction.
      // Below-video mode: leave the iframe interactive.
      pointerEvents: widget.controlsOverVideo
          ? PointerEvents.none
          : PointerEvents.initial,

      origin: kIsWeb ? Uri.base.origin : null,
      privacyEnhancedMode: true,
      videoStateUpdateInterval: 250,
    );
  }

  void _startPlayer({
    required Duration startAt,
    required bool autoPlay,
    required bool restoreSettings,
  }) {
    _teardownPlayer();

    final generation = ++_loadGeneration;

    _resetPlaybackState(startAt);
    _restoreSettings = restoreSettings;

    final videoId = _extractVideoId(widget.videoUrl);

    if (videoId == null) {
      _error.value = 'Invalid YouTube video URL.';
      return;
    }

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: autoPlay,
      startSeconds: startAt > Duration.zero
          ? startAt.inMilliseconds / 1000
          : null,
      credentialless: false,
      params: _buildParams(),
    );

    _controller = controller;
    _wantsToPlay = autoPlay;

    _playerValueSubscription = controller.stream.listen((value) {
      _handlePlayerValue(generation, controller, value);
    });

    _videoStateSubscription = controller.videoStateStream.listen((state) {
      _handleVideoState(generation, state);
    });
  }

  void _resetPlaybackState(Duration startAt) {
    _cancelControlsTimer();
    _cancelFeedbackTimer();

    _error.value = null;
    _playerState.value = PlayerState.unknown;
    _position.value = startAt;
    _duration.value = Duration.zero;
    _slider.value = 0;
    _buffered.value = 0;
    _showControls.value = true;
    _isDragging.value = false;
    _speedMenuOpen.value = false;
    _seekFeedback.value = null;

    _wantsToPlay = false;
    _settingsApplied = false;
    _durationRequestInFlight = false;
  }

  void _teardownPlayer() {
    // Invalidates every callback that still belongs to the old controller.
    _loadGeneration++;

    final videoStateSubscription = _videoStateSubscription;
    final playerValueSubscription = _playerValueSubscription;
    final controller = _controller;

    _videoStateSubscription = null;
    _playerValueSubscription = null;
    _controller = null;

    unawaited(videoStateSubscription?.cancel());
    unawaited(playerValueSubscription?.cancel());

    if (controller != null) {
      unawaited(_closeController(controller));
    }
  }

  Future<void> _closeController(YoutubePlayerController controller) async {
    try {
      await controller.close();
    } catch (error) {
      _log('close failed: $error');
    }
  }

  // -------------------------------------------------------------------------
  // Player events
  // -------------------------------------------------------------------------

  void _handlePlayerValue(
    int generation,
    YoutubePlayerController controller,
    YoutubePlayerValue value,
  ) {
    if (!_isCurrent(generation)) return;

    if (value.hasError) {
      _log('player error: ${value.error}');
      _error.value = _getErrorMessage(value.error);
      _cancelControlsTimer();
      _showControls.value = true;
      return;
    }

    final state = value.playerState;

    if (state != _playerState.value) {
      _log('state -> $state');
    }

    _playerState.value = state;

    final metadataDuration = value.metaData.duration;

    if (metadataDuration > Duration.zero &&
        metadataDuration != _duration.value) {
      _duration.value = metadataDuration;
      _syncSliderFromPosition();
    }

    if (state != PlayerState.unknown && !_settingsApplied) {
      _settingsApplied = true;
      unawaited(
        _applyInitialSettings(generation, controller, _playbackRate.value),
      );
    }

    if (state != PlayerState.unknown && _duration.value == Duration.zero) {
      unawaited(_requestDuration(generation, controller));
    }

    if (state == PlayerState.playing) {
      _wantsToPlay = true;
      _scheduleControlsHide();
    } else if (state == PlayerState.paused || state == PlayerState.cued) {
      _wantsToPlay = false;
      _cancelControlsTimer();
      _showControls.value = true;
    } else if (state == PlayerState.ended) {
      _handleEnded();
    }
  }

  void _handleVideoState(int generation, YoutubeVideoState state) {
    if (!_isCurrent(generation) || _isDragging.value) return;

    _position.value = state.position;

    final loaded = state.loadedFraction;

    if (loaded.isFinite) {
      _buffered.value = loaded.clamp(0.0, 1.0).toDouble();
    }

    _syncSliderFromPosition();
    _checkCompletionFromPosition();
  }

  Future<void> _applyInitialSettings(
    int generation,
    YoutubePlayerController controller,
    double rate,
  ) async {
    try {
      if (_restoreSettings) {
        // The player was re-created (fullscreen toggle): put the user's
        // speed/volume back.
        if (rate != 1.0) {
          await controller.setPlaybackRate(rate);
        }

        if (_muted.value) {
          await controller.mute();
        } else if (_volume.value != 100) {
          await controller.setVolume(_volume.value);
        }

        return;
      }

      // Fresh start: show the real volume/mute state of the player. Calls are
      // sequential (the package's request/response bridge keys replies by
      // millisecond timestamp, so concurrent reads can get mixed up).
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!_isCurrent(generation)) return;

      final volume = await controller.volume.timeout(
        const Duration(seconds: 2),
      );
      if (!_isCurrent(generation)) return;

      final muted = await controller.isMuted.timeout(
        const Duration(seconds: 2),
      );
      if (!_isCurrent(generation)) return;

      _volume.value = volume.clamp(0, 100).toInt();
      _muted.value = muted;
    } catch (error) {
      _log('initial settings skipped: $error');
    }
  }

  Future<void> _requestDuration(
    int generation,
    YoutubePlayerController controller,
  ) async {
    if (_durationRequestInFlight) return;

    _durationRequestInFlight = true;

    try {
      for (var attempt = 0; attempt < 6; attempt++) {
        await Future<void>.delayed(
          Duration(milliseconds: attempt == 0 ? 400 : 800),
        );

        if (!_isCurrent(generation)) return;

        final seconds = await controller.duration.timeout(
          const Duration(seconds: 2),
        );

        if (!_isCurrent(generation)) return;

        if (seconds > 0) {
          _duration.value = Duration(milliseconds: (seconds * 1000).round());
          _syncSliderFromPosition();
          return;
        }
      }
    } catch (error) {
      _log('duration request failed: $error');
    } finally {
      if (generation == _loadGeneration) {
        _durationRequestInFlight = false;
      }
    }
  }

  // -------------------------------------------------------------------------
  // Completion
  // -------------------------------------------------------------------------

  void _checkCompletionFromPosition() {
    final total = _duration.value;

    if (total <= Duration.zero) return;
    if (_playerState.value != PlayerState.playing) return;

    final remaining = total - _position.value;

    if (remaining <= const Duration(milliseconds: 500)) {
      _handleEnded();
    }
  }

  void _handleEnded() {
    _wantsToPlay = false;
    _cancelControlsTimer();
    _showControls.value = true;
    _emitCompletion();
  }

  void _emitCompletion() {
    if (_completionSent) return;

    _completionSent = true;

    if (widget.isFullscreenPage) {
      // Leave fullscreen first; the inline player reports the completion.
      _exitFullscreenPage(completed: true);
      return;
    }

    final callback = widget.onVideoCompleted;

    if (callback == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _disposed) return;
      callback();
    });
  }

  // -------------------------------------------------------------------------
  // Commands
  // -------------------------------------------------------------------------

  bool _isPlayerUsable() {
    return _controller != null &&
        _error.value == null &&
        _playerState.value != PlayerState.unknown;
  }

  bool _isPlayingLike(PlayerState state) {
    return state == PlayerState.playing ||
        (state == PlayerState.buffering && _wantsToPlay);
  }

  Future<void> _togglePlayPause() async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) return;

    final state = _playerState.value;

    try {
      if (_isPlayingLike(state)) {
        _wantsToPlay = false;
        await controller.pauseVideo();
        return;
      }

      _wantsToPlay = true;

      if (state == PlayerState.ended) {
        await _seekToSeconds(0);
      }

      await controller.playVideo();
    } catch (error) {
      _log('play/pause failed: $error');
    }
  }

  /// Seeks using a ONE-argument call. See the note at the top of the file:
  /// `controller.seekTo(...)` sends two arguments, which the web bridge of
  /// youtube_player_iframe 6.0.x silently rejects.
  Future<void> _seekToSeconds(double seconds) async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable() || !seconds.isFinite) return;

    final totalSeconds = _duration.value.inMilliseconds / 1000;

    var target = seconds < 0 ? 0.0 : seconds;

    if (totalSeconds > 0 && target > totalSeconds) {
      target = totalSeconds;
    }

    try {
      await controller.webViewController.runJavaScript(
        'player.seekTo(${target.toStringAsFixed(3)});',
      );
    } catch (error) {
      _log('seek failed: $error');
      return;
    }

    _position.value = Duration(milliseconds: (target * 1000).round());
    _syncSliderFromPosition();
  }

  Future<void> _seekRelative(double deltaSeconds) async {
    if (!_isPlayerUsable()) return;

    final current = _position.value.inMilliseconds / 1000;

    await _seekToSeconds(current + deltaSeconds);

    final rounded = deltaSeconds.round();

    _showSeekFeedback(rounded > 0 ? '+$rounded' : '$rounded');
    _showControlsNow();
  }

  Future<void> _seekToFraction(double fraction) async {
    final totalSeconds = _duration.value.inMilliseconds / 1000;

    if (totalSeconds <= 0) return;

    await _seekToSeconds(totalSeconds * _safeFraction(fraction));
  }

  Future<void> _changePlaybackRate(double rate) async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) return;

    _playbackRate.value = rate;

    try {
      await controller.setPlaybackRate(rate);
    } catch (error) {
      _log('playback rate failed: $error');
    }
  }

  void _cycleSpeed() {
    final index = _kPlaybackRates.indexOf(_playbackRate.value);
    final next = _kPlaybackRates[(index + 1) % _kPlaybackRates.length];

    unawaited(_changePlaybackRate(next));
  }

  int get _effectiveVolume => _muted.value ? 0 : _volume.value;

  Future<void> _toggleMute() async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) return;

    final nextMuted = !_muted.value;

    _muted.value = nextMuted;

    try {
      if (nextMuted) {
        await controller.mute();
        return;
      }

      await controller.unMute();

      if (_volume.value == 0) {
        _volume.value = 50;
        await controller.setVolume(50);
      }
    } catch (error) {
      _log('mute toggle failed: $error');
    }
  }

  Future<void> _setVolume(int requested) async {
    final controller = _controller;

    if (controller == null || !_isPlayerUsable()) return;

    final volume = requested.clamp(0, 100).toInt();

    _volume.value = volume;

    try {
      if (volume == 0) {
        _muted.value = true;
        await controller.mute();
        return;
      }

      if (_muted.value) {
        _muted.value = false;
        await controller.unMute();
      }

      await controller.setVolume(volume);
    } catch (error) {
      _log('volume change failed: $error');
    }
  }

  // -------------------------------------------------------------------------
  // Slider
  // -------------------------------------------------------------------------

  double _safeFraction(double value) {
    if (value.isNaN || value.isInfinite) return 0;

    return value.clamp(0.0, 1.0).toDouble();
  }

  void _syncSliderFromPosition() {
    if (_isDragging.value) return;

    final total = _duration.value.inMilliseconds;

    if (total <= 0) {
      _slider.value = 0;
      return;
    }

    _slider.value = _safeFraction(_position.value.inMilliseconds / total);
  }

  void _applySliderPreview(double value) {
    final fraction = _safeFraction(value);

    _slider.value = fraction;
    _position.value = Duration(
      milliseconds: (_duration.value.inMilliseconds * fraction).round(),
    );
  }

  void _handleSliderStart(double value) {
    _isDragging.value = true;
    _cancelControlsTimer();
    _applySliderPreview(value);
  }

  void _handleSliderChanged(double value) {
    _applySliderPreview(value);
  }

  void _handleSliderEnd(double value) {
    final fraction = _safeFraction(value);

    _isDragging.value = false;

    unawaited(_seekToFraction(fraction));

    _showControlsNow();
  }

  // -------------------------------------------------------------------------
  // Controls visibility
  // -------------------------------------------------------------------------

  void _toggleControls() {
    if (_showControls.value) {
      // Controls stay visible while paused / buffering / ended.
      if (_playerState.value == PlayerState.playing) {
        _cancelControlsTimer();
        _showControls.value = false;
      }

      return;
    }

    _showControlsNow();
  }

  void _showControlsNow() {
    _showControls.value = true;
    _scheduleControlsHide();
  }

  void _scheduleControlsHide() {
    _cancelControlsTimer();

    if (_playerState.value != PlayerState.playing) return;
    if (_isDragging.value || _speedMenuOpen.value) return;

    _controlsTimer = Timer(_kControlsHideDelay, () {
      if (!mounted || _disposed) return;
      if (_playerState.value != PlayerState.playing) return;
      if (_isDragging.value || _speedMenuOpen.value) return;

      _showControls.value = false;
    });
  }

  void _cancelControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = null;
  }

  void _handlePointerActivity() {
    if (_error.value != null || _playerState.value == PlayerState.unknown) {
      return;
    }

    if (!_showControls.value) {
      _showControls.value = true;
    }

    _scheduleControlsHide();
  }

  void _handleSurfaceTap(PointerDeviceKind kind) {
    _focusNode.requestFocus();

    if (_speedMenuOpen.value) {
      _closeSpeedMenu();
      return;
    }

    if (kind == PointerDeviceKind.mouse) {
      // Desktop: a click toggles play/pause, like YouTube itself.
      unawaited(_togglePlayPause());
      _showControlsNow();
      return;
    }

    // Touch: a tap only shows/hides the controls (same as the mobile player).
    _toggleControls();
  }

  void _toggleSpeedMenu() {
    final open = !_speedMenuOpen.value;

    _speedMenuOpen.value = open;

    if (open) {
      _cancelControlsTimer();
      _showControls.value = true;
    } else {
      _scheduleControlsHide();
    }
  }

  void _closeSpeedMenu() {
    _speedMenuOpen.value = false;
    _scheduleControlsHide();
  }

  void _showSeekFeedback(String value) {
    _feedbackTimer?.cancel();
    _seekFeedback.value = value;

    _feedbackTimer = Timer(const Duration(milliseconds: 650), () {
      if (!mounted || _disposed) return;
      _seekFeedback.value = null;
    });
  }

  void _cancelFeedbackTimer() {
    _feedbackTimer?.cancel();
    _feedbackTimer = null;
  }

  // -------------------------------------------------------------------------
  // Retry
  // -------------------------------------------------------------------------

  void _retry() {
    _startPlayer(
      startAt: _position.value,
      autoPlay: false,
      restoreSettings: true,
    );

    setState(() {});
  }

  // -------------------------------------------------------------------------
  // Fullscreen
  //
  // The controls are Flutter widgets, so the iframe cannot be fullscreened on
  // its own (the controls would stay behind). Instead the whole page goes
  // fullscreen and a second player is created at the same position. Moving an
  // iframe between places in the DOM reloads it anyway, so re-creating the
  // player is the reliable way to do it.
  // -------------------------------------------------------------------------

  Future<void> _toggleFullscreen() async {
    if (widget.isFullscreenPage) {
      _exitFullscreenPage();
      return;
    }

    await _enterFullscreenPage();
  }

  _PlayerHandoff _captureHandoff() {
    return _PlayerHandoff(
      position: _position.value,
      wasPlaying: _isPlayingLike(_playerState.value),
      playbackRate: _playbackRate.value,
      volume: _volume.value,
      muted: _muted.value,
    );
  }

  Future<void> _enterFullscreenPage() async {
    if (_suspendedForFullscreen || !_isPlayerUsable()) return;

    // Must be called synchronously inside the user's click.
    unawaited(enterBrowserFullscreen());

    final handoff = _captureHandoff();
    final navigator = Navigator.of(context, rootNavigator: true);
    final videoUrl = widget.videoUrl;
    final controlsOverVideo = widget.controlsOverVideo;

    _teardownPlayer();

    setState(() {
      _suspendedForFullscreen = true;
    });

    final result = await navigator.push<_FullscreenResult>(
      PageRouteBuilder<_FullscreenResult>(
        opaque: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: _WebPlayerCore(
              videoUrl: videoUrl,
              controlsOverVideo: controlsOverVideo,
              handoff: handoff,
              isFullscreenPage: true,
            ),
          );
        },
      ),
    );

    unawaited(exitBrowserFullscreen());

    if (!mounted || _disposed) return;

    final restored = result?.handoff ?? handoff;

    _playbackRate.value = restored.playbackRate;
    _volume.value = restored.volume;
    _muted.value = restored.muted;

    _suspendedForFullscreen = false;

    _startPlayer(
      startAt: restored.position,
      autoPlay: restored.wasPlaying,
      restoreSettings: true,
    );

    setState(() {});

    if (result?.completed ?? false) {
      _emitCompletion();
    }
  }

  void _exitFullscreenPage({bool completed = false}) {
    if (!widget.isFullscreenPage || _exiting) return;

    _exiting = true;

    Navigator.of(
      context,
    ).pop(_FullscreenResult(handoff: _captureHandoff(), completed: completed));
  }

  void _handleBrowserFullscreenChange(bool isFullscreen) {
    if (!widget.isFullscreenPage || _disposed) return;

    if (isFullscreen) {
      _sawBrowserFullscreen = true;
      return;
    }

    // The user left browser fullscreen (Esc / browser UI): close our page too.
    if (_sawBrowserFullscreen) {
      _exitFullscreenPage();
    }
  }

  // -------------------------------------------------------------------------
  // Keyboard (desktop)
  // -------------------------------------------------------------------------

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowLeft) {
      unawaited(_seekRelative(-5));
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowRight) {
      unawaited(_seekRelative(5));
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowUp) {
      unawaited(_setVolume(_effectiveVolume + 10));
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      unawaited(_setVolume(_effectiveVolume - 10));
      return KeyEventResult.handled;
    }

    if (event is KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.keyK) {
      unawaited(_togglePlayPause());
      _showControlsNow();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.keyJ) {
      unawaited(_seekRelative(-_kSeekStep));
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.keyL) {
      unawaited(_seekRelative(_kSeekStep));
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.keyM) {
      unawaited(_toggleMute());
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.keyF) {
      unawaited(_toggleFullscreen());
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape && widget.isFullscreenPage) {
      _exitFullscreenPage();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    Widget body = widget.isFullscreenPage
        ? _buildFullscreenBody()
        : _buildInlineBody();

    body = Focus(
      focusNode: _focusNode,
      autofocus: widget.isFullscreenPage,
      onKeyEvent: _handleKeyEvent,
      child: body,
    );

    if (widget.isFullscreenPage) {
      body = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _exitFullscreenPage();
          }
        },
        child: body,
      );
    }

    return body;
  }

  Widget _buildInlineBody() {
    if (_suspendedForFullscreen) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const Text(
            'Playing in fullscreen',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    if (!widget.controlsOverVideo) {
      return _buildBelowLayout(fullscreen: false);
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(color: Colors.black, child: _buildPlayerStack()),
    );
  }

  Widget _buildFullscreenBody() {
    final Widget content;

    if (widget.controlsOverVideo) {
      content = Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(color: Colors.black, child: _buildPlayerStack()),
        ),
      );
    } else {
      content = _buildBelowLayout(fullscreen: true);
    }

    return ColoredBox(color: Colors.black, child: content);
  }

  /// Control bar under the video, nothing drawn over the iframe.
  Widget _buildBelowLayout({required bool fullscreen}) {
    final video = AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(color: Colors.black, child: _buildPlayerStack()),
    );

    final bar = ColoredBox(
      color: const Color(0xFF101010),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _Metrics(constraints.maxWidth);

            return ValueListenableBuilder<PlayerState>(
              valueListenable: _playerState,
              builder: (context, state, _) {
                return _buildControlBar(state, metrics, includeTransport: true);
              },
            );
          },
        ),
      ),
    );

    if (fullscreen) {
      return Column(
        children: <Widget>[
          Expanded(child: Center(child: video)),
          bar,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[video, bar],
    );
  }

  Widget _buildPlayerStack() {
    final controller = _controller;

    if (controller == null) {
      return _buildNoControllerState();
    }

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        YoutubePlayer(
          // A new controller must always get a new State, even for the same
          // video id (fullscreen re-creates the player).
          key: ObjectKey(controller),
          controller: controller,
          aspectRatio: 16 / 9,
          autoFullScreen: false,
          enableFullScreenOnVerticalDrag: false,
          keepAlive: false,
          thumbnailQuality: ThumbnailQuality.high,
          thumbnailFormat: ThumbnailFormat.webp,
        ),
        Positioned.fill(
          child: widget.controlsOverVideo
              ? _buildOverlay()
              : _buildStatusLayer(),
        ),
      ],
    );
  }

  Widget _buildNoControllerState() {
    return ValueListenableBuilder<String?>(
      valueListenable: _error,
      builder: (context, error, _) {
        if (error != null) {
          return _buildErrorState(error);
        }

        return _buildLoading();
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
      ),
    );
  }

  /// Below-video mode: only loading/error are drawn over the iframe.
  Widget _buildStatusLayer() {
    return ValueListenableBuilder<String?>(
      valueListenable: _error,
      builder: (context, error, _) {
        if (error != null) {
          return PointerInterceptor(
            child: SizedBox.expand(
              child: ColoredBox(
                color: Colors.black,
                child: _buildErrorState(error),
              ),
            ),
          );
        }

        return ValueListenableBuilder<PlayerState>(
          valueListenable: _playerState,
          builder: (context, state, _) {
            if (state != PlayerState.unknown) {
              return const SizedBox.shrink();
            }

            return IgnorePointer(child: _buildLoading());
          },
        );
      },
    );
  }

  /// Overlay mode. ONE PointerInterceptor covers the whole player, so every
  /// click/tap/hover lands on a normal DOM element (not on the iframe) and is
  /// delivered to the Flutter widgets drawn above it.
  Widget _buildOverlay() {
    return PointerInterceptor(
      child: SizedBox.expand(
        child: MouseRegion(
          onHover: (_) => _handlePointerActivity(),
          child: ValueListenableBuilder<String?>(
            valueListenable: _error,
            builder: (context, error, _) {
              if (error != null) {
                return _buildErrorState(error);
              }

              return ValueListenableBuilder<PlayerState>(
                valueListenable: _playerState,
                builder: (context, state, _) {
                  if (state == PlayerState.unknown) {
                    return _buildLoading();
                  }

                  return _buildControlLayers(state);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildControlLayers(PlayerState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _Metrics(constraints.maxWidth);

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            _buildGestureLayer(),
            _buildBottomGradient(),
            _buildCenterControls(state, metrics),
            _buildBottomBar(state, metrics),
            _buildBufferingIndicator(state),
            _buildSeekFeedback(),
            _buildSpeedMenu(constraints.maxHeight),
          ],
        );
      },
    );
  }

  Widget _buildGestureLayer() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
      builder: (context, visible, _) {
        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: visible ? _kBarHeight : 0,
          child: Row(
            children: <Widget>[
              _buildTapZone(
                onDoubleTap: () {
                  unawaited(_seekRelative(-_kSeekStep));
                },
              ),
              _buildTapZone(
                onDoubleTap: () {
                  unawaited(_toggleFullscreen());
                },
              ),
              _buildTapZone(
                onDoubleTap: () {
                  unawaited(_seekRelative(_kSeekStep));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTapZone({required VoidCallback onDoubleTap}) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => _handleSurfaceTap(details.kind),
        onDoubleTap: onDoubleTap,
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildBottomGradient() {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
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
                  colors: <Color>[
                    Colors.black.withValues(alpha: 0.88),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.transparent,
                  ],
                  stops: const <double>[0, 0.55, 1],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterControls(PlayerState state, _Metrics metrics) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: _kBarHeight,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildCircleButton(
                  icon: Icons.replay_10_rounded,
                  tooltip: 'Back 10 seconds',
                  size: metrics.seekSize,
                  iconSize: metrics.seekIcon,
                  onPressed: () {
                    unawaited(_seekRelative(-_kSeekStep));
                  },
                ),
                SizedBox(width: metrics.centerGap),
                _buildPlayButton(state, metrics),
                SizedBox(width: metrics.centerGap),
                _buildCircleButton(
                  icon: Icons.forward_10_rounded,
                  tooltip: 'Forward 10 seconds',
                  size: metrics.seekSize,
                  iconSize: metrics.seekIcon,
                  onPressed: () {
                    unawaited(_seekRelative(_kSeekStep));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlayButton(PlayerState state, _Metrics metrics) {
    final isBuffering = state == PlayerState.buffering;
    final isPlaying = _isPlayingLike(state);

    final IconData icon;

    if (state == PlayerState.ended) {
      icon = Icons.replay_rounded;
    } else if (isPlaying) {
      icon = Icons.pause_rounded;
    } else {
      icon = Icons.play_arrow_rounded;
    }

    return Tooltip(
      message: isPlaying ? 'Pause' : 'Play',
      child: Material(
        color: Colors.black.withValues(alpha: 0.62),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            unawaited(_togglePlayPause());
            _showControlsNow();
          },
          child: SizedBox(
            width: metrics.playSize,
            height: metrics.playSize,
            child: isBuffering
                ? Padding(
                    padding: EdgeInsets.all(metrics.playSize * 0.28),
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Icon(icon, color: Colors.white, size: metrics.playIcon),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required String tooltip,
    required double size,
    required double iconSize,
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
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(PlayerState state, _Metrics metrics) {
    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
      builder: (context, visible, _) {
        if (!visible) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: metrics.sidePadding,
          right: metrics.sidePadding,
          bottom: 7,
          height: _kBarHeight - 10,
          child: _buildControlBar(state, metrics, includeTransport: false),
        );
      },
    );
  }

  /// Slider + row of buttons. Shared by the overlay and the below-video layout.
  Widget _buildControlBar(
    PlayerState state,
    _Metrics metrics, {
    required bool includeTransport,
  }) {
    final usable = state != PlayerState.unknown;
    final isPlaying = _isPlayingLike(state);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildSlider(usable),
        Row(
          children: <Widget>[
            if (includeTransport) ...<Widget>[
              _buildBarIconButton(
                metrics: metrics,
                icon: isPlaying
                    ? Icons.pause_rounded
                    : (state == PlayerState.ended
                          ? Icons.replay_rounded
                          : Icons.play_arrow_rounded),
                tooltip: isPlaying ? 'Pause' : 'Play',
                onPressed: usable ? () => unawaited(_togglePlayPause()) : null,
              ),
              _buildBarIconButton(
                metrics: metrics,
                icon: Icons.replay_10_rounded,
                tooltip: 'Back 10 seconds',
                onPressed: usable
                    ? () => unawaited(_seekRelative(-_kSeekStep))
                    : null,
              ),
              _buildBarIconButton(
                metrics: metrics,
                icon: Icons.forward_10_rounded,
                tooltip: 'Forward 10 seconds',
                onPressed: usable
                    ? () => unawaited(_seekRelative(_kSeekStep))
                    : null,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: _buildTimeLabel(metrics),
              ),
            ),
            const Spacer(),
            _buildVolumeControl(metrics, usable),
            const SizedBox(width: 4),
            _buildSpeedButton(usable),
            const SizedBox(width: 4),
            _buildBarIconButton(
              metrics: metrics,
              icon: widget.isFullscreenPage
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
              tooltip: widget.isFullscreenPage
                  ? 'Exit fullscreen'
                  : 'Fullscreen',
              onPressed: usable ? () => unawaited(_toggleFullscreen()) : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBarIconButton({
    required _Metrics metrics,
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: metrics.iconSize,
      color: Colors.white,
      disabledColor: Colors.white38,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
    );
  }

  SliderThemeData _sliderTheme(BuildContext context, {required bool thin}) {
    return SliderTheme.of(context).copyWith(
      trackHeight: thin ? 2.5 : 3,
      trackShape: const RoundedRectSliderTrackShape(),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: thin ? 5 : 6),
      overlayShape: RoundSliderOverlayShape(overlayRadius: thin ? 12 : 15),
      activeTrackColor: Colors.white,
      inactiveTrackColor: Colors.white38,
      secondaryActiveTrackColor: Colors.white54,
      thumbColor: Colors.white,
      overlayColor: Colors.white24,
    );
  }

  Widget _buildSlider(bool usable) {
    return ValueListenableBuilder<double>(
      valueListenable: _slider,
      builder: (context, value, _) {
        return ValueListenableBuilder<double>(
          valueListenable: _buffered,
          builder: (context, buffered, _) {
            final enabled = usable && _duration.value > Duration.zero;

            return SizedBox(
              height: 34,
              child: SliderTheme(
                data: _sliderTheme(context, thin: false),
                child: Slider(
                  value: _safeFraction(value),
                  secondaryTrackValue: _safeFraction(buffered),
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
      },
    );
  }

  Widget _buildTimeLabel(_Metrics metrics) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_position, _duration]),
      builder: (context, _) {
        return Text(
          '${_formatDuration(_position.value)} / '
          '${_formatDuration(_duration.value)}',
          style: TextStyle(
            color: Colors.white,
            fontSize: metrics.labelSize,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }

  Widget _buildVolumeControl(_Metrics metrics, bool usable) {
    return ValueListenableBuilder<bool>(
      valueListenable: _muted,
      builder: (context, muted, _) {
        return ValueListenableBuilder<int>(
          valueListenable: _volume,
          builder: (context, volume, _) {
            final effective = muted ? 0 : volume;

            final IconData icon;

            if (effective == 0) {
              icon = Icons.volume_off_rounded;
            } else if (effective < 50) {
              icon = Icons.volume_down_rounded;
            } else {
              icon = Icons.volume_up_rounded;
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildBarIconButton(
                  metrics: metrics,
                  icon: icon,
                  tooltip: effective == 0 ? 'Unmute' : 'Mute',
                  onPressed: usable ? () => unawaited(_toggleMute()) : null,
                ),
                if (metrics.showVolumeSlider)
                  SizedBox(
                    width: 92,
                    height: 32,
                    child: SliderTheme(
                      data: _sliderTheme(context, thin: true),
                      child: Slider(
                        value: effective / 100,
                        min: 0,
                        max: 1,
                        onChanged: usable
                            ? (value) {
                                unawaited(_setVolume((value * 100).round()));
                              }
                            : null,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSpeedButton(bool usable) {
    return ValueListenableBuilder<double>(
      valueListenable: _playbackRate,
      builder: (context, rate, _) {
        return Tooltip(
          message: 'Playback speed',
          child: Material(
            color: Colors.black.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: usable
                  ? (widget.controlsOverVideo ? _toggleSpeedMenu : _cycleSpeed)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: Text(
                  '${_formatPlaybackRate(rate)}x',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Speed menu drawn inside the overlay (a normal PopupMenu would be a Flutter
  /// route above the iframe and would not receive clicks on web).
  Widget _buildSpeedMenu(double availableHeight) {
    return ValueListenableBuilder<bool>(
      valueListenable: _speedMenuOpen,
      builder: (context, open, _) {
        if (!open) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _closeSpeedMenu,
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: availableHeight > 40
                          ? availableHeight - 24
                          : availableHeight,
                    ),
                    child: _buildSpeedPanel(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSpeedPanel() {
    return ValueListenableBuilder<double>(
      valueListenable: _playbackRate,
      builder: (context, rate, _) {
        return Material(
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final item in _kPlaybackRates)
                  InkWell(
                    onTap: () {
                      unawaited(_changePlaybackRate(item));
                      _closeSpeedMenu();
                    },
                    child: Container(
                      width: 118,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${_formatPlaybackRate(item)}x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: item == rate
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                          if (item == rate)
                            const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBufferingIndicator(PlayerState state) {
    if (state != PlayerState.buffering) {
      return const SizedBox.shrink();
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _showControls,
      builder: (context, visible, _) {
        // While the controls are visible the play button shows the spinner.
        if (visible) {
          return const SizedBox.shrink();
        }

        return const Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSeekFeedback() {
    return ValueListenableBuilder<String?>(
      valueListenable: _seekFeedback,
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
                  key: ValueKey<String>(feedback),
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
                    children: <Widget>[
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
    final canRetry = _extractVideoId(widget.videoUrl) != null;

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
            children: <Widget>[
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
              if (canRetry) ...<Widget>[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try again'),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  void _log(String message) {
    if (kDebugMode) {
      debugPrint('[WebSecureVideoPlayer] $message');
    }
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
}
