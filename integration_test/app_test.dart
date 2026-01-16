// patrol develop --target integration_test/app_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:magoosh_gre_app_clone/main.dart';
import 'package:magoosh_gre_app_clone/ui/screens/auth%20screens/login_screen.dart';
import 'package:magoosh_gre_app_clone/utils/app_theme.dart';
import 'package:patrol/patrol.dart';
import 'package:flutter/material.dart';

void main() {
  patrolTest(
    'App Test',
    framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    ($) async {
      await initializeSupabase();

      await $.pumpWidgetAndSettle(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.appTheme(),
          home: LoginScreen(),
        ),
      );

      await $(#emailField).enterText('amitsurjo57@gmail.com');
      await $(#passwordField).enterText('123456789');
      await $(#login).tap();

      final questionGroup = $(#practice_this_deck_8);
      await questionGroup.scrollTo();
      await wait(2);
      await questionGroup.tap();

      await $('Tap to see meaning').tap();
      await $('I knew this word').tap();
      await $(Icons.arrow_back).tap();

      await questionGroup.scrollTo();
      await wait(2);

      await $(Icons.menu).tap();
      await $('Sign out').tap();
    },
  );
}

Future<void> wait(int seconds) async {
  await Future.delayed(Duration(seconds: seconds));
}
