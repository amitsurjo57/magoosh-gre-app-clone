import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main.dart';
import '../../models/response_model.dart';

Future<ResponseModel> createUser({
  required String email,
  required String password,
}) async {
  try {
    final res = await supabase.auth.signUp(email: email, password: password);

    final message =
        "A verification link has been sent to your email.\nPlease verify you email and log in.";

    final isSuccessful = true;

    logger.d("Message: $message\nisSuccessful: $isSuccessful");

    return ResponseModel(
      message: message,
      isSuccessful: isSuccessful,
      data: res.user!.id,
    );
  } on AuthApiException catch (e) {
    logger.e(e.toString());
    if (e.code == 'over_email_send_rate_limit') {
      String msg = e.message;
      msg = msg.replaceAll("this", "for verification");
      logger.e(msg);
      return ResponseModel(message: msg, isSuccessful: false);
    } else if (e.code == 'email_address_invalid') {
      return ResponseModel(message: e.message, isSuccessful: false);
    }
  } catch (e) {
    logger.e(e.toString());
  }
  return ResponseModel(message: "Something went wrong", isSuccessful: false);
}
