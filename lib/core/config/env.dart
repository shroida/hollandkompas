class Env {
  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');

  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  static const appEnv =
      String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );


  static bool get isProduction =>
      appEnv == 'production';


  static bool get isDevelopment =>
      appEnv == 'development';
}