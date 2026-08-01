import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://luemujpnocopxmaomtyd.supabase.co',
      anonKey: 'sb_publishable_AM0TsYrIr5uYjH4isEukDA_GPJ3ILP_',
    );
  }
}
