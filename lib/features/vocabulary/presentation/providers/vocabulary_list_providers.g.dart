// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Selected level filter on the Vocabulary Database screen.
/// `null` = all levels.

@ProviderFor(SelectedVocabularyLevel)
final selectedVocabularyLevelProvider = SelectedVocabularyLevelProvider._();

/// Selected level filter on the Vocabulary Database screen.
/// `null` = all levels.
final class SelectedVocabularyLevelProvider
    extends $NotifierProvider<SelectedVocabularyLevel, VocabularyLevel?> {
  /// Selected level filter on the Vocabulary Database screen.
  /// `null` = all levels.
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
  Override overrideWithValue(VocabularyLevel? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabularyLevel?>(value),
    );
  }
}

String _$selectedVocabularyLevelHash() =>
    r'd3f904a9277185d3570a10cb246b67a80f8b229b';

/// Selected level filter on the Vocabulary Database screen.
/// `null` = all levels.

abstract class _$SelectedVocabularyLevel extends $Notifier<VocabularyLevel?> {
  VocabularyLevel? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VocabularyLevel?, VocabularyLevel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VocabularyLevel?, VocabularyLevel?>,
              VocabularyLevel?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Selected topic filter on the Vocabulary Database / Categories screen.
/// `null` = all categories.

@ProviderFor(SelectedVocabularyCategory)
final selectedVocabularyCategoryProvider =
    SelectedVocabularyCategoryProvider._();

/// Selected topic filter on the Vocabulary Database / Categories screen.
/// `null` = all categories.
final class SelectedVocabularyCategoryProvider
    extends $NotifierProvider<SelectedVocabularyCategory, VocabularyCategory?> {
  /// Selected topic filter on the Vocabulary Database / Categories screen.
  /// `null` = all categories.
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
  Override overrideWithValue(VocabularyCategory? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabularyCategory?>(value),
    );
  }
}

String _$selectedVocabularyCategoryHash() =>
    r'a6a3ad0e6e22c244ebd9aa5ab538efd0ffe84dc1';

/// Selected topic filter on the Vocabulary Database / Categories screen.
/// `null` = all categories.

abstract class _$SelectedVocabularyCategory
    extends $Notifier<VocabularyCategory?> {
  VocabularyCategory? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<VocabularyCategory?, VocabularyCategory?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<VocabularyCategory?, VocabularyCategory?>,
              VocabularyCategory?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Word list for the current filter selection above.

@ProviderFor(vocabularyWords)
final vocabularyWordsProvider = VocabularyWordsProvider._();

/// Word list for the current filter selection above.

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
  /// Word list for the current filter selection above.
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

/// Live text typed into the Vocabulary Search screen.

@ProviderFor(VocabularySearchQuery)
final vocabularySearchQueryProvider = VocabularySearchQueryProvider._();

/// Live text typed into the Vocabulary Search screen.
final class VocabularySearchQueryProvider
    extends $NotifierProvider<VocabularySearchQuery, String> {
  /// Live text typed into the Vocabulary Search screen.
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
    r'92d79c6ad19588227c0d58261818d230982d3b7c';

/// Live text typed into the Vocabulary Search screen.

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
    r'3ba8df3dd1fa698be9a12c4287350fc8897ae326';

/// Today's word of the day.

@ProviderFor(dailyVocabularyWord)
final dailyVocabularyWordProvider = DailyVocabularyWordProvider._();

/// Today's word of the day.

final class DailyVocabularyWordProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabularyWord>,
          VocabularyWord,
          FutureOr<VocabularyWord>
        >
    with $FutureModifier<VocabularyWord>, $FutureProvider<VocabularyWord> {
  /// Today's word of the day.
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

/// A single word by id, kept live so the details screen reflects
/// favorite/progress changes without a manual refresh.

@ProviderFor(vocabularyWordById)
final vocabularyWordByIdProvider = VocabularyWordByIdFamily._();

/// A single word by id, kept live so the details screen reflects
/// favorite/progress changes without a manual refresh.

final class VocabularyWordByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<VocabularyWord>,
          VocabularyWord,
          FutureOr<VocabularyWord>
        >
    with $FutureModifier<VocabularyWord>, $FutureProvider<VocabularyWord> {
  /// A single word by id, kept live so the details screen reflects
  /// favorite/progress changes without a manual refresh.
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

/// A single word by id, kept live so the details screen reflects
/// favorite/progress changes without a manual refresh.

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

  /// A single word by id, kept live so the details screen reflects
  /// favorite/progress changes without a manual refresh.

  VocabularyWordByIdProvider call(String id) =>
      VocabularyWordByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'vocabularyWordByIdProvider';
}
