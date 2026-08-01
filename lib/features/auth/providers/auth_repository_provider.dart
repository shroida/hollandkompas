import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hollandkompas/features/auth/domain/repositories/auth_repository.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});