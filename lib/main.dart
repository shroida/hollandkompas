import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/holland_kompas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  runApp(const ProviderScope(child: HollandKompas()));
}

Future<void> _initializeApp() async {
  await Future.wait<void>([SupabaseManager.init(), HiveService.init()]);
}
