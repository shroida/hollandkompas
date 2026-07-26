import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hollandkompas/core/config/supabase_config.dart';

import 'holland_kompas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.init();

  runApp(
    const ProviderScope(
      child: HollandKompas(),
    ),
  );
}