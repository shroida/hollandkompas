import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/config/supabase_config.dart';
import 'package:hollandkompas/core/storage/hive_service.dart';
import 'package:hollandkompas/core/theme/app_theme.dart';
import 'package:hollandkompas/holland_kompas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.init();
  await HiveService.init();

runApp(
  ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: HollandKompas(),
    ),
  ),
);
}