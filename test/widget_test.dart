import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:magoosh_gre_app_clone/ui/screens/app%20screens/home_screen.dart';
import 'package:magoosh_gre_app_clone/ui/screens/auth%20screens/login_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets("Navigation Test", (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));
    await tester.enterText(
      find.byKey(ValueKey('emailField')),
      'amitsurjo57@gmail.com',
    );
    await tester.enterText(find.byKey(ValueKey('passwordField')), '123456789');
    await tester.tap(find.byKey(ValueKey('login')));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

class MockSupabaseClient extends Mock implements MockGoTrueClient {
  get auth => MockGoTrueClient();
}

class MockGoTrueClient extends Mock implements GoTrueClient {
  final _user = User(
    id: 'id',
    appMetadata: {},
    userMetadata: {},
    aud: 'aud',
    createdAt: DateTime.now().toIso8601String(),
  );

  @override
  Future<AuthResponse> signInWithPassword({
    String? email,
    String? phone,
    required String password,
    String? captchaToken,
  }) async {
    return AuthResponse(
      session: Session(accessToken: '', tokenType: '', user: _user),
      user: _user,
    );
  }

  @override
  Future<AuthResponse> signUp({
    String? email,
    String? phone,
    required String password,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) async {
    return AuthResponse(
      session: Session(accessToken: '', tokenType: '', user: _user),
      user: _user,
    );
  }
}
