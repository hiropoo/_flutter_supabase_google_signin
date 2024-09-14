import 'package:envied/envied.dart';

part 'stg_env.g.dart';

@Envied(path: '.env')
abstract class StgEnv {
  @EnviedField(varName: 'SUPABASE_URL', obfuscate: true)
  static final String supabaseUrl = _StgEnv.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY', obfuscate: true)
  static final String supabaseAnonKey = _StgEnv.supabaseAnonKey;

  @EnviedField(varName: 'GOOGLE_CLIENT_ID', obfuscate: true)
  static final String googleClientId = _StgEnv.googleClientId;

  @EnviedField(varName: 'GOOGLE_SERVER_CLIENT_ID', obfuscate: true)
  static final String googleServerClientId = _StgEnv.googleServerClientId;
}
