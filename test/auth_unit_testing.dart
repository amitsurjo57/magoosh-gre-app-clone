import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('log in test', () async {
    final supabase = MockSupabaseClient();

    AuthResponse response = await supabase.auth.signInWithPassword(
      email: 'amitsurjo57@gmail.com',
      password: '123456789',
    );
    expect(response.user, isA<User>());
  });

  test('sign up test', () async {
    final supabase = MockSupabaseClient();

    AuthResponse response = await supabase.auth.signUp(
      email: 'amitsurjo57@gmail.com',
      password: '123456789',
    );

    expect(response.user, isA<User>());
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
