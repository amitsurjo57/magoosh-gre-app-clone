import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class MyTextFormField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final TextStyle? hintStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final bool isPasswordField;
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
    this.isPasswordField = false,
  });

  @override
  State<MyTextFormField> createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  bool _isObscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.textEditingController,
      obscureText: widget.isPasswordField ? _isObscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPasswordField
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                child: Icon(
                  _isObscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.themeColor,
                ),
              )
            : widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.themeColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.themeColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 2,
          ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
