import 'package:flutter_supabase_signin/env/local_env.dart';
import 'package:flutter_supabase_signin/env/prod_env.dart';
import 'package:flutter_supabase_signin/env/stg_env.dart';

enum Flavor {
  local,
  stg,
  prod,
}

class Environment {
  static Environment? _instance;

  static Environment get instance {
    if (_instance == null) {
      throw Exception('Environment not set. You need to `setup` before using it.');
    }
    return _instance!;
  }

  Environment({
    required this.flavor,
  });

  final Flavor flavor;

  String get supabaseUrl => switch (flavor) {
        Flavor.local => LocalEnv.supabaseUrl,
        Flavor.stg => StgEnv.supabaseUrl,
        Flavor.prod => ProdEnv.supabaseUrl,
      };

  String get supabaseAnonKey => switch (flavor) {
        Flavor.local => LocalEnv.supabaseAnonKey,
        Flavor.stg => StgEnv.supabaseAnonKey,
        Flavor.prod => ProdEnv.supabaseAnonKey,
      };

  String? get googleClientId => switch (flavor) {
        Flavor.local => LocalEnv.googleClientId,
        Flavor.stg => StgEnv.googleClientId,
        Flavor.prod => ProdEnv.googleClientId,
      };

  String get googleServerClientId => switch (flavor) {
        Flavor.local => LocalEnv.googleServerClientId,
        Flavor.stg => StgEnv.googleServerClientId,
        Flavor.prod => ProdEnv.googleServerClientId,
      };

  static void setup({required Flavor flavor}) {
    _instance = Environment(
      flavor: flavor,
    );
  }
}
