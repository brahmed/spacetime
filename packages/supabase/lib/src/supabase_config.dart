/// Supabase connection configuration loaded from dart-define environment variables.
///
/// Pass values at build/run time using:
/// ```
/// flutter run --dart-define-from-file=.env.json
/// ```
abstract final class SupabaseConfig {
  static const url = String.fromEnvironment('SUPABASE_URL');
  static const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const edgeBaseUrl = String.fromEnvironment('SUPABASE_EDGE_BASE_URL');

  /// Asserts that all required config values are present.
  /// Call once during app bootstrap.
  static void validate() {
    assert(url.isNotEmpty, 'SUPABASE_URL is not set via --dart-define-from-file');
    assert(anonKey.isNotEmpty, 'SUPABASE_ANON_KEY is not set via --dart-define-from-file');
  }
}
