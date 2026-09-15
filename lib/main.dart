import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/core/router/app_router.dart';
import 'package:hollandkompas/core/router/route_paths.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/holland_kompas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();
  _listenToAuthChanges();

  runApp(const ProviderScope(child: HollandKompas()));
}

Future<void> _initializeApp() async {
  await Future.wait<void>([SupabaseManager.init(), HiveService.init()]);
}

void _listenToAuthChanges() {
  Supabase.instance.client.auth.onAuthStateChange.listen(
    _handleAuthStateChange,
    onError: (Object error, StackTrace stackTrace) {
      debugPrint('Auth stream error: $error');
    },
  );
}

void _handleAuthStateChange(AuthState state) {
  if (state.event == AuthChangeEvent.passwordRecovery) {
    appRouter.go(RoutePaths.resetPassword);
  }
}
