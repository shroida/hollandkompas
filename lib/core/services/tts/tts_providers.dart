import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dutch_tts_service.dart';
import 'tts_service.dart';

part 'tts_providers.g.dart';

/// The single, app-wide TTS instance.
///
/// `keepAlive: true` means it is built once and survives for the whole
/// app session instead of being disposed when the last screen watching
/// it goes away — which is the whole point: one `FlutterTts`, reused
/// everywhere, instead of a new one per widget.
@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  final service = DutchTtsService();
  ref.onDispose(service.dispose);
  return service;
}
