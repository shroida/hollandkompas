// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_user_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoriteVocabularyWords)
final favoriteVocabularyWordsProvider = FavoriteVocabularyWordsProvider._();

final class FavoriteVocabularyWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VocabularyWord>>,
          List<VocabularyWord>,
          FutureOr<List<VocabularyWord>>
        >
    with
        $FutureModifier<List<VocabularyWord>>,
        $FutureProvider<List<VocabularyWord>> {
  FavoriteVocabularyWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoriteVocabularyWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoriteVocabularyWordsHash();

  @$internal
  @override
  $FutureProviderElement<List<VocabularyWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VocabularyWord>> create(Ref ref) {
    return favoriteVocabularyWords(ref);
  }
}

String _$favoriteVocabularyWordsHash() =>
    r'8f7ce6d9c3cbf3e56811b4e320176e5034f3302e';

@ProviderFor(vocabularyProgressStats)
final vocabularyProgressStatsProvider = VocabularyProgressStatsProvider._();

final class VocabularyProgressStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabularyStats>,
          VocabularyStats,
          FutureOr<VocabularyStats>
        >
    with $FutureModifier<VocabularyStats>, $FutureProvider<VocabularyStats> {
  VocabularyProgressStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyProgressStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyProgressStatsHash();

  @$internal
  @override
  $FutureProviderElement<VocabularyStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VocabularyStats> create(Ref ref) {
    return vocabularyProgressStats(ref);
  }
}

String _$vocabularyProgressStatsHash() =>
    r'0886e60ca8096b6261958f114a436ca682b49da7';

@ProviderFor(VocabularyActions)
final vocabularyActionsProvider = VocabularyActionsProvider._();

final class VocabularyActionsProvider
    extends $NotifierProvider<VocabularyActions, void> {
  VocabularyActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyActionsHash();

  @$internal
  @override
  VocabularyActions create() => VocabularyActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$vocabularyActionsHash() => r'6e42f3d5e61ffd3d0bb817203249d597e82ba869';

abstract class _$VocabularyActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
