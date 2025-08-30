import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:magoosh_gre_app_clone/main.dart';
import 'package:magoosh_gre_app_clone/service/auth_service/create_account_service.dart';
import 'package:magoosh_gre_app_clone/ui/screens/auth%20screens/login_screen.dart';
import 'package:magoosh_gre_app_clone/ui/widgets/my_text_form_field.dart';
import 'package:magoosh_gre_app_clone/utils/app_colors.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

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
          height: 300,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _globalKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 20,
                children: [
                  Text(
                    "Create Account",
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
                      onPressed: _onPressedCreateAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.themeColor,
                        fixedSize: Size.fromWidth(double.maxFinite),
                        foregroundColor: Colors.white,
                      ),
                      child: Text("Create Account"),
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

  Future<void> _onPressedCreateAccount() async {
    if (!_globalKey.currentState!.validate()) return;

    _inProgress = true;
    setState(() {});

    final res = await createUser(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (res.isSuccessful) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (_) => false,
        );
      }

      final Map<String, dynamic> userInfo = {
        'user_id': res.data,
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      };

      await supabase.from('users').insert(userInfo);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
      }
    }

    _inProgress = false;
    setState(() {});
  }
}
