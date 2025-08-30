import 'package:flutter/material.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/my_text_form_field.dart';
import 'package:email_validator/email_validator.dart';
import '../../../service/auth_service/login_service.dart';
import 'package:magoosh_gre_app_clone/ui/screens/auth%20screens/create_account_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _inProgress = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          height: 330,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                children: [
                  Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.themeColor,
                    ),
                  ),
                  MyTextFormField(
                    textEditingController: _emailController,
                    hintText: "Enter Your Email",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: AppColors.themeColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!EmailValidator.validate(value)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  MyTextFormField(
                    textEditingController: _passwordController,
                    hintText: "Enter Your Password",
                    isObscure: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: AppColors.themeColor,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                  ),
                  Visibility(
                    visible: !_inProgress,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: _onPressedLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        fixedSize: Size.fromWidth(double.maxFinite),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Log In"),
                    ),
                  ),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateAccountScreen(),
                            ),
                          ),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: AppColors.themeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onPressedLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _inProgress = true;
    setState(() {});

    final responseModel = await loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (responseModel.isSuccessful) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseModel.message)));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(responseModel.message)));
      }
    }

    _inProgress = false;
    setState(() {});
  }
}
