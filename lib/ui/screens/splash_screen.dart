import 'dart:async';

import 'package:flutter/material.dart';
import 'auth%20screens/login_screen.dart';
import '../../utils/image_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _imageAnimation;
  late Animation _textAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();

    _imageAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    _textAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    Timer(Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(ImagePaths.logo, width: _imageAnimation.value),
              Text(
                "GRE Vocabulary",
                style: TextStyle(
                  fontSize: _textAnimation.value,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
