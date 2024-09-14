import 'package:envied/envied.dart';

part 'local_env.g.dart';

@Envied(path: '.env.local')
abstract class LocalEnv {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _LocalEnv.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _LocalEnv.supabaseAnonKey;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID', obfuscate: true)
  static final String googleClientId = _LocalEnv.googleClientId;

  @EnviedField(varName: 'GOOGLE_SERVER_CLIENT_ID', obfuscate: true)
  static final String googleServerClientId = _LocalEnv.googleServerClientId;
}
