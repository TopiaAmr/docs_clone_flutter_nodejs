import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepo {
  void setToke(String token) async {
    await SharedPreferences.getInstance().then(
      (pref) => pref.setString('auth-token', token),
    );
  }

  Future<String?> readToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString('auth-token');
  }
}
