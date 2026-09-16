import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'tts_service.dart';

/// The app's single Dutch (nl-NL) text-to-speech engine.
///
/// This wraps exactly one [FlutterTts] instance. Every place that needs
/// to speak Dutch — vocabulary words, example sentences, Dutch text
/// inside a lesson, a future pronunciation button anywhere else in the
/// app — should go through this class instead of creating its own
/// `FlutterTts()`. In practice that means: never construct this class
/// directly in a widget. Read it from `ttsServiceProvider`
/// (see tts_providers.dart), which keeps exactly one instance alive
/// for the whole app session.
class DutchTtsService implements TtsService {
  DutchTtsService() {
    _init();
  }

  static const String _language = 'nl-NL';
  static const double _speechRate = 0.45;
  static const double _pitch = 1.0;
  static const double _volume = 1.0;

  final FlutterTts _flutterTts = FlutterTts();

  bool _isInitialized = false;
  bool _isSpeaking = false;
  String? _lastText;

  Future<void> _init() async {
    try {
      await _flutterTts.setLanguage(_language);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.setVolume(_volume);

      _flutterTts.setStartHandler(() => _isSpeaking = true);
      _flutterTts.setCompletionHandler(() => _isSpeaking = false);
      _flutterTts.setCancelHandler(() => _isSpeaking = false);
      _flutterTts.setErrorHandler((message) {
        _isSpeaking = false;
        debugPrint('DutchTtsService error: $message');
      });

      _isInitialized = true;
    } catch (error) {
      // Don't crash the app if a platform has no TTS engine installed —
      // speak()/pause()/resume() below all degrade to safe no-ops.
      _isInitialized = false;
      debugPrint('DutchTtsService failed to initialize: $error');
    }
  }

  @override
  bool get isSpeaking => _isSpeaking;

  @override
  Future<void> speak(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    try {
      if (!_isInitialized) {
        await _init();
        if (!_isInitialized) return;
      }
      // Always stop whatever is currently playing before starting the
      // next word/sentence, so taps never queue up or overlap.
      if (_isSpeaking) {
        await stop();
      }
      _lastText = trimmed;
      await _flutterTts.speak(trimmed);
    } catch (error) {
      _isSpeaking = false;
      debugPrint('DutchTtsService.speak failed: $error');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (error) {
      debugPrint('DutchTtsService.stop failed: $error');
    } finally {
      _isSpeaking = false;
    }
  }

  @override
  Future<void> pause() async {
    // Supported on Android (SDK 26+, via an internal range-tracking
    // workaround since Android TTS has no native pause), iOS, macOS
    // and Web. Wrapped in try/catch so an unsupported platform just
    // silently fails instead of throwing into the caller.
    try {
      await _flutterTts.pause();
    } catch (error) {
      debugPrint('DutchTtsService.pause not available here: $error');
    }
  }

  @override
  Future<void> resume() async {
    // flutter_tts has no dedicated cross-platform "resume" call. Where
    // pause() is supported, the engine remembers the paused position
    // internally and continues from there the next time speak() is
    // invoked — so "resume" here means re-issuing the last text rather
    // than exposing a method that doesn't exist on the package.
    if (_isSpeaking || _lastText == null) return;
    try {
      await _flutterTts.speak(_lastText!);
    } catch (error) {
      debugPrint('DutchTtsService.resume failed: $error');
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
  }
}
