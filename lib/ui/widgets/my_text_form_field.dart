import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool isObscure;
  final String? Function(String?) validator;

  const MyTextFormField({
    super.key,
    required this.textEditingController,
    required this.hintText,
    required this.validator,
    this.hintStyle,
    this.labelText,
    this.labelStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.isObscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: textEditingController,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.themeColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: AppColors.themeColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme
                .of(context)
                .scaffoldBackgroundColor,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
