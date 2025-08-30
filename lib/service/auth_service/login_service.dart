import 'package:logger/logger.dart';
import 'package:magoosh_gre_app_clone/models/response_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';

final Logger _logger = Logger();

Future<ResponseModel> loginUser({
  required String email,
  required String password,
}) async {
  try {
    final res = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final message = "Logged in Successfully";

    final isSuccessful = true;

    _logger.d("Message: $message\nisSuccessful: $isSuccessful");

    return ResponseModel(
      message: message,
      isSuccessful: isSuccessful,
      data: res.user!.id,
    );
  } on AuthApiException catch (e) {
    _logger.e(e.toString());
    if (e.code == "invalid_credentials") {
      return ResponseModel(message: "User Not Found", isSuccessful: false);
    }else if(e.code == 'email_not_confirmed'){
      return ResponseModel(message: e.message, isSuccessful: false);
    }
  } catch (e) {
    _logger.e(e.toString());
  }
  return ResponseModel(message: "Something went wrong", isSuccessful: false);
}
