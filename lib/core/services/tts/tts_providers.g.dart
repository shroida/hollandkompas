// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tts_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single, app-wide TTS instance.
///
/// `keepAlive: true` means it is built once and survives for the whole
/// app session instead of being disposed when the last screen watching
/// it goes away — which is the whole point: one `FlutterTts`, reused
/// everywhere, instead of a new one per widget.

@ProviderFor(ttsService)
final ttsServiceProvider = TtsServiceProvider._();

/// The single, app-wide TTS instance.
///
/// `keepAlive: true` means it is built once and survives for the whole
/// app session instead of being disposed when the last screen watching
/// it goes away — which is the whole point: one `FlutterTts`, reused
/// everywhere, instead of a new one per widget.

final class TtsServiceProvider
    extends $FunctionalProvider<TtsService, TtsService, TtsService>
    with $Provider<TtsService> {
  /// The single, app-wide TTS instance.
  ///
  /// `keepAlive: true` means it is built once and survives for the whole
  /// app session instead of being disposed when the last screen watching
  /// it goes away — which is the whole point: one `FlutterTts`, reused
  /// everywhere, instead of a new one per widget.
  TtsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ttsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ttsServiceHash();

  @$internal
  @override
  $ProviderElement<TtsService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TtsService create(Ref ref) {
    return ttsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TtsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TtsService>(value),
    );
  }
}

String _$ttsServiceHash() => r'a633b3565f8e12e6ded950ce6ff09acb9a2f0f06';
