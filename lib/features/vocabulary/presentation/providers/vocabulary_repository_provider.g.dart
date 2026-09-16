// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocabulary_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(vocabularyRemoteDataSource)
final vocabularyRemoteDataSourceProvider =
    VocabularyRemoteDataSourceProvider._();

final class VocabularyRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          VocabularyRemoteDataSource,
          VocabularyRemoteDataSource,
          VocabularyRemoteDataSource
        >
    with $Provider<VocabularyRemoteDataSource> {
  VocabularyRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<VocabularyRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VocabularyRemoteDataSource create(Ref ref) {
    return vocabularyRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabularyRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabularyRemoteDataSource>(value),
    );
  }
}

String _$vocabularyRemoteDataSourceHash() =>
    r'1f3c1749095d546bab068038e1959e2f5f4d971b';

@ProviderFor(vocabularyLocalCache)
final vocabularyLocalCacheProvider = VocabularyLocalCacheProvider._();

final class VocabularyLocalCacheProvider
    extends
        $FunctionalProvider<
          VocabularyLocalCache,
          VocabularyLocalCache,
          VocabularyLocalCache
        >
    with $Provider<VocabularyLocalCache> {
  VocabularyLocalCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyLocalCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyLocalCacheHash();

  @$internal
  @override
  $ProviderElement<VocabularyLocalCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VocabularyLocalCache create(Ref ref) {
    return vocabularyLocalCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabularyLocalCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabularyLocalCache>(value),
    );
  }
}

String _$vocabularyLocalCacheHash() =>
    r'c45e0d0f874def16f4d209c0bbf30ec71116da5e';

@ProviderFor(vocabularyRepository)
final vocabularyRepositoryProvider = VocabularyRepositoryProvider._();

final class VocabularyRepositoryProvider
    extends
        $FunctionalProvider<
          VocabularyRepository,
          VocabularyRepository,
          VocabularyRepository
        >
    with $Provider<VocabularyRepository> {
  VocabularyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'vocabularyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$vocabularyRepositoryHash();

  @$internal
  @override
  $ProviderElement<VocabularyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  VocabularyRepository create(Ref ref) {
    return vocabularyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VocabularyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VocabularyRepository>(value),
    );
  }
}

String _$vocabularyRepositoryHash() =>
    r'9391cc8e8111d20cfa440b23fab78765caba2c85';
