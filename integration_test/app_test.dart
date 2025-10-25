import 'package:flutter_test/flutter_test.dart';
import 'package:magoosh_gre_app_clone/main.dart';
import 'package:magoosh_gre_app_clone/ui/screens/auth%20screens/login_screen.dart';
import 'package:magoosh_gre_app_clone/utils/app_theme.dart';
import 'package:patrol/patrol.dart';
import 'package:flutter/material.dart';

void main() {
  patrolTest(
    'Log In Test',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      await initializeSupabase();

      await $.pumpWidgetAndSettle(MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme(),
          home: LoginScreen()));

      await $(#emailField).enterText('amitsurjo57@gmail.com');
      await $(#passwordField).enterText('123456789');
      await $(#login).tap();
      await $('Practice this deck').tap();
      await $('Tap to see meaning').tap();
      await $('I knew this word').tap();
      await $(Icons.arrow_back).tap();
      await $(Icons.menu).tap();
      await $('Sign out').tap();
    },
  );
}
