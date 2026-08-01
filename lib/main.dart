import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/network/supabase_client.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/holland_kompas.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseManager.init();


  await HiveService.init();

  runApp(
    const ProviderScope(
      child: HollandKompas(),
    ),
  );
}