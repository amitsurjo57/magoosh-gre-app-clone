import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'service/auth service/shared_preference_service.dart';
import 'ui/screens/splash_screen.dart';
import 'utils/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final Logger logger = Logger();

final SharedPreferenceService sharedPreferenceService =
    SharedPreferenceService();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeSupabase();
  runApp(MagooshGreAppClone());
}

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'https://ssbnwxgtddzuktgloajv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNzYm53eGd0ZGR6dWt0Z2xvYWp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYyMTUyNDEsImV4cCI6MjA3MTc5MTI0MX0.You994q3fldXMKW7kFAZ44AKzsQ4KTsHKiZ8PXbQ-7M',
  );
}

final SupabaseClient supabase = Supabase.instance.client;

class MagooshGreAppClone extends StatefulWidget {
  const MagooshGreAppClone({super.key});

  @override
  State<MagooshGreAppClone> createState() => _MagooshGreAppCloneState();
}

class _MagooshGreAppCloneState extends State<MagooshGreAppClone> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme(),
      home: SplashScreen(),
    );
  }
}
