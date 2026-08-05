import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/core/router/app_router.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/holland_kompas.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.init();


  await HiveService.init();

 Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  debugPrint("EVENT: ${data.event}");
  debugPrint("SESSION: ${data.session != null}");

Supabase.instance.client.auth.onAuthStateChange.listen((data) {
  if (data.event == AuthChangeEvent.passwordRecovery) {
    appRouter.go('/reset-password');
  }
});
});
  runApp(
    const ProviderScope(
      child: HollandKompas(),
    ),
  );
}