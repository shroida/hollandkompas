/// Abstract contract for a text-to-speech service.
///
/// Screens and widgets should depend on this type — not on
/// [DutchTtsService] or `FlutterTts` directly — so the UI stays
/// testable (mock this interface in widget tests) and the concrete
/// engine can be swapped later without touching any screen.
abstract class TtsService {
  /// Speaks [text]. Stops any speech currently in progress first.
  Future<void> speak(String text);

  /// Stops the current speech immediately.
  Future<void> stop();

  /// Pauses the current speech, where the platform supports it.
  Future<void> pause();

  /// Resumes speech after [pause], where the platform supports it.
  Future<void> resume();

  /// True while speech is actively playing.
  bool get isSpeaking;

  /// Releases the underlying engine. Called once from the provider's
  /// `ref.onDispose` — do not call this from UI code.
  void dispose();
}
