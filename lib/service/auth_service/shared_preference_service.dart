import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  final String _saveKey = "saveKey";

  Future<void> saveData(String uid) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.setString(_saveKey, uid);
  }

  Future<String?> getData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString(_saveKey);
  }

  Future<bool> isLooggedIn() async{
    String? uid = await getData();

    if(uid != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void> clearData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    sharedPreferences.clear();
  }
}
