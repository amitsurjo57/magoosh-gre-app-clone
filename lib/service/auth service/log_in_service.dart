import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../models/response_model.dart';

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

    doShowLogger? logger.d("Message: $message\nisSuccessful: $isSuccessful") : null;

    return ResponseModel(
      message: message,
      isSuccessful: isSuccessful,
      data: res.user!.id,
    );
  } on AuthApiException catch (e) {
    doShowLogger? logger.e(e.toString()) : null;
    if (e.code == "invalid_credentials") {
      return ResponseModel(message: "User Not Found", isSuccessful: false);
    } else if (e.code == 'email_not_confirmed') {
      return ResponseModel(message: e.message, isSuccessful: false);
    }
  } catch (e) {
    doShowLogger? logger.e(e.toString()) : null;
  }
  return ResponseModel(message: "Something went wrong", isSuccessful: false);
}
