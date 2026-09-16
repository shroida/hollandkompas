import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasource/vocabulary_local_cache.dart';
import '../../data/datasource/vocabulary_remote_datasource.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import '../../domain/repositories/vocabulary_repository.dart';

part 'vocabulary_repository_provider.g.dart';

@Riverpod(keepAlive: true)
VocabularyRemoteDataSource vocabularyRemoteDataSource(Ref ref) {
  return VocabularyRemoteDataSourceImpl(Supabase.instance.client);
}

@Riverpod(keepAlive: true)
VocabularyLocalCache vocabularyLocalCache(Ref ref) {
  return VocabularyLocalCache();
}

@Riverpod(keepAlive: true)
VocabularyRepository vocabularyRepository(Ref ref) {
  return VocabularyRepositoryImpl(
    ref.watch(vocabularyRemoteDataSourceProvider),
    ref.watch(vocabularyLocalCacheProvider),
    Supabase.instance.client,
  );
}
