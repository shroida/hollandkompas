import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/core/router/app_router.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/holland_kompas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  runApp(const ProviderScope(child: HollandKompas()));
}

Future<void> _initializeApp() async {
  await Future.wait([SupabaseManager.init(), HiveService.init()]);

  _listenToAuthChanges();
}

void _listenToAuthChanges() {
  Supabase.instance.client.auth.onAuthStateChange.listen(
    (data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        appRouter.go('/reset-password');
      }
    },
    onError: (error, stackTrace) {
      debugPrint('Auth state error: $error');
    },
  );
}
