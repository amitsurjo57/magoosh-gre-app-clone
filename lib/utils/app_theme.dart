import 'package:flutter/material.dart';
import 'package:magoosh_gre_app_clone/utils/app_colors.dart';

class AppTheme{
  static ThemeData appTheme(){
    return ThemeData(
      scaffoldBackgroundColor: AppColors.themeColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.themeColor,
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white
      )
    );
  }
}