import 'package:flutter_supabase_signin/env/environment.dart';
import 'package:flutter_supabase_signin/src/main/start_app.dart';

Future<void> main() async {
  Environment.setup(flavor: Flavor.stg);
  startApp();
}
