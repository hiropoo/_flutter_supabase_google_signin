## 本番環境

1. GCPでプロジェクトを作成
2. OAuth同意画面でアプリ情報を入力する。この時、承認済みドメインに、`[supabase Reference ID].supabase.co` を入力
3. スコープの追加を押して、
    - `.../auth/userinfo.email`
    - `.../auth/userinfo.profile`
    - `openid`
    
    を選択して非機密のスコープに追加
    
4. 認証情報から、OAuthクライアントIDを選択して、WebクライアントIDとiOSクライアントIDを作成する。
    - この時、WebクライアントID作成時は、承認済みのリダイレクトURIに`https://[supabase Reference ID].supabase.co/auth/v1/callback` を追加する（Authentication → Providers → Google → Callback URLに記載されている）。
    - iOSクライアントの作成時は、バンドルIDを入力する。バンドルIDはRunner.xcodeprojをXcodeで開き、RunnerのGeneralに記載されている。
5. Supabaseのダッシュボードから`Authentication → Providers → Google`を開く
    - Enable Sign in with Google をtureにする
    - クライアントIDとClient Secretは何も入力しない（値が入っている場合は削除）
    - Authorized Client IDsにWebクライアントIDを入力して保存する。
6. iOS/Runner/info.plst に次の`CFBundleURLTypes` のkeyと値`<string>[Google Client ID (ios)の逆ドメイン]</string>`を追加
   
    ```xml
    <key>CFBundleURLTypes</key>
    	<array>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>com.googleusercontent.apps.14731832038-ksgjtf8a2tv1qr6etrnjvbbd1rpa94sv</string>
    			</array>
    		</dict>
    	</array>
    ```

- `info.plst` 全体
    
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    	<key>CFBundleDevelopmentRegion</key>
    	<string>$(DEVELOPMENT_LANGUAGE)</string>
    	<key>CFBundleDisplayName</key>
    	<string>$(PRODUCT_NAME)</string>
    	<key>CFBundleExecutable</key>
    	<string>$(EXECUTABLE_NAME)</string>
    	<key>CFBundleIdentifier</key>
    	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    	<key>CFBundleInfoDictionaryVersion</key>
    	<string>6.0</string>
    	<key>CFBundleName</key>
    	<string>$(BUNDLE_NAME)</string>
    	<key>CFBundlePackageType</key>
    	<string>APPL</string>
    	<key>CFBundleShortVersionString</key>
    	<string>$(FLUTTER_BUILD_NAME)</string>
    	<key>CFBundleSignature</key>
    	<string>????</string>
    	<key>CFBundleVersion</key>
    	<string>$(FLUTTER_BUILD_NUMBER)</string>
    	<key>LSRequiresIPhoneOS</key>
    	<true/>
    	<key>UILaunchStoryboardName</key>
    	<string>LaunchScreen</string>
    	<key>UIMainStoryboardFile</key>
    	<string>Main</string>
    	<key>UISupportedInterfaceOrientations</key>
    	<array>
    		<string>UIInterfaceOrientationPortrait</string>
    		<string>UIInterfaceOrientationLandscapeLeft</string>
    		<string>UIInterfaceOrientationLandscapeRight</string>
    	</array>
    	<key>UISupportedInterfaceOrientations~ipad</key>
    	<array>
    		<string>UIInterfaceOrientationPortrait</string>
    		<string>UIInterfaceOrientationPortraitUpsideDown</string>
    		<string>UIInterfaceOrientationLandscapeLeft</string>
    		<string>UIInterfaceOrientationLandscapeRight</string>
    	</array>
    	<key>CADisableMinimumFrameDurationOnPhone</key>
    	<true/>
    	<key>UIApplicationSupportsIndirectInputEvents</key>
    	<true/>
    	<key>CFBundleURLTypes</key>
    	<array>
    		<dict>
    			<key>CFBundleTypeRole</key>
    			<string>Editor</string>
    			<key>CFBundleURLSchemes</key>
    			<array>
    				<string>com.googleusercontent.apps.14731832038-ksgjtf8a2tv1qr6etrnjvbbd1rpa94sv</string>
    			</array>
    		</dict>
    	</array>
    </dict>
    </plist>
    ```
    
1. Flutterにgoogle signIn のコードを追加
    
    ```Dart
    import 'package:flutter/material.dart';
    import 'package:flutter_supabase_signin/env/environment.dart';
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
        final serverClientId = Environment.instance.googleServerClientId;
    
        final iosClientId = Environment.instance.googleClientId;
    
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
    
    ```
    

## ローカル環境

プロジェクトのルートで`supabase init` を実行しローカル環境を用意

1. supabaseディレクトリ内の`config.toml` 内に次の追加
    
    ```toml
    [auth.external.google]
    enabled = true
    client_id = "env(GOOGLE_SERVER_CLIENT_ID)"
    redirect_uri = "http://localhost:54321/auth/v1/callback"
    skip_nonce_check = true
    ```
    
2. ただし、client_idは環境変数にするために、supabaseディレクトリ内の最上位に.envを作成し、.env内に`GOOGLE_SERVER_CLIENT_ID=` を追加
3. cofig.toml内に記載する、client_id はwebクライアントIDであることに注意
