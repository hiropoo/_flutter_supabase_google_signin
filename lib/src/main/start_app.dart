import 'package:flutter/material.dart';
import 'package:flutter_supabase_signin/env/environment.dart';
import 'package:flutter_supabase_signin/src/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void startApp() async {
  /// TODO: update Supabase credentials with your own
  await Supabase.initialize(
    url: Environment.instance.supabaseUrl,
    anonKey: Environment.instance.supabaseAnonKey,
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
