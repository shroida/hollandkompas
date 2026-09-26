import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/flashcards_repository.dart';
import '../datasources/flashcards_remote_data_source.dart';
import '../repositories/flashcards_repository_impl.dart';

final flashcardsRemoteDataSourceProvider = Provider<FlashcardsRemoteDataSource>(
  (ref) {
    final client = Supabase.instance.client;

    final dataSource = FlashcardsRemoteDataSource(client, tts: FlutterTts());

    Future.microtask(() {
      dataSource.initialize();
    });

    ref.onDispose(() {
      dataSource.dispose();
    });

    return dataSource;
  },
);
final flashcardsRepositoryProvider = Provider<FlashcardsRepository>((ref) {
  return FlashcardsRepositoryImpl(
    ref.watch(flashcardsRemoteDataSourceProvider),
  );
});
