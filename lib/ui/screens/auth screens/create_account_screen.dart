import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import '../../../service/auth service/create_new_user_service.dart';
import '../../../main.dart';
import 'login_screen.dart';
import '../../widgets/my_text_form_field.dart';
import '../../../utils/app_colors.dart';

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
                    isPasswordField: true,
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

      try{
        final Map<String, dynamic> userInfo = {
          'user_id': res.data,
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        };

        await supabase.from('users').insert(userInfo);

        final Map<String, dynamic> userSolvedQuestionInfo = {
          'user_id': res.data,
          'solved_question': [],
        };

        await supabase.from('solved').insert(userSolvedQuestionInfo);
      }catch(e){
        doShowLogger? logger.e(e.toString()) : null;
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), duration: Duration(seconds: 4)),
        );
      }
    }

    _inProgress = false;
    setState(() {});
  }
}
