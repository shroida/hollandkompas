import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hollandkompas/core/providers/supabase_provider.dart';

import '../datasource/auth_remote_data_source.dart';

final authRemoteDataSourceProvider = Provider<SupabaseAuthRemoteDataSource>((
  ref,
) {
  return SupabaseAuthRemoteDataSource(ref.watch(supabaseClientProvider));
});
