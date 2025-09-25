import 'package:flutter/material.dart';
import '../../service/auth service/shared_preference_service.dart';
import '../screens/auth%20screens/login_screen.dart';
import '../../utils/app_colors.dart';
import '../../main.dart';

Drawer commonDrawer(BuildContext context) => Drawer(
  backgroundColor: AppColors.themeColor,
  child: Column(
    children: [
      Image.asset('assets/images/magoosh.png', width: 250),
      InkWell(
        onTap: () async => _onTapSignOut(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Sign out",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(color: Colors.white, height: 0, indent: 10),
          ],
        ),
      ),
    ],
  ),
);

Future<void> _onTapSignOut(BuildContext context) async {
  await supabase.auth.signOut();
  await SharedPreferenceService().clearData();
  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (_) => false,
    );
  }
}
