import 'package:flutter/material.dart';
import 'package:flutter_supabase_signin/src/main/start_app.dart';
import 'package:flutter_supabase_signin/src/pages/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      }
    });
  }

  Future<AuthResponse> _googleSignIn() async {
    const serverClientId = '14731832038-qkqpt4u9tl95u20506pv22li7tsafnsa.apps.googleusercontent.com';

    const iosClientId = '14731832038-ksgjtf8a2tv1qr6etrnjvbbd1rpa94sv.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: serverClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _googleSignIn,
          child: const Text('Google login'),
        ),
      ),
    );
  }
}
