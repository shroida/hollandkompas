// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedVocabularyLevel)
final selectedVocabularyLevelProvider = SelectedVocabularyLevelProvider._();

final class SelectedVocabularyLevelProvider
    extends $NotifierProvider<SelectedVocabularyLevel, String?> {
  SelectedVocabularyLevelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedVocabularyLevelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedVocabularyLevelHash();

  @$internal
  @override
  SelectedVocabularyLevel create() => SelectedVocabularyLevel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedVocabularyLevelHash() =>
    r'51cbf1c53684b586233047fb1a7d4ec46d1b843a';

abstract class _$SelectedVocabularyLevel extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedVocabularyCategory)
final selectedVocabularyCategoryProvider =
    SelectedVocabularyCategoryProvider._();

final class SelectedVocabularyCategoryProvider
    extends $NotifierProvider<SelectedVocabularyCategory, String?> {
  SelectedVocabularyCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedVocabularyCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedVocabularyCategoryHash();

  @$internal
  @override
  SelectedVocabularyCategory create() => SelectedVocabularyCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedVocabularyCategoryHash() =>
    r'b98b19c77dd1250a45ab2d6fad6eecbf14e543cb';

abstract class _$SelectedVocabularyCategory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(vocabularyWords)
final vocabularyWordsProvider = VocabularyWordsProvider._();

final class VocabularyWordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VocabularyWord>>,
          List<VocabularyWord>,
          FutureOr<List<VocabularyWord>>
        >
    with
        $FutureModifier<List<VocabularyWord>>,
        $FutureProvider<List<VocabularyWord>> {
  VocabularyWordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyWordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyWordsHash();

  @$internal
  @override
  $FutureProviderElement<List<VocabularyWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VocabularyWord>> create(Ref ref) {
    return vocabularyWords(ref);
  }
}

String _$vocabularyWordsHash() => r'a6124cce2094b31e99b8c5487469a5d6cf605bd2';

@ProviderFor(VocabularySearchQuery)
final vocabularySearchQueryProvider = VocabularySearchQueryProvider._();

final class VocabularySearchQueryProvider
    extends $NotifierProvider<VocabularySearchQuery, String> {
  VocabularySearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularySearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularySearchQueryHash();

  @$internal
  @override
  VocabularySearchQuery create() => VocabularySearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$vocabularySearchQueryHash() =>
    r'610607d1dd7eabb1e6339cc88a8cc8424fcb667e';

abstract class _$VocabularySearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(vocabularySearchResults)
final vocabularySearchResultsProvider = VocabularySearchResultsProvider._();

final class VocabularySearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VocabularyWord>>,
          List<VocabularyWord>,
          FutureOr<List<VocabularyWord>>
        >
    with
        $FutureModifier<List<VocabularyWord>>,
        $FutureProvider<List<VocabularyWord>> {
  VocabularySearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularySearchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularySearchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<VocabularyWord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VocabularyWord>> create(Ref ref) {
    return vocabularySearchResults(ref);
  }
}

String _$vocabularySearchResultsHash() =>
    r'd5b310bb58be13004ac163ef4763e6cd2c3415b4';

@ProviderFor(dailyVocabularyWord)
final dailyVocabularyWordProvider = DailyVocabularyWordProvider._();

final class DailyVocabularyWordProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabularyWord>,
          VocabularyWord,
          FutureOr<VocabularyWord>
        >
    with $FutureModifier<VocabularyWord>, $FutureProvider<VocabularyWord> {
  DailyVocabularyWordProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyVocabularyWordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyVocabularyWordHash();

  @$internal
  @override
  $FutureProviderElement<VocabularyWord> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VocabularyWord> create(Ref ref) {
    return dailyVocabularyWord(ref);
  }
}

String _$dailyVocabularyWordHash() =>
    r'2998bb5ea4ca971abc5f07819b21a2a8a7af373c';

@ProviderFor(vocabularyWordById)
final vocabularyWordByIdProvider = VocabularyWordByIdFamily._();

final class VocabularyWordByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabularyWord>,
          VocabularyWord,
          FutureOr<VocabularyWord>
        >
    with $FutureModifier<VocabularyWord>, $FutureProvider<VocabularyWord> {
  VocabularyWordByIdProvider._({
    required VocabularyWordByIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'vocabularyWordByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$vocabularyWordByIdHash();

  @override
  String toString() {
    return r'vocabularyWordByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VocabularyWord> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<VocabularyWord> create(Ref ref) {
    final argument = this.argument as String;
    return vocabularyWordById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VocabularyWordByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$vocabularyWordByIdHash() =>
    r'04674ad4d36960e296be2001afe6269699af1dd6';

final class VocabularyWordByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VocabularyWord>, String> {
  VocabularyWordByIdFamily._()
    : super(
        retry: null,
        name: r'vocabularyWordByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VocabularyWordByIdProvider call(String id) =>
      VocabularyWordByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'vocabularyWordByIdProvider';
}
